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
 String? get startDate; String get notes; List<ProgramWeek> get weeks;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Program&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.durationWeeks, _this.durationWeeks) || other.durationWeeks == _this.durationWeeks)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&const DeepCollectionEquality().equals(other.weeks, _this.weeks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Program;
  return Object.hash(runtimeType,_this.id,_this.name,_this.status,_this.durationWeeks,_this.startDate,_this.notes,const DeepCollectionEquality().hash(_this.weeks));
}

@override
String toString() {
  final _this = this as Program;
  return 'Program(id: ${_this.id}, name: ${_this.name}, status: ${_this.status}, durationWeeks: ${_this.durationWeeks}, startDate: ${_this.startDate}, notes: ${_this.notes}, weeks: ${_this.weeks})';
}


}

/// @nodoc
abstract mixin class $ProgramCopyWith<$Res>  {
  factory $ProgramCopyWith(Program value, $Res Function(Program) _then) = _$ProgramCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(unknownEnumValue: ProgramStatus.draft) ProgramStatus status, int durationWeeks, String? startDate, String notes, List<ProgramWeek> weeks
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? status = null,Object? durationWeeks = null,Object? startDate = freezed,Object? notes = null,Object? weeks = null,}) {
  return _then(Program(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProgramStatus,durationWeeks: null == durationWeeks ? _self.durationWeeks : durationWeeks // ignore: cast_nullable_to_non_nullable
as int,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,weeks: null == weeks ? _self.weeks : weeks // ignore: cast_nullable_to_non_nullable
as List<ProgramWeek>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(unknownEnumValue: ProgramStatus.draft)  ProgramStatus status,  int durationWeeks,  String? startDate,  String notes,  List<ProgramWeek> weeks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Program() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.durationWeeks,_that.startDate,_that.notes,_that.weeks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(unknownEnumValue: ProgramStatus.draft)  ProgramStatus status,  int durationWeeks,  String? startDate,  String notes,  List<ProgramWeek> weeks)  $default,) {final _that = this;
switch (_that) {
case _Program():
return $default(_that.id,_that.name,_that.status,_that.durationWeeks,_that.startDate,_that.notes,_that.weeks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(unknownEnumValue: ProgramStatus.draft)  ProgramStatus status,  int durationWeeks,  String? startDate,  String notes,  List<ProgramWeek> weeks)?  $default,) {final _that = this;
switch (_that) {
case _Program() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.durationWeeks,_that.startDate,_that.notes,_that.weeks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Program implements Program {
  const _Program({required this.id, required this.name, @JsonKey(unknownEnumValue: ProgramStatus.draft) this.status = ProgramStatus.draft, this.durationWeeks = 0, this.startDate, this.notes = '',  List<ProgramWeek> weeks = const []}): _weeks = weeks;
  factory _Program.fromJson(Map<String, dynamic> json) => _$ProgramFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(unknownEnumValue: ProgramStatus.draft) final  ProgramStatus status;
@override@JsonKey() final  int durationWeeks;
/// Local `YYYY-MM-DD` (never a UTC instant).
@override final  String? startDate;
@override@JsonKey() final  String notes;
 final  List<ProgramWeek> _weeks;
@override@JsonKey() List<ProgramWeek> get weeks {
  if (_weeks is EqualUnmodifiableListView) return _weeks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weeks);
}


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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Program&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.durationWeeks, durationWeeks) || other.durationWeeks == durationWeeks)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.weeks, _weeks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,status,durationWeeks,startDate,notes,const DeepCollectionEquality().hash(_weeks));
}

@override
String toString() {
    return 'Program(id: $id, name: $name, status: $status, durationWeeks: $durationWeeks, startDate: $startDate, notes: $notes, weeks: $weeks)';
}


}

