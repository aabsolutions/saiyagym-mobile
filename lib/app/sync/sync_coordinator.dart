import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/app/sync/background_sync.dart';
import 'package:saiyagym_mobile/core/sync/sync_providers.dart';
import 'package:saiyagym_mobile/core/sync/sync_state.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';

part 'sync_coordinator.g.dart';

@Riverpod(keepAlive: true)
BackgroundSyncScheduler backgroundSyncScheduler(Ref ref) =>
    WorkmanagerBackgroundSync();

/// Decides WHEN to sync (the service decides how):
/// sign-in / app open, network back, app resumed or sent to background,
/// language change (catalog), periodic background work. Local edits and
/// finished workouts request it themselves.
@Riverpod(keepAlive: true)
class SyncCoordinator extends _$SyncCoordinator {
  AppLifecycleListener? _lifecycle;
  StreamSubscription<bool>? _connectivity;
  bool _online = true;
  bool _active = false;

  @override
  void build() {
    ref
      ..listen(
        sessionControllerProvider.select((s) => s.value?.user.id),
        (previous, userId) => userId == null
            ? _signedOut()
            : _signedIn(changed: previous != userId),
        fireImmediately: true,
      )
      ..onDispose(_detach);
  }

  void _signedIn({required bool changed}) {
    if (_active && !changed) return;
    _active = true;
    ref.read(syncServiceProvider)
      ..start()
      ..requestSync(SyncReason.appOpen);
    _attach();
    unawaited(_guard(ref.read(backgroundSyncSchedulerProvider).schedule()));
  }

  void _signedOut() {
    if (!_active) return;
    _active = false;
    _detach();
    unawaited(ref.read(syncServiceProvider).stop());
    unawaited(_guard(ref.read(backgroundSyncSchedulerProvider).cancel()));
  }

  void _attach() {
    _lifecycle ??= AppLifecycleListener(
      onResume: () => _request(SyncReason.appResumed),
      // Last chance before the OS may kill us: push the finished set.
      onPause: () => _request(SyncReason.appPaused),
    );
    _connectivity ??= ref.read(connectivityMonitorProvider).changes.listen((
      online,
    ) {
      final regained = online && !_online;
      _online = online;
      if (!regained) return;
      _request(SyncReason.connectivity);
      // Opened offline: refresh the profile too now that we can.
      if (ref.read(sessionControllerProvider).value?.isOffline ?? false) {
        unawaited(
          _guard(ref.read(sessionControllerProvider.notifier).refreshUser()),
        );
      }
    });
  }

  void _detach() {
    _lifecycle?.dispose();
    _lifecycle = null;
    unawaited(_connectivity?.cancel());
    _connectivity = null;
  }

  /// The catalog is stored in the UI language.
  void languageChanged() => _request(SyncReason.languageChanged);

  void _request(SyncReason reason) {
    if (_active) ref.read(syncServiceProvider).requestSync(reason);
  }

  /// Triggers are fire-and-forget: failures surface in the sync state.
  static Future<void> _guard(Future<void> future) async {
    try {
      await future;
    } on Object {
      // Reported through SyncState / session banners.
    }
  }
}
