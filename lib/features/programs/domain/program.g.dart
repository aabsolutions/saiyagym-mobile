// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Program _$ProgramFromJson(Map<String, dynamic> json) => _Program(
  id: json['id'] as String,
  name: json['name'] as String,
  status:
      $enumDecodeNullable(
        _$ProgramStatusEnumMap,
        json['status'],
        unknownValue: ProgramStatus.draft,
      ) ??
      ProgramStatus.draft,
  durationWeeks: (json['durationWeeks'] as num?)?.toInt() ?? 0,
  startDate: json['startDate'] as String?,
  notes: json['notes'] as String? ?? '',
  weeks:
      (json['weeks'] as List<dynamic>?)
          ?.map((e) => ProgramWeek.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ProgramToJson(_Program instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'status': _$ProgramStatusEnumMap[instance.status]!,
  'durationWeeks': instance.durationWeeks,
  'startDate': instance.startDate,
  'notes': instance.notes,
  'weeks': instance.weeks.map((e) => e.toJson()).toList(),
};

const _$ProgramStatusEnumMap = {
  ProgramStatus.draft: 'draft',
  ProgramStatus.active: 'active',
  ProgramStatus.completed: 'completed',
};

_ProgramWeek _$ProgramWeekFromJson(Map<String, dynamic> json) => _ProgramWeek(
  days:
      (json['days'] as List<dynamic>?)
          ?.map((e) => ProgramDay.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ProgramWeekToJson(_ProgramWeek instance) =>
    <String, dynamic>{'days': instance.days.map((e) => e.toJson()).toList()};

_ProgramDay _$ProgramDayFromJson(Map<String, dynamic> json) => _ProgramDay(
  weekday: (json['weekday'] as num).toInt(),
  routineId: json['routineId'] as String,
  label: json['label'] as String?,
);

Map<String, dynamic> _$ProgramDayToJson(_ProgramDay instance) =>
    <String, dynamic>{
      'weekday': instance.weekday,
      'routineId': instance.routineId,
      'label': instance.label,
    };