/// @nodoc
abstract mixin class _$ProgramCopyWith<$Res> implements $ProgramCopyWith<$Res> {
  factory _$ProgramCopyWith(_Program value, $Res Function(_Program) _then) = __$ProgramCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(unknownEnumValue: ProgramStatus.draft) ProgramStatus status, int durationWeeks, String? startDate, String notes, List<ProgramWeek> weeks
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? status = null,Object? durationWeeks = null,Object? startDate = freezed,Object? notes = null,Object? weeks = null,}) {
  return _then(_Program(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProgramStatus,durationWeeks: null == durationWeeks ? _self.durationWeeks : durationWeeks // ignore: cast_nullable_to_non_nullable
as int,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,weeks: null == weeks ? _self._weeks : weeks // ignore: cast_nullable_to_non_nullable
as List<ProgramWeek>,
  ));
}


}


/// @nodoc
mixin _$ProgramWeek {

 List<ProgramDay> get days;
/// Create a copy of ProgramWeek
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgramWeekCopyWith<ProgramWeek> get copyWith => _$ProgramWeekCopyWithImpl<ProgramWeek>(this as ProgramWeek, _$identity);

  /// Serializes this ProgramWeek to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProgramWeek;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgramWeek&&const DeepCollectionEquality().equals(other.days, _this.days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProgramWeek;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.days));
}

@override
String toString() {
  final _this = this as ProgramWeek;
  return 'ProgramWeek(days: ${_this.days})';
}


}

/// @nodoc
abstract mixin class $ProgramWeekCopyWith<$Res>  {
  factory $ProgramWeekCopyWith(ProgramWeek value, $Res Function(ProgramWeek) _then) = _$ProgramWeekCopyWithImpl;
@useResult
$Res call({
 List<ProgramDay> days
});




}
/// @nodoc
class _$ProgramWeekCopyWithImpl<$Res>
    implements $ProgramWeekCopyWith<$Res> {
  _$ProgramWeekCopyWithImpl(this._self, this._then);

  final ProgramWeek _self;
  final $Res Function(ProgramWeek) _then;

/// Create a copy of ProgramWeek
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? days = null,}) {
  return _then(ProgramWeek(
days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<ProgramDay>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgramWeek].
extension ProgramWeekPatterns on ProgramWeek {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgramWeek value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgramWeek() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgramWeek value)  $default,){
final _that = this;
switch (_that) {
case _ProgramWeek():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgramWeek value)?  $default,){
final _that = this;
switch (_that) {
case _ProgramWeek() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProgramDay> days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgramWeek() when $default != null:
return $default(_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProgramDay> days)  $default,) {final _that = this;
switch (_that) {
case _ProgramWeek():
return $default(_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProgramDay> days)?  $default,) {final _that = this;
switch (_that) {
case _ProgramWeek() when $default != null:
return $default(_that.days);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgramWeek implements ProgramWeek {
  const _ProgramWeek({ List<ProgramDay> days = const []}): _days = days;
  factory _ProgramWeek.fromJson(Map<String, dynamic> json) => _$ProgramWeekFromJson(json);

 final  List<ProgramDay> _days;
@override@JsonKey() List<ProgramDay> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}


/// Create a copy of ProgramWeek
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgramWeekCopyWith<_ProgramWeek> get copyWith => __$ProgramWeekCopyWithImpl<_ProgramWeek>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgramWeekToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgramWeek&&const DeepCollectionEquality().equals(other.days, _days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_days));
}

@override
String toString() {
    return 'ProgramWeek(days: $days)';
}


}

/// @nodoc
abstract mixin class _$ProgramWeekCopyWith<$Res> implements $ProgramWeekCopyWith<$Res> {
  factory _$ProgramWeekCopyWith(_ProgramWeek value, $Res Function(_ProgramWeek) _then) = __$ProgramWeekCopyWithImpl;
@override @useResult
$Res call({
 List<ProgramDay> days
});




}
/// @nodoc
class __$ProgramWeekCopyWithImpl<$Res>
    implements _$ProgramWeekCopyWith<$Res> {
  __$ProgramWeekCopyWithImpl(this._self, this._then);

  final _ProgramWeek _self;
  final $Res Function(_ProgramWeek) _then;

/// Create a copy of ProgramWeek
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? days = null,}) {
  return _then(_ProgramWeek(
days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<ProgramDay>,
  ));
}


}


