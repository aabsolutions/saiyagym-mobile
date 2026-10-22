import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_channels.g.dart';

/// Channel ids to delete: every one that starts with [prefix] except [keep].
/// Channels outside the prefix (e.g. the default ones) are never touched.
List<String> staleChannels(
  Iterable<String> existing, {
  required String prefix,
  required String keep,
}) => [
  for (final id in existing)
    if (id.startsWith(prefix) && id != keep) id,
];

/// Android notification channels (a channel's sound can't change once
/// created, so replaced / unselected sounds mean deleting channels). Other
/// platforms: no channels, every call is a no-op.
abstract interface class NotificationChannels {
  Future<List<String>> ids();

  Future<void> delete(String id);
}

class PluginNotificationChannels implements NotificationChannels {
  PluginNotificationChannels({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  @override
  Future<List<String>> ids() async {
    final existing = await _android?.getNotificationChannels() ?? const [];
    return [for (final channel in existing) channel.id];
  }

  @override
  Future<void> delete(String id) async {
    await _android?.deleteNotificationChannel(channelId: id);
  }
}

@Riverpod(keepAlive: true)
NotificationChannels notificationChannels(Ref ref) =>
    PluginNotificationChannels();
