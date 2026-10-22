import 'package:saiyagym_mobile/core/notifications/notification_channels.dart';

/// In-memory [NotificationChannels]: seed [existing], read back [deleted].
class FakeNotificationChannels implements NotificationChannels {
  FakeNotificationChannels([Iterable<String> existing = const []])
    : existing = [...existing];

  final List<String> existing;
  final deleted = <String>[];

  @override
  Future<List<String>> ids() async => [...existing];

  @override
  Future<void> delete(String id) async {
    existing.remove(id);
    deleted.add(id);
  }
}
