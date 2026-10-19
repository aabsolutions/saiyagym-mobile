import 'package:flutter/services.dart';

/// Light tap confirming a key action (saved, favorite, queued…). Silent
/// where the platform has no haptics; never throws.
Future<void> confirmHaptic() async {
  try {
    await HapticFeedback.lightImpact();
  } on Object {
    // No haptics available.
  }
}
