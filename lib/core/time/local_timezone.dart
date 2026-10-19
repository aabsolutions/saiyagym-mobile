import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_timezone.g.dart';

/// The device's IANA timezone (`Europe/Madrid`), for the API's `tz`
/// parameter and local reminders. `UTC` when the platform can't tell.
@Riverpod(keepAlive: true)
Future<String> localTimezone(Ref ref) async {
  try {
    final info = await FlutterTimezone.getLocalTimezone();
    return info.identifier.isEmpty ? 'UTC' : info.identifier;
  } on Object {
    return 'UTC';
  }
}
