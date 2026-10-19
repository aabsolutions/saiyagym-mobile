import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_settings.freezed.dart';
part 'reminder_settings.g.dart';

/// Local reminders of THIS device (notifications are per device, so they
/// aren't synced). Weekdays are ISO: 1 = Monday … 7 = Sunday.
@freezed
abstract class ReminderSettings with _$ReminderSettings {
  const factory ReminderSettings({
    @Default(false) bool trainingEnabled,
    @Default({1, 3, 5}) Set<int> trainingDays,
    @Default(18) int trainingHour,
    @Default(0) int trainingMinute,
    @Default(false) bool weighInEnabled,
    @Default(1) int weighInDay,
    @Default(8) int weighInHour,
    @Default(0) int weighInMinute,

    /// The weekly weigh-in reminder was suggested once (after a weigh-in).
    @Default(false) bool weighInOffered,
  }) = _ReminderSettings;

  factory ReminderSettings.fromJson(Map<String, dynamic> json) =>
      _$ReminderSettingsFromJson(json);
}

/// One weekly notification.
class WeeklySlot {
  const WeeklySlot({
    required this.id,
    required this.weekday,
    required this.hour,
    required this.minute,
    required this.kind,
  });

  final int id;
  final int weekday;
  final int hour;
  final int minute;
  final ReminderKind kind;
}

enum ReminderKind { training, weighIn }

/// Notification ids: one per training weekday + the weigh-in. Every id is
/// cancelled before rescheduling, so a removed day disappears too.
const trainingReminderBaseId = 8000;
const weighInReminderId = 8100;
final List<int> allReminderIds = [
  for (var day = 1; day <= 7; day++) trainingReminderBaseId + day,
  weighInReminderId,
];

List<WeeklySlot> slotsOf(ReminderSettings settings) => [
  if (settings.trainingEnabled)
    for (final day in settings.trainingDays.toList()..sort())
      WeeklySlot(
        id: trainingReminderBaseId + day,
        weekday: day,
        hour: settings.trainingHour,
        minute: settings.trainingMinute,
        kind: ReminderKind.training,
      ),
  if (settings.weighInEnabled)
    WeeklySlot(
      id: weighInReminderId,
      weekday: settings.weighInDay,
      hour: settings.weighInHour,
      minute: settings.weighInMinute,
      kind: ReminderKind.weighIn,
    ),
];