/// @nodoc
mixin _$ProgramDay {

/// ISO weekday 1–7.
 int get weekday; String get routineId; String? get label;
/// Create a copy of ProgramDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgramDayCopyWith<ProgramDay> get copyWith => _$ProgramDayCopyWithImpl<ProgramDay>(this as ProgramDay, _$identity);

  /// Serializes this ProgramDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProgramDay;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgramDay&&(identical(other.weekday, _this.weekday) || other.weekday == _this.weekday)&&(identical(other.routineId, _this.routineId) || other.routineId == _this.routineId)&&(identical(other.label, _this.label) || other.label == _this.label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProgramDay;
  return Object.hash(runtimeType,_this.weekday,_this.routineId,_this.label);
}

@override
String toString() {
  final _this = this as ProgramDay;
  return 'ProgramDay(weekday: ${_this.weekday}, routineId: ${_this.routineId}, label: ${_this.label})';
}


}

/// @nodoc
abstract mixin class $ProgramDayCopyWith<$Res>  {
  factory $ProgramDayCopyWith(ProgramDay value, $Res Function(ProgramDay) _then) = _$ProgramDayCopyWithImpl;
@useResult
$Res call({
 int weekday, String routineId, String? label
});




}
/// @nodoc
class _$ProgramDayCopyWithImpl<$Res>
    implements $ProgramDayCopyWith<$Res> {
  _$ProgramDayCopyWithImpl(this._self, this._then);

  final ProgramDay _self;
  final $Res Function(ProgramDay) _then;

/// Create a copy of ProgramDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekday = null,Object? routineId = null,Object? label = freezed,}) {
  return _then(ProgramDay(
weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,routineId: null == routineId ? _self.routineId : routineId // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgramDay].
extension ProgramDayPatterns on ProgramDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgramDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgramDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgramDay value)  $default,){
final _that = this;
switch (_that) {
case _ProgramDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgramDay value)?  $default,){
final _that = this;
switch (_that) {
case _ProgramDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int weekday,  String routineId,  String? label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgramDay() when $default != null:
return $default(_that.weekday,_that.routineId,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int weekday,  String routineId,  String? label)  $default,) {final _that = this;
switch (_that) {
case _ProgramDay():
return $default(_that.weekday,_that.routineId,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int weekday,  String routineId,  String? label)?  $default,) {final _that = this;
switch (_that) {
case _ProgramDay() when $default != null:
return $default(_that.weekday,_that.routineId,_that.label);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgramDay implements ProgramDay {
  const _ProgramDay({required this.weekday, required this.routineId, this.label});
  factory _ProgramDay.fromJson(Map<String, dynamic> json) => _$ProgramDayFromJson(json);

/// ISO weekday 1–7.
@override final  int weekday;
@override final  String routineId;
@override final  String? label;

/// Create a copy of ProgramDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgramDayCopyWith<_ProgramDay> get copyWith => __$ProgramDayCopyWithImpl<_ProgramDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgramDayToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgramDay&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.routineId, routineId) || other.routineId == routineId)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,weekday,routineId,label);
}

@override
String toString() {
    return 'ProgramDay(weekday: $weekday, routineId: $routineId, label: $label)';
}


}

/// @nodoc
abstract mixin class _$ProgramDayCopyWith<$Res> implements $ProgramDayCopyWith<$Res> {
  factory _$ProgramDayCopyWith(_ProgramDay value, $Res Function(_ProgramDay) _then) = __$ProgramDayCopyWithImpl;
@override @useResult
$Res call({
 int weekday, String routineId, String? label
});




}
/// @nodoc
class __$ProgramDayCopyWithImpl<$Res>
    implements _$ProgramDayCopyWith<$Res> {
  __$ProgramDayCopyWithImpl(this._self, this._then);

  final _ProgramDay _self;
  final $Res Function(_ProgramDay) _then;

/// Create a copy of ProgramDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekday = null,Object? routineId = null,Object? label = freezed,}) {
  return _then(_ProgramDay(
weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,routineId: null == routineId ? _self.routineId : routineId // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
