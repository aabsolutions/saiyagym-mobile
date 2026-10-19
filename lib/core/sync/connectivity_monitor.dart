import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// "Has a network" from the OS. Not a guarantee of reaching the API (a
/// captive Wi-Fi counts as online): the sync result is the real verdict.
abstract interface class ConnectivityMonitor {
  Future<bool> isOnline();

  /// Emits on every change.
  Stream<bool> get changes;
}

class PlatformConnectivityMonitor implements ConnectivityMonitor {
  PlatformConnectivityMonitor([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  static bool _online(List<ConnectivityResult> results) =>
      results.any((result) => result != ConnectivityResult.none);

  @override
  Future<bool> isOnline() async =>
      _online(await _connectivity.checkConnectivity());

  @override
  Stream<bool> get changes =>
      _connectivity.onConnectivityChanged.map(_online).distinct();
}
