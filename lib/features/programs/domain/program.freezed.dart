// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'program.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Program {

 String get id; String get name;@JsonKey(unknownEnumValue: ProgramStatus.draft) ProgramStatus get status; int get durationWeeks;/// Local `YYYY-MM-DD` (never a UTC instant).
 String? get startDate; String get notes;
/// Create a copy of Program
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgramCopyWith<Program> get copyWith => _$ProgramCopyWithImpl<Program>(this as Program, _$identity);

  /// Serializes this Program to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Program;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Program&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.durationWeeks, _this.durationWeeks) || other.durationWeeks == _this.durationWeeks)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Program;
  return Object.hash(runtimeType,_this.id,_this.name,_this.status,_this.durationWeeks,_this.startDate,_this.notes);
}

@override
String toString() {
  final _this = this as Program;
  return 'Program(id: ${_this.id}, name: ${_this.name}, status: ${_this.status}, durationWeeks: ${_this.durationWeeks}, startDate: ${_this.startDate}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $ProgramCopyWith<$Res>  {
  factory $ProgramCopyWith(Program value, $Res Function(Program) _then) = _$ProgramCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(unknownEnumValue: ProgramStatus.draft) ProgramStatus status, int durationWeeks, String? startDate, String notes
});




}
/// @nodoc
class _$ProgramCopyWithImpl<$Res>
    implements $ProgramCopyWith<$Res> {
  _$ProgramCopyWithImpl(this._self, this._then);

  final Program _self;
  final $Res Function(Program) _then;

/// Create a copy of Program
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? status = null,Object? durationWeeks = null,Object? startDate = freezed,Object? notes = null,}) {
  return _then(Program(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProgramStatus,durationWeeks: null == durationWeeks ? _self.durationWeeks : durationWeeks // ignore: cast_nullable_to_non_nullable
as int,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Program].
extension ProgramPatterns on Program {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Program value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Program() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Program value)  $default,){
final _that = this;
switch (_that) {
case _Program():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Program value)?  $default,){
final _that = this;
switch (_that) {
case _Program() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(unknownEnumValue: ProgramStatus.draft)  ProgramStatus status,  int durationWeeks,  String? startDate,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Program() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.durationWeeks,_that.startDate,_that.notes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(unknownEnumValue: ProgramStatus.draft)  ProgramStatus status,  int durationWeeks,  String? startDate,  String notes)  $default,) {final _that = this;
switch (_that) {
case _Program():
return $default(_that.id,_that.name,_that.status,_that.durationWeeks,_that.startDate,_that.notes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(unknownEnumValue: ProgramStatus.draft)  ProgramStatus status,  int durationWeeks,  String? startDate,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _Program() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.durationWeeks,_that.startDate,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Program implements Program {
  const _Program({required this.id, required this.name, @JsonKey(unknownEnumValue: ProgramStatus.draft) this.status = ProgramStatus.draft, this.durationWeeks = 0, this.startDate, this.notes = ''});
  factory _Program.fromJson(Map<String, dynamic> json) => _$ProgramFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(unknownEnumValue: ProgramStatus.draft) final  ProgramStatus status;
@override@JsonKey() final  int durationWeeks;
/// Local `YYYY-MM-DD` (never a UTC instant).
@override final  String? startDate;
@override@JsonKey() final  String notes;

/// Create a copy of Program
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgramCopyWith<_Program> get copyWith => __$ProgramCopyWithImpl<_Program>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgramToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Program&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.durationWeeks, durationWeeks) || other.durationWeeks == durationWeeks)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,status,durationWeeks,startDate,notes);
}

@override
String toString() {
    return 'Program(id: $id, name: $name, status: $status, durationWeeks: $durationWeeks, startDate: $startDate, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$ProgramCopyWith<$Res> implements $ProgramCopyWith<$Res> {
  factory _$ProgramCopyWith(_Program value, $Res Function(_Program) _then) = __$ProgramCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(unknownEnumValue: ProgramStatus.draft) ProgramStatus status, int durationWeeks, String? startDate, String notes
});




}
/// @nodoc
class __$ProgramCopyWithImpl<$Res>
    implements _$ProgramCopyWith<$Res> {
  __$ProgramCopyWithImpl(this._self, this._then);

  final _Program _self;
  final $Res Function(_Program) _then;

/// Create a copy of Program
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? status = null,Object? durationWeeks = null,Object? startDate = freezed,Object? notes = null,}) {
  return _then(_Program(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProgramStatus,durationWeeks: null == durationWeeks ? _self.durationWeeks : durationWeeks // ignore: cast_nullable_to_non_nullable
as int,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
