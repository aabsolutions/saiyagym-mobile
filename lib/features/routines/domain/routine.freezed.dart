// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'routine.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TargetSet {

@JsonKey(unknownEnumValue: SetType.normal) SetType get type; int get repsMin; int get repsMax;/// kg. Mutually exclusive with [percent1RM].
 double? get weightKg; double? get percent1RM; int get restSeconds;
/// Create a copy of TargetSet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TargetSetCopyWith<TargetSet> get copyWith => _$TargetSetCopyWithImpl<TargetSet>(this as TargetSet, _$identity);

  /// Serializes this TargetSet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TargetSet;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TargetSet&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.repsMin, _this.repsMin) || other.repsMin == _this.repsMin)&&(identical(other.repsMax, _this.repsMax) || other.repsMax == _this.repsMax)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.percent1RM, _this.percent1RM) || other.percent1RM == _this.percent1RM)&&(identical(other.restSeconds, _this.restSeconds) || other.restSeconds == _this.restSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TargetSet;
  return Object.hash(runtimeType,_this.type,_this.repsMin,_this.repsMax,_this.weightKg,_this.percent1RM,_this.restSeconds);
}

@override
String toString() {
  final _this = this as TargetSet;
  return 'TargetSet(type: ${_this.type}, repsMin: ${_this.repsMin}, repsMax: ${_this.repsMax}, weightKg: ${_this.weightKg}, percent1RM: ${_this.percent1RM}, restSeconds: ${_this.restSeconds})';
}


}

