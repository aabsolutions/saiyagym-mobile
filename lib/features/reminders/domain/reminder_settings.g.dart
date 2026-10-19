// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReminderSettings _$ReminderSettingsFromJson(Map<String, dynamic> json) =>
    _ReminderSettings(
      trainingEnabled: json['trainingEnabled'] as bool? ?? false,
      trainingDays:
          (json['trainingDays'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toSet() ??
          const {1, 3, 5},
      trainingHour: (json['trainingHour'] as num?)?.toInt() ?? 18,
      trainingMinute: (json['trainingMinute'] as num?)?.toInt() ?? 0,
      weighInEnabled: json['weighInEnabled'] as bool? ?? false,
      weighInDay: (json['weighInDay'] as num?)?.toInt() ?? 1,
      weighInHour: (json['weighInHour'] as num?)?.toInt() ?? 8,
      weighInMinute: (json['weighInMinute'] as num?)?.toInt() ?? 0,
      weighInOffered: json['weighInOffered'] as bool? ?? false,
    );

Map<String, dynamic> _$ReminderSettingsToJson(_ReminderSettings instance) =>
    <String, dynamic>{
      'trainingEnabled': instance.trainingEnabled,
      'trainingDays': instance.trainingDays.toList(),
      'trainingHour': instance.trainingHour,
      'trainingMinute': instance.trainingMinute,
      'weighInEnabled': instance.weighInEnabled,
      'weighInDay': instance.weighInDay,
      'weighInHour': instance.weighInHour,
      'weighInMinute': instance.weighInMinute,
      'weighInOffered': instance.weighInOffered,
    };
