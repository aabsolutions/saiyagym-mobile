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
);

Map<String, dynamic> _$ProgramToJson(_Program instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'status': _$ProgramStatusEnumMap[instance.status]!,
  'durationWeeks': instance.durationWeeks,
  'startDate': instance.startDate,
  'notes': instance.notes,
};

const _$ProgramStatusEnumMap = {
  ProgramStatus.draft: 'draft',
  ProgramStatus.active: 'active',
  ProgramStatus.completed: 'completed',
};