/// @nodoc
abstract mixin class $TargetSetCopyWith<$Res>  {
  factory $TargetSetCopyWith(TargetSet value, $Res Function(TargetSet) _then) = _$TargetSetCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: SetType.normal) SetType type, int repsMin, int repsMax, double? weightKg, double? percent1RM, int restSeconds
});




}
/// @nodoc
class _$TargetSetCopyWithImpl<$Res>
    implements $TargetSetCopyWith<$Res> {
  _$TargetSetCopyWithImpl(this._self, this._then);

  final TargetSet _self;
  final $Res Function(TargetSet) _then;

/// Create a copy of TargetSet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? repsMin = null,Object? repsMax = null,Object? weightKg = freezed,Object? percent1RM = freezed,Object? restSeconds = null,}) {
  return _then(TargetSet(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SetType,repsMin: null == repsMin ? _self.repsMin : repsMin // ignore: cast_nullable_to_non_nullable
as int,repsMax: null == repsMax ? _self.repsMax : repsMax // ignore: cast_nullable_to_non_nullable
as int,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,percent1RM: freezed == percent1RM ? _self.percent1RM : percent1RM // ignore: cast_nullable_to_non_nullable
as double?,restSeconds: null == restSeconds ? _self.restSeconds : restSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TargetSet].
extension TargetSetPatterns on TargetSet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TargetSet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TargetSet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TargetSet value)  $default,){
final _that = this;
switch (_that) {
case _TargetSet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TargetSet value)?  $default,){
final _that = this;
switch (_that) {
case _TargetSet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: SetType.normal)  SetType type,  int repsMin,  int repsMax,  double? weightKg,  double? percent1RM,  int restSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TargetSet() when $default != null:
return $default(_that.type,_that.repsMin,_that.repsMax,_that.weightKg,_that.percent1RM,_that.restSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: SetType.normal)  SetType type,  int repsMin,  int repsMax,  double? weightKg,  double? percent1RM,  int restSeconds)  $default,) {final _that = this;
switch (_that) {
case _TargetSet():
return $default(_that.type,_that.repsMin,_that.repsMax,_that.weightKg,_that.percent1RM,_that.restSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: SetType.normal)  SetType type,  int repsMin,  int repsMax,  double? weightKg,  double? percent1RM,  int restSeconds)?  $default,) {final _that = this;
switch (_that) {
case _TargetSet() when $default != null:
return $default(_that.type,_that.repsMin,_that.repsMax,_that.weightKg,_that.percent1RM,_that.restSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TargetSet implements TargetSet {
  const _TargetSet({@JsonKey(unknownEnumValue: SetType.normal) required this.type, required this.repsMin, required this.repsMax, this.weightKg, this.percent1RM, this.restSeconds = 120});
  factory _TargetSet.fromJson(Map<String, dynamic> json) => _$TargetSetFromJson(json);

@override@JsonKey(unknownEnumValue: SetType.normal) final  SetType type;
@override final  int repsMin;
@override final  int repsMax;
/// kg. Mutually exclusive with [percent1RM].
@override final  double? weightKg;
@override final  double? percent1RM;
@override@JsonKey() final  int restSeconds;

/// Create a copy of TargetSet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TargetSetCopyWith<_TargetSet> get copyWith => __$TargetSetCopyWithImpl<_TargetSet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TargetSetToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TargetSet&&(identical(other.type, type) || other.type == type)&&(identical(other.repsMin, repsMin) || other.repsMin == repsMin)&&(identical(other.repsMax, repsMax) || other.repsMax == repsMax)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.percent1RM, percent1RM) || other.percent1RM == percent1RM)&&(identical(other.restSeconds, restSeconds) || other.restSeconds == restSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,repsMin,repsMax,weightKg,percent1RM,restSeconds);
}

@override
String toString() {
    return 'TargetSet(type: $type, repsMin: $repsMin, repsMax: $repsMax, weightKg: $weightKg, percent1RM: $percent1RM, restSeconds: $restSeconds)';
}


}

/// @nodoc
abstract mixin class _$TargetSetCopyWith<$Res> implements $TargetSetCopyWith<$Res> {
  factory _$TargetSetCopyWith(_TargetSet value, $Res Function(_TargetSet) _then) = __$TargetSetCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: SetType.normal) SetType type, int repsMin, int repsMax, double? weightKg, double? percent1RM, int restSeconds
});




}
/// @nodoc
class __$TargetSetCopyWithImpl<$Res>
    implements _$TargetSetCopyWith<$Res> {
  __$TargetSetCopyWithImpl(this._self, this._then);

  final _TargetSet _self;
  final $Res Function(_TargetSet) _then;

/// Create a copy of TargetSet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? repsMin = null,Object? repsMax = null,Object? weightKg = freezed,Object? percent1RM = freezed,Object? restSeconds = null,}) {
  return _then(_TargetSet(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SetType,repsMin: null == repsMin ? _self.repsMin : repsMin // ignore: cast_nullable_to_non_nullable
as int,repsMax: null == repsMax ? _self.repsMax : repsMax // ignore: cast_nullable_to_non_nullable
as int,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,percent1RM: freezed == percent1RM ? _self.percent1RM : percent1RM // ignore: cast_nullable_to_non_nullable
as double?,restSeconds: null == restSeconds ? _self.restSeconds : restSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$RoutineExercise {

/// Stable slot id (client-generated).
 String get id; String get exerciseId; List<TargetSet> get sets;/// Exercises sharing it form a superset.
 String? get groupId; String get notes;/// Premium auto-progression rule, kept as the API sends it.
 Map<String, dynamic>? get progression;
/// Create a copy of RoutineExercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoutineExerciseCopyWith<RoutineExercise> get copyWith => _$RoutineExerciseCopyWithImpl<RoutineExercise>(this as RoutineExercise, _$identity);

  /// Serializes this RoutineExercise to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RoutineExercise;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoutineExercise&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.exerciseId, _this.exerciseId) || other.exerciseId == _this.exerciseId)&&const DeepCollectionEquality().equals(other.sets, _this.sets)&&(identical(other.groupId, _this.groupId) || other.groupId == _this.groupId)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&const DeepCollectionEquality().equals(other.progression, _this.progression));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RoutineExercise;
  return Object.hash(runtimeType,_this.id,_this.exerciseId,const DeepCollectionEquality().hash(_this.sets),_this.groupId,_this.notes,const DeepCollectionEquality().hash(_this.progression));
}

@override
String toString() {
  final _this = this as RoutineExercise;
  return 'RoutineExercise(id: ${_this.id}, exerciseId: ${_this.exerciseId}, sets: ${_this.sets}, groupId: ${_this.groupId}, notes: ${_this.notes}, progression: ${_this.progression})';
}


}

/// @nodoc
abstract mixin class $RoutineExerciseCopyWith<$Res>  {
  factory $RoutineExerciseCopyWith(RoutineExercise value, $Res Function(RoutineExercise) _then) = _$RoutineExerciseCopyWithImpl;
@useResult
$Res call({
 String id, String exerciseId, List<TargetSet> sets, String? groupId, String notes, Map<String, dynamic>? progression
});




}
/// @nodoc
class _$RoutineExerciseCopyWithImpl<$Res>
    implements $RoutineExerciseCopyWith<$Res> {
  _$RoutineExerciseCopyWithImpl(this._self, this._then);

  final RoutineExercise _self;
  final $Res Function(RoutineExercise) _then;

/// Create a copy of RoutineExercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? exerciseId = null,Object? sets = null,Object? groupId = freezed,Object? notes = null,Object? progression = freezed,}) {
  return _then(RoutineExercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as List<TargetSet>,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,progression: freezed == progression ? _self.progression : progression // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [RoutineExercise].
extension RoutineExercisePatterns on RoutineExercise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoutineExercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoutineExercise() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoutineExercise value)  $default,){
final _that = this;
switch (_that) {
case _RoutineExercise():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoutineExercise value)?  $default,){
final _that = this;
switch (_that) {
case _RoutineExercise() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String exerciseId,  List<TargetSet> sets,  String? groupId,  String notes,  Map<String, dynamic>? progression)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoutineExercise() when $default != null:
return $default(_that.id,_that.exerciseId,_that.sets,_that.groupId,_that.notes,_that.progression);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String exerciseId,  List<TargetSet> sets,  String? groupId,  String notes,  Map<String, dynamic>? progression)  $default,) {final _that = this;
switch (_that) {
case _RoutineExercise():
return $default(_that.id,_that.exerciseId,_that.sets,_that.groupId,_that.notes,_that.progression);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String exerciseId,  List<TargetSet> sets,  String? groupId,  String notes,  Map<String, dynamic>? progression)?  $default,) {final _that = this;
switch (_that) {
case _RoutineExercise() when $default != null:
return $default(_that.id,_that.exerciseId,_that.sets,_that.groupId,_that.notes,_that.progression);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoutineExercise implements RoutineExercise {
  const _RoutineExercise({required this.id, required this.exerciseId,  List<TargetSet> sets = const [], this.groupId, this.notes = '',  Map<String, dynamic>? progression}): _sets = sets,_progression = progression;
  factory _RoutineExercise.fromJson(Map<String, dynamic> json) => _$RoutineExerciseFromJson(json);

/// Stable slot id (client-generated).
@override final  String id;
@override final  String exerciseId;
 final  List<TargetSet> _sets;
@override@JsonKey() List<TargetSet> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}

/// Exercises sharing it form a superset.
@override final  String? groupId;
@override@JsonKey() final  String notes;
/// Premium auto-progression rule, kept as the API sends it.
 final  Map<String, dynamic>? _progression;
/// Premium auto-progression rule, kept as the API sends it.
@override Map<String, dynamic>? get progression {
  final value = _progression;
  if (value == null) return null;
  if (_progression is EqualUnmodifiableMapView) return _progression;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of RoutineExercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoutineExerciseCopyWith<_RoutineExercise> get copyWith => __$RoutineExerciseCopyWithImpl<_RoutineExercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoutineExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoutineExercise&&(identical(other.id, id) || other.id == id)&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&const DeepCollectionEquality().equals(other.sets, _sets)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.progression, _progression));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,exerciseId,const DeepCollectionEquality().hash(_sets),groupId,notes,const DeepCollectionEquality().hash(_progression));
}

