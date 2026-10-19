// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkoutSet {

 String get id;@JsonKey(unknownEnumValue: SetType.normal) SetType get type;/// Always kg.
 double? get weightKg; int? get reps; bool get completed;@NullableUtcDateTime() DateTime? get completedAt;
/// Create a copy of WorkoutSet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutSetCopyWith<WorkoutSet> get copyWith => _$WorkoutSetCopyWithImpl<WorkoutSet>(this as WorkoutSet, _$identity);

  /// Serializes this WorkoutSet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkoutSet;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutSet&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.reps, _this.reps) || other.reps == _this.reps)&&(identical(other.completed, _this.completed) || other.completed == _this.completed)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkoutSet;
  return Object.hash(runtimeType,_this.id,_this.type,_this.weightKg,_this.reps,_this.completed,_this.completedAt);
}

@override
String toString() {
  final _this = this as WorkoutSet;
  return 'WorkoutSet(id: ${_this.id}, type: ${_this.type}, weightKg: ${_this.weightKg}, reps: ${_this.reps}, completed: ${_this.completed}, completedAt: ${_this.completedAt})';
}


}

/// @nodoc
abstract mixin class $WorkoutSetCopyWith<$Res>  {
  factory $WorkoutSetCopyWith(WorkoutSet value, $Res Function(WorkoutSet) _then) = _$WorkoutSetCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: SetType.normal) SetType type, double? weightKg, int? reps, bool completed,@NullableUtcDateTime() DateTime? completedAt
});




}
/// @nodoc
class _$WorkoutSetCopyWithImpl<$Res>
    implements $WorkoutSetCopyWith<$Res> {
  _$WorkoutSetCopyWithImpl(this._self, this._then);

  final WorkoutSet _self;
  final $Res Function(WorkoutSet) _then;

/// Create a copy of WorkoutSet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? weightKg = freezed,Object? reps = freezed,Object? completed = null,Object? completedAt = freezed,}) {
  return _then(WorkoutSet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SetType,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,reps: freezed == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int?,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutSet].
extension WorkoutSetPatterns on WorkoutSet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutSet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutSet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutSet value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutSet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutSet value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutSet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: SetType.normal)  SetType type,  double? weightKg,  int? reps,  bool completed, @NullableUtcDateTime()  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutSet() when $default != null:
return $default(_that.id,_that.type,_that.weightKg,_that.reps,_that.completed,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: SetType.normal)  SetType type,  double? weightKg,  int? reps,  bool completed, @NullableUtcDateTime()  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _WorkoutSet():
return $default(_that.id,_that.type,_that.weightKg,_that.reps,_that.completed,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(unknownEnumValue: SetType.normal)  SetType type,  double? weightKg,  int? reps,  bool completed, @NullableUtcDateTime()  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutSet() when $default != null:
return $default(_that.id,_that.type,_that.weightKg,_that.reps,_that.completed,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkoutSet implements WorkoutSet {
  const _WorkoutSet({required this.id, @JsonKey(unknownEnumValue: SetType.normal) required this.type, this.weightKg, this.reps, this.completed = false, @NullableUtcDateTime() this.completedAt});
  factory _WorkoutSet.fromJson(Map<String, dynamic> json) => _$WorkoutSetFromJson(json);

@override final  String id;
@override@JsonKey(unknownEnumValue: SetType.normal) final  SetType type;
/// Always kg.
@override final  double? weightKg;
@override final  int? reps;
@override@JsonKey() final  bool completed;
@override@NullableUtcDateTime() final  DateTime? completedAt;

/// Create a copy of WorkoutSet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutSetCopyWith<_WorkoutSet> get copyWith => __$WorkoutSetCopyWithImpl<_WorkoutSet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutSetToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutSet&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.reps, reps) || other.reps == reps)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,type,weightKg,reps,completed,completedAt);
}

@override
String toString() {
    return 'WorkoutSet(id: $id, type: $type, weightKg: $weightKg, reps: $reps, completed: $completed, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$WorkoutSetCopyWith<$Res> implements $WorkoutSetCopyWith<$Res> {
  factory _$WorkoutSetCopyWith(_WorkoutSet value, $Res Function(_WorkoutSet) _then) = __$WorkoutSetCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: SetType.normal) SetType type, double? weightKg, int? reps, bool completed,@NullableUtcDateTime() DateTime? completedAt
});




}
/// @nodoc
class __$WorkoutSetCopyWithImpl<$Res>
    implements _$WorkoutSetCopyWith<$Res> {
  __$WorkoutSetCopyWithImpl(this._self, this._then);

  final _WorkoutSet _self;
  final $Res Function(_WorkoutSet) _then;

/// Create a copy of WorkoutSet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? weightKg = freezed,Object? reps = freezed,Object? completed = null,Object? completedAt = freezed,}) {
  return _then(_WorkoutSet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SetType,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,reps: freezed == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int?,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$WorkoutExercise {

 String get id; String get exerciseId; List<WorkoutSet> get sets;/// Routine slot it came from.
 String? get routineExerciseId; String? get groupId; String get notes;
/// Create a copy of WorkoutExercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutExerciseCopyWith<WorkoutExercise> get copyWith => _$WorkoutExerciseCopyWithImpl<WorkoutExercise>(this as WorkoutExercise, _$identity);

  /// Serializes this WorkoutExercise to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkoutExercise;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutExercise&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.exerciseId, _this.exerciseId) || other.exerciseId == _this.exerciseId)&&const DeepCollectionEquality().equals(other.sets, _this.sets)&&(identical(other.routineExerciseId, _this.routineExerciseId) || other.routineExerciseId == _this.routineExerciseId)&&(identical(other.groupId, _this.groupId) || other.groupId == _this.groupId)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkoutExercise;
  return Object.hash(runtimeType,_this.id,_this.exerciseId,const DeepCollectionEquality().hash(_this.sets),_this.routineExerciseId,_this.groupId,_this.notes);
}

@override
String toString() {
  final _this = this as WorkoutExercise;
  return 'WorkoutExercise(id: ${_this.id}, exerciseId: ${_this.exerciseId}, sets: ${_this.sets}, routineExerciseId: ${_this.routineExerciseId}, groupId: ${_this.groupId}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $WorkoutExerciseCopyWith<$Res>  {
  factory $WorkoutExerciseCopyWith(WorkoutExercise value, $Res Function(WorkoutExercise) _then) = _$WorkoutExerciseCopyWithImpl;
@useResult
$Res call({
 String id, String exerciseId, List<WorkoutSet> sets, String? routineExerciseId, String? groupId, String notes
});




}
/// @nodoc
class _$WorkoutExerciseCopyWithImpl<$Res>
    implements $WorkoutExerciseCopyWith<$Res> {
  _$WorkoutExerciseCopyWithImpl(this._self, this._then);

  final WorkoutExercise _self;
  final $Res Function(WorkoutExercise) _then;

/// Create a copy of WorkoutExercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? exerciseId = null,Object? sets = null,Object? routineExerciseId = freezed,Object? groupId = freezed,Object? notes = null,}) {
  return _then(WorkoutExercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as List<WorkoutSet>,routineExerciseId: freezed == routineExerciseId ? _self.routineExerciseId : routineExerciseId // ignore: cast_nullable_to_non_nullable
as String?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutExercise].
extension WorkoutExercisePatterns on WorkoutExercise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutExercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutExercise() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutExercise value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutExercise():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutExercise value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutExercise() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String exerciseId,  List<WorkoutSet> sets,  String? routineExerciseId,  String? groupId,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutExercise() when $default != null:
return $default(_that.id,_that.exerciseId,_that.sets,_that.routineExerciseId,_that.groupId,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String exerciseId,  List<WorkoutSet> sets,  String? routineExerciseId,  String? groupId,  String notes)  $default,) {final _that = this;
switch (_that) {
case _WorkoutExercise():
return $default(_that.id,_that.exerciseId,_that.sets,_that.routineExerciseId,_that.groupId,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String exerciseId,  List<WorkoutSet> sets,  String? routineExerciseId,  String? groupId,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutExercise() when $default != null:
return $default(_that.id,_that.exerciseId,_that.sets,_that.routineExerciseId,_that.groupId,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkoutExercise implements WorkoutExercise {
  const _WorkoutExercise({required this.id, required this.exerciseId,  List<WorkoutSet> sets = const [], this.routineExerciseId, this.groupId, this.notes = ''}): _sets = sets;
  factory _WorkoutExercise.fromJson(Map<String, dynamic> json) => _$WorkoutExerciseFromJson(json);

@override final  String id;
@override final  String exerciseId;
 final  List<WorkoutSet> _sets;
@override@JsonKey() List<WorkoutSet> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}

/// Routine slot it came from.
@override final  String? routineExerciseId;
@override final  String? groupId;
@override@JsonKey() final  String notes;

/// Create a copy of WorkoutExercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutExerciseCopyWith<_WorkoutExercise> get copyWith => __$WorkoutExerciseCopyWithImpl<_WorkoutExercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutExercise&&(identical(other.id, id) || other.id == id)&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&const DeepCollectionEquality().equals(other.sets, _sets)&&(identical(other.routineExerciseId, routineExerciseId) || other.routineExerciseId == routineExerciseId)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,exerciseId,const DeepCollectionEquality().hash(_sets),routineExerciseId,groupId,notes);
}

@override
String toString() {
    return 'WorkoutExercise(id: $id, exerciseId: $exerciseId, sets: $sets, routineExerciseId: $routineExerciseId, groupId: $groupId, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$WorkoutExerciseCopyWith<$Res> implements $WorkoutExerciseCopyWith<$Res> {
  factory _$WorkoutExerciseCopyWith(_WorkoutExercise value, $Res Function(_WorkoutExercise) _then) = __$WorkoutExerciseCopyWithImpl;
@override @useResult
$Res call({
 String id, String exerciseId, List<WorkoutSet> sets, String? routineExerciseId, String? groupId, String notes
});




}
/// @nodoc
class __$WorkoutExerciseCopyWithImpl<$Res>
    implements _$WorkoutExerciseCopyWith<$Res> {
  __$WorkoutExerciseCopyWithImpl(this._self, this._then);

  final _WorkoutExercise _self;
  final $Res Function(_WorkoutExercise) _then;

/// Create a copy of WorkoutExercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? exerciseId = null,Object? sets = null,Object? routineExerciseId = freezed,Object? groupId = freezed,Object? notes = null,}) {
  return _then(_WorkoutExercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,sets: null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<WorkoutSet>,routineExerciseId: freezed == routineExerciseId ? _self.routineExerciseId : routineExerciseId // ignore: cast_nullable_to_non_nullable
as String?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Workout {

 String get id;@UtcDateTime() DateTime get startedAt; List<WorkoutExercise> get exercises; String get name; String? get routineId; String? get programId;/// `null` = in progress.
@NullableUtcDateTime() DateTime? get finishedAt; String get notes;/// 1–5.
 int? get rating;/// Server-computed (absent until synced).
 double? get volumeKg; int? get durationSeconds;@NullableUtcDateTime() DateTime? get updatedAt;
/// Create a copy of Workout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutCopyWith<Workout> get copyWith => _$WorkoutCopyWithImpl<Workout>(this as Workout, _$identity);

  /// Serializes this Workout to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Workout;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Workout&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&const DeepCollectionEquality().equals(other.exercises, _this.exercises)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.routineId, _this.routineId) || other.routineId == _this.routineId)&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.finishedAt, _this.finishedAt) || other.finishedAt == _this.finishedAt)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.volumeKg, _this.volumeKg) || other.volumeKg == _this.volumeKg)&&(identical(other.durationSeconds, _this.durationSeconds) || other.durationSeconds == _this.durationSeconds)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Workout;
  return Object.hash(runtimeType,_this.id,_this.startedAt,const DeepCollectionEquality().hash(_this.exercises),_this.name,_this.routineId,_this.programId,_this.finishedAt,_this.notes,_this.rating,_this.volumeKg,_this.durationSeconds,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Workout;
  return 'Workout(id: ${_this.id}, startedAt: ${_this.startedAt}, exercises: ${_this.exercises}, name: ${_this.name}, routineId: ${_this.routineId}, programId: ${_this.programId}, finishedAt: ${_this.finishedAt}, notes: ${_this.notes}, rating: ${_this.rating}, volumeKg: ${_this.volumeKg}, durationSeconds: ${_this.durationSeconds}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $WorkoutCopyWith<$Res>  {
  factory $WorkoutCopyWith(Workout value, $Res Function(Workout) _then) = _$WorkoutCopyWithImpl;
@useResult
$Res call({
 String id,@UtcDateTime() DateTime startedAt, List<WorkoutExercise> exercises, String name, String? routineId, String? programId,@NullableUtcDateTime() DateTime? finishedAt, String notes, int? rating, double? volumeKg, int? durationSeconds,@NullableUtcDateTime() DateTime? updatedAt
});




}
/// @nodoc
class _$WorkoutCopyWithImpl<$Res>
    implements $WorkoutCopyWith<$Res> {
  _$WorkoutCopyWithImpl(this._self, this._then);

  final Workout _self;
  final $Res Function(Workout) _then;

/// Create a copy of Workout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? startedAt = null,Object? exercises = null,Object? name = null,Object? routineId = freezed,Object? programId = freezed,Object? finishedAt = freezed,Object? notes = null,Object? rating = freezed,Object? volumeKg = freezed,Object? durationSeconds = freezed,Object? updatedAt = freezed,}) {
  return _then(Workout(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<WorkoutExercise>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,routineId: freezed == routineId ? _self.routineId : routineId // ignore: cast_nullable_to_non_nullable
as String?,programId: freezed == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,volumeKg: freezed == volumeKg ? _self.volumeKg : volumeKg // ignore: cast_nullable_to_non_nullable
as double?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Workout].
extension WorkoutPatterns on Workout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Workout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Workout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Workout value)  $default,){
final _that = this;
switch (_that) {
case _Workout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Workout value)?  $default,){
final _that = this;
switch (_that) {
case _Workout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @UtcDateTime()  DateTime startedAt,  List<WorkoutExercise> exercises,  String name,  String? routineId,  String? programId, @NullableUtcDateTime()  DateTime? finishedAt,  String notes,  int? rating,  double? volumeKg,  int? durationSeconds, @NullableUtcDateTime()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Workout() when $default != null:
return $default(_that.id,_that.startedAt,_that.exercises,_that.name,_that.routineId,_that.programId,_that.finishedAt,_that.notes,_that.rating,_that.volumeKg,_that.durationSeconds,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @UtcDateTime()  DateTime startedAt,  List<WorkoutExercise> exercises,  String name,  String? routineId,  String? programId, @NullableUtcDateTime()  DateTime? finishedAt,  String notes,  int? rating,  double? volumeKg,  int? durationSeconds, @NullableUtcDateTime()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Workout():
return $default(_that.id,_that.startedAt,_that.exercises,_that.name,_that.routineId,_that.programId,_that.finishedAt,_that.notes,_that.rating,_that.volumeKg,_that.durationSeconds,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @UtcDateTime()  DateTime startedAt,  List<WorkoutExercise> exercises,  String name,  String? routineId,  String? programId, @NullableUtcDateTime()  DateTime? finishedAt,  String notes,  int? rating,  double? volumeKg,  int? durationSeconds, @NullableUtcDateTime()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Workout() when $default != null:
return $default(_that.id,_that.startedAt,_that.exercises,_that.name,_that.routineId,_that.programId,_that.finishedAt,_that.notes,_that.rating,_that.volumeKg,_that.durationSeconds,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Workout extends Workout {
  const _Workout({required this.id, @UtcDateTime() required this.startedAt,  List<WorkoutExercise> exercises = const [], this.name = '', this.routineId, this.programId, @NullableUtcDateTime() this.finishedAt, this.notes = '', this.rating, this.volumeKg, this.durationSeconds, @NullableUtcDateTime() this.updatedAt}): _exercises = exercises,super._();
  factory _Workout.fromJson(Map<String, dynamic> json) => _$WorkoutFromJson(json);

@override final  String id;
@override@UtcDateTime() final  DateTime startedAt;
 final  List<WorkoutExercise> _exercises;
@override@JsonKey() List<WorkoutExercise> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}

@override@JsonKey() final  String name;
@override final  String? routineId;
@override final  String? programId;
/// `null` = in progress.
@override@NullableUtcDateTime() final  DateTime? finishedAt;
@override@JsonKey() final  String notes;
/// 1–5.
@override final  int? rating;
/// Server-computed (absent until synced).
@override final  double? volumeKg;
@override final  int? durationSeconds;
@override@NullableUtcDateTime() final  DateTime? updatedAt;

/// Create a copy of Workout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutCopyWith<_Workout> get copyWith => __$WorkoutCopyWithImpl<_Workout>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Workout&&(identical(other.id, id) || other.id == id)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&const DeepCollectionEquality().equals(other.exercises, _exercises)&&(identical(other.name, name) || other.name == name)&&(identical(other.routineId, routineId) || other.routineId == routineId)&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.volumeKg, volumeKg) || other.volumeKg == volumeKg)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,startedAt,const DeepCollectionEquality().hash(_exercises),name,routineId,programId,finishedAt,notes,rating,volumeKg,durationSeconds,updatedAt);
}

@override
String toString() {
    return 'Workout(id: $id, startedAt: $startedAt, exercises: $exercises, name: $name, routineId: $routineId, programId: $programId, finishedAt: $finishedAt, notes: $notes, rating: $rating, volumeKg: $volumeKg, durationSeconds: $durationSeconds, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$WorkoutCopyWith<$Res> implements $WorkoutCopyWith<$Res> {
  factory _$WorkoutCopyWith(_Workout value, $Res Function(_Workout) _then) = __$WorkoutCopyWithImpl;
@override @useResult
$Res call({
 String id,@UtcDateTime() DateTime startedAt, List<WorkoutExercise> exercises, String name, String? routineId, String? programId,@NullableUtcDateTime() DateTime? finishedAt, String notes, int? rating, double? volumeKg, int? durationSeconds,@NullableUtcDateTime() DateTime? updatedAt
});




}
/// @nodoc
class __$WorkoutCopyWithImpl<$Res>
    implements _$WorkoutCopyWith<$Res> {
  __$WorkoutCopyWithImpl(this._self, this._then);

  final _Workout _self;
  final $Res Function(_Workout) _then;

/// Create a copy of Workout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? startedAt = null,Object? exercises = null,Object? name = null,Object? routineId = freezed,Object? programId = freezed,Object? finishedAt = freezed,Object? notes = null,Object? rating = freezed,Object? volumeKg = freezed,Object? durationSeconds = freezed,Object? updatedAt = freezed,}) {
  return _then(_Workout(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<WorkoutExercise>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,routineId: freezed == routineId ? _self.routineId : routineId // ignore: cast_nullable_to_non_nullable
as String?,programId: freezed == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,volumeKg: freezed == volumeKg ? _self.volumeKg : volumeKg // ignore: cast_nullable_to_non_nullable
as double?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
