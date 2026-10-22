import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saiyagym_mobile/app/sync/background_sync.dart';
import 'package:saiyagym_mobile/core/sync/sync_providers.dart';
import 'package:saiyagym_mobile/core/sync/sync_state.dart';
import 'package:saiyagym_mobile/features/auth/presentation/controllers/session_controller.dart';
import 'package:saiyagym_mobile/features/progress_photos/progress_photos_providers.dart';
import 'package:saiyagym_mobile/features/reminders/reminders_providers.dart';
import 'package:saiyagym_mobile/features/sounds/sounds_providers.dart';

part 'sync_coordinator.g.dart';

@Riverpod(keepAlive: true)
BackgroundSyncScheduler backgroundSyncScheduler(Ref ref) =>
    WorkmanagerBackgroundSync();

/// Decides WHEN to sync (the service decides how):
/// sign-in / app open, network back, app resumed or sent to background,
/// language change (catalog), periodic background work. Also uploads
/// queued progress photos (sign-in, network back). Local edits and
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
      // Reminder sounds changed (choice, download done) or, at start, may
      // differ from the schedule: reapply it (no-op when nothing changed).
      ..listen(reminderSoundsProvider, (previous, next) {
        final sounds = next.value;
        if (sounds == null) return;
        unawaited(
          _guard(
            ref
                .read(remindersControllerProvider.notifier)
                .soundsChanged(sounds),
          ),
        );
      }, fireImmediately: true)
      ..onDispose(_detach);
  }

  void _signedIn({required bool changed}) {
    if (_active && !changed) return;
    _active = true;
    ref.read(syncServiceProvider)
      ..start()
      ..requestSync(SyncReason.appOpen);
    _uploadPhotos();
    if (changed) _dropWiped(refreshSounds: true);
    _attach();
    unawaited(_guard(ref.read(backgroundSyncSchedulerProvider).schedule()));
  }

  void _signedOut() {
    if (!_active) return;
    _active = false;
    _detach();
    unawaited(ref.read(syncServiceProvider).stop());
    _dropWiped();
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
      _uploadPhotos();
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

  /// Logout (or another user signing in) wiped the reminder settings and the
  /// sound record; an expired session keeps them, and its reminders and
  /// sounds too. Each step is guarded on its own: one failing must not skip
  /// the other.
  ///
  /// On sign-in ([refreshSounds]) the purge is followed, in order, by
  /// dropping sounds no purpose selects and a best-effort download of the
  /// reminder sounds (new device).
  void _dropWiped({bool refreshSounds = false}) {
    unawaited(
      _guard(ref.read(remindersControllerProvider.notifier).cancelIfWiped()),
    );
    final sounds = ref.read(soundHousekeepingProvider);
    unawaited(
      _guard(() async {
        await sounds.purgeIfWiped();
        if (!refreshSounds) return;
        await sounds.retainSelected();
        await sounds.prefetch();
      }()),
    );
  }

  /// Photos queued offline (their own outbox, not `sync_queue`).
  void _uploadPhotos() =>
      unawaited(_guard(ref.read(photoUploadQueueProvider).process()));

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