@override
String toString() {
    return 'RoutineExercise(id: $id, exerciseId: $exerciseId, sets: $sets, groupId: $groupId, notes: $notes, progression: $progression)';
}


}

/// @nodoc
abstract mixin class _$RoutineExerciseCopyWith<$Res> implements $RoutineExerciseCopyWith<$Res> {
  factory _$RoutineExerciseCopyWith(_RoutineExercise value, $Res Function(_RoutineExercise) _then) = __$RoutineExerciseCopyWithImpl;
@override @useResult
$Res call({
 String id, String exerciseId, List<TargetSet> sets, String? groupId, String notes, Map<String, dynamic>? progression
});




}
/// @nodoc
class __$RoutineExerciseCopyWithImpl<$Res>
    implements _$RoutineExerciseCopyWith<$Res> {
  __$RoutineExerciseCopyWithImpl(this._self, this._then);

  final _RoutineExercise _self;
  final $Res Function(_RoutineExercise) _then;

/// Create a copy of RoutineExercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? exerciseId = null,Object? sets = null,Object? groupId = freezed,Object? notes = null,Object? progression = freezed,}) {
  return _then(_RoutineExercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,sets: null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<TargetSet>,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,progression: freezed == progression ? _self._progression : progression // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$Routine {

 String get id; String get name; List<RoutineExercise> get exercises; String get notes;@NullableUtcDateTime() DateTime? get archivedAt;@NullableUtcDateTime() DateTime? get updatedAt;
/// Create a copy of Routine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoutineCopyWith<Routine> get copyWith => _$RoutineCopyWithImpl<Routine>(this as Routine, _$identity);

  /// Serializes this Routine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Routine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Routine&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.exercises, _this.exercises)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.archivedAt, _this.archivedAt) || other.archivedAt == _this.archivedAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Routine;
  return Object.hash(runtimeType,_this.id,_this.name,const DeepCollectionEquality().hash(_this.exercises),_this.notes,_this.archivedAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Routine;
  return 'Routine(id: ${_this.id}, name: ${_this.name}, exercises: ${_this.exercises}, notes: ${_this.notes}, archivedAt: ${_this.archivedAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $RoutineCopyWith<$Res>  {
  factory $RoutineCopyWith(Routine value, $Res Function(Routine) _then) = _$RoutineCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<RoutineExercise> exercises, String notes,@NullableUtcDateTime() DateTime? archivedAt,@NullableUtcDateTime() DateTime? updatedAt
});




}
/// @nodoc
class _$RoutineCopyWithImpl<$Res>
    implements $RoutineCopyWith<$Res> {
  _$RoutineCopyWithImpl(this._self, this._then);

  final Routine _self;
  final $Res Function(Routine) _then;

/// Create a copy of Routine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? exercises = null,Object? notes = null,Object? archivedAt = freezed,Object? updatedAt = freezed,}) {
  return _then(Routine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<RoutineExercise>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Routine].
extension RoutinePatterns on Routine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Routine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Routine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Routine value)  $default,){
final _that = this;
switch (_that) {
case _Routine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Routine value)?  $default,){
final _that = this;
switch (_that) {
case _Routine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<RoutineExercise> exercises,  String notes, @NullableUtcDateTime()  DateTime? archivedAt, @NullableUtcDateTime()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Routine() when $default != null:
return $default(_that.id,_that.name,_that.exercises,_that.notes,_that.archivedAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<RoutineExercise> exercises,  String notes, @NullableUtcDateTime()  DateTime? archivedAt, @NullableUtcDateTime()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Routine():
return $default(_that.id,_that.name,_that.exercises,_that.notes,_that.archivedAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<RoutineExercise> exercises,  String notes, @NullableUtcDateTime()  DateTime? archivedAt, @NullableUtcDateTime()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Routine() when $default != null:
return $default(_that.id,_that.name,_that.exercises,_that.notes,_that.archivedAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Routine implements Routine {
  const _Routine({required this.id, required this.name,  List<RoutineExercise> exercises = const [], this.notes = '', @NullableUtcDateTime() this.archivedAt, @NullableUtcDateTime() this.updatedAt}): _exercises = exercises;
  factory _Routine.fromJson(Map<String, dynamic> json) => _$RoutineFromJson(json);

@override final  String id;
@override final  String name;
 final  List<RoutineExercise> _exercises;
@override@JsonKey() List<RoutineExercise> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}

@override@JsonKey() final  String notes;
@override@NullableUtcDateTime() final  DateTime? archivedAt;
@override@NullableUtcDateTime() final  DateTime? updatedAt;

/// Create a copy of Routine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoutineCopyWith<_Routine> get copyWith => __$RoutineCopyWithImpl<_Routine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoutineToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Routine&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.exercises, _exercises)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_exercises),notes,archivedAt,updatedAt);
}

@override
String toString() {
    return 'Routine(id: $id, name: $name, exercises: $exercises, notes: $notes, archivedAt: $archivedAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RoutineCopyWith<$Res> implements $RoutineCopyWith<$Res> {
  factory _$RoutineCopyWith(_Routine value, $Res Function(_Routine) _then) = __$RoutineCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<RoutineExercise> exercises, String notes,@NullableUtcDateTime() DateTime? archivedAt,@NullableUtcDateTime() DateTime? updatedAt
});




}
/// @nodoc
class __$RoutineCopyWithImpl<$Res>
    implements _$RoutineCopyWith<$Res> {
  __$RoutineCopyWithImpl(this._self, this._then);

  final _Routine _self;
  final $Res Function(_Routine) _then;

/// Create a copy of Routine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? exercises = null,Object? notes = null,Object? archivedAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Routine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<RoutineExercise>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
