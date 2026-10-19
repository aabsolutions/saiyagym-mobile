// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'live_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SetTarget {

@JsonKey(unknownEnumValue: SetType.normal) SetType get type; int? get repsMin; int? get repsMax; double? get weightKg; int? get restSeconds;
/// Create a copy of SetTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetTargetCopyWith<SetTarget> get copyWith => _$SetTargetCopyWithImpl<SetTarget>(this as SetTarget, _$identity);

  /// Serializes this SetTarget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SetTarget;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetTarget&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.repsMin, _this.repsMin) || other.repsMin == _this.repsMin)&&(identical(other.repsMax, _this.repsMax) || other.repsMax == _this.repsMax)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.restSeconds, _this.restSeconds) || other.restSeconds == _this.restSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SetTarget;
  return Object.hash(runtimeType,_this.type,_this.repsMin,_this.repsMax,_this.weightKg,_this.restSeconds);
}

@override
String toString() {
  final _this = this as SetTarget;
  return 'SetTarget(type: ${_this.type}, repsMin: ${_this.repsMin}, repsMax: ${_this.repsMax}, weightKg: ${_this.weightKg}, restSeconds: ${_this.restSeconds})';
}


}

/// @nodoc
abstract mixin class $SetTargetCopyWith<$Res>  {
  factory $SetTargetCopyWith(SetTarget value, $Res Function(SetTarget) _then) = _$SetTargetCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: SetType.normal) SetType type, int? repsMin, int? repsMax, double? weightKg, int? restSeconds
});




}
/// @nodoc
class _$SetTargetCopyWithImpl<$Res>
    implements $SetTargetCopyWith<$Res> {
  _$SetTargetCopyWithImpl(this._self, this._then);

  final SetTarget _self;
  final $Res Function(SetTarget) _then;

/// Create a copy of SetTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? repsMin = freezed,Object? repsMax = freezed,Object? weightKg = freezed,Object? restSeconds = freezed,}) {
  return _then(SetTarget(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SetType,repsMin: freezed == repsMin ? _self.repsMin : repsMin // ignore: cast_nullable_to_non_nullable
as int?,repsMax: freezed == repsMax ? _self.repsMax : repsMax // ignore: cast_nullable_to_non_nullable
as int?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,restSeconds: freezed == restSeconds ? _self.restSeconds : restSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SetTarget].
extension SetTargetPatterns on SetTarget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetTarget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetTarget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetTarget value)  $default,){
final _that = this;
switch (_that) {
case _SetTarget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetTarget value)?  $default,){
final _that = this;
switch (_that) {
case _SetTarget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: SetType.normal)  SetType type,  int? repsMin,  int? repsMax,  double? weightKg,  int? restSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetTarget() when $default != null:
return $default(_that.type,_that.repsMin,_that.repsMax,_that.weightKg,_that.restSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: SetType.normal)  SetType type,  int? repsMin,  int? repsMax,  double? weightKg,  int? restSeconds)  $default,) {final _that = this;
switch (_that) {
case _SetTarget():
return $default(_that.type,_that.repsMin,_that.repsMax,_that.weightKg,_that.restSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: SetType.normal)  SetType type,  int? repsMin,  int? repsMax,  double? weightKg,  int? restSeconds)?  $default,) {final _that = this;
switch (_that) {
case _SetTarget() when $default != null:
return $default(_that.type,_that.repsMin,_that.repsMax,_that.weightKg,_that.restSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetTarget implements SetTarget {
  const _SetTarget({@JsonKey(unknownEnumValue: SetType.normal) this.type = SetType.normal, this.repsMin, this.repsMax, this.weightKg, this.restSeconds});
  factory _SetTarget.fromJson(Map<String, dynamic> json) => _$SetTargetFromJson(json);

@override@JsonKey(unknownEnumValue: SetType.normal) final  SetType type;
@override final  int? repsMin;
@override final  int? repsMax;
@override final  double? weightKg;
@override final  int? restSeconds;

/// Create a copy of SetTarget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetTargetCopyWith<_SetTarget> get copyWith => __$SetTargetCopyWithImpl<_SetTarget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetTargetToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetTarget&&(identical(other.type, type) || other.type == type)&&(identical(other.repsMin, repsMin) || other.repsMin == repsMin)&&(identical(other.repsMax, repsMax) || other.repsMax == repsMax)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.restSeconds, restSeconds) || other.restSeconds == restSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,repsMin,repsMax,weightKg,restSeconds);
}

@override
String toString() {
    return 'SetTarget(type: $type, repsMin: $repsMin, repsMax: $repsMax, weightKg: $weightKg, restSeconds: $restSeconds)';
}


}

/// @nodoc
abstract mixin class _$SetTargetCopyWith<$Res> implements $SetTargetCopyWith<$Res> {
  factory _$SetTargetCopyWith(_SetTarget value, $Res Function(_SetTarget) _then) = __$SetTargetCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: SetType.normal) SetType type, int? repsMin, int? repsMax, double? weightKg, int? restSeconds
});




}
/// @nodoc
class __$SetTargetCopyWithImpl<$Res>
    implements _$SetTargetCopyWith<$Res> {
  __$SetTargetCopyWithImpl(this._self, this._then);

  final _SetTarget _self;
  final $Res Function(_SetTarget) _then;

/// Create a copy of SetTarget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? repsMin = freezed,Object? repsMax = freezed,Object? weightKg = freezed,Object? restSeconds = freezed,}) {
  return _then(_SetTarget(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SetType,repsMin: freezed == repsMin ? _self.repsMin : repsMin // ignore: cast_nullable_to_non_nullable
as int?,repsMax: freezed == repsMax ? _self.repsMax : repsMax // ignore: cast_nullable_to_non_nullable
as int?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,restSeconds: freezed == restSeconds ? _self.restSeconds : restSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$RestTimer {

@UtcDateTime() DateTime get endsAt; int get totalSeconds;/// The set that started it (to highlight the next one).
 String? get setId;
/// Create a copy of RestTimer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RestTimerCopyWith<RestTimer> get copyWith => _$RestTimerCopyWithImpl<RestTimer>(this as RestTimer, _$identity);

  /// Serializes this RestTimer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RestTimer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestTimer&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.totalSeconds, _this.totalSeconds) || other.totalSeconds == _this.totalSeconds)&&(identical(other.setId, _this.setId) || other.setId == _this.setId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RestTimer;
  return Object.hash(runtimeType,_this.endsAt,_this.totalSeconds,_this.setId);
}

@override
String toString() {
  final _this = this as RestTimer;
  return 'RestTimer(endsAt: ${_this.endsAt}, totalSeconds: ${_this.totalSeconds}, setId: ${_this.setId})';
}


}

/// @nodoc
abstract mixin class $RestTimerCopyWith<$Res>  {
  factory $RestTimerCopyWith(RestTimer value, $Res Function(RestTimer) _then) = _$RestTimerCopyWithImpl;
@useResult
$Res call({
@UtcDateTime() DateTime endsAt, int totalSeconds, String? setId
});




}
/// @nodoc
class _$RestTimerCopyWithImpl<$Res>
    implements $RestTimerCopyWith<$Res> {
  _$RestTimerCopyWithImpl(this._self, this._then);

  final RestTimer _self;
  final $Res Function(RestTimer) _then;

/// Create a copy of RestTimer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? endsAt = null,Object? totalSeconds = null,Object? setId = freezed,}) {
  return _then(RestTimer(
endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,totalSeconds: null == totalSeconds ? _self.totalSeconds : totalSeconds // ignore: cast_nullable_to_non_nullable
as int,setId: freezed == setId ? _self.setId : setId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RestTimer].
extension RestTimerPatterns on RestTimer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RestTimer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RestTimer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RestTimer value)  $default,){
final _that = this;
switch (_that) {
case _RestTimer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RestTimer value)?  $default,){
final _that = this;
switch (_that) {
case _RestTimer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@UtcDateTime()  DateTime endsAt,  int totalSeconds,  String? setId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RestTimer() when $default != null:
return $default(_that.endsAt,_that.totalSeconds,_that.setId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@UtcDateTime()  DateTime endsAt,  int totalSeconds,  String? setId)  $default,) {final _that = this;
switch (_that) {
case _RestTimer():
return $default(_that.endsAt,_that.totalSeconds,_that.setId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@UtcDateTime()  DateTime endsAt,  int totalSeconds,  String? setId)?  $default,) {final _that = this;
switch (_that) {
case _RestTimer() when $default != null:
return $default(_that.endsAt,_that.totalSeconds,_that.setId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RestTimer extends RestTimer {
  const _RestTimer({@UtcDateTime() required this.endsAt, required this.totalSeconds, this.setId}): super._();
  factory _RestTimer.fromJson(Map<String, dynamic> json) => _$RestTimerFromJson(json);

@override@UtcDateTime() final  DateTime endsAt;
@override final  int totalSeconds;
/// The set that started it (to highlight the next one).
@override final  String? setId;

/// Create a copy of RestTimer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RestTimerCopyWith<_RestTimer> get copyWith => __$RestTimerCopyWithImpl<_RestTimer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RestTimerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RestTimer&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.totalSeconds, totalSeconds) || other.totalSeconds == totalSeconds)&&(identical(other.setId, setId) || other.setId == setId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,endsAt,totalSeconds,setId);
}

@override
String toString() {
    return 'RestTimer(endsAt: $endsAt, totalSeconds: $totalSeconds, setId: $setId)';
}


}

/// @nodoc
abstract mixin class _$RestTimerCopyWith<$Res> implements $RestTimerCopyWith<$Res> {
  factory _$RestTimerCopyWith(_RestTimer value, $Res Function(_RestTimer) _then) = __$RestTimerCopyWithImpl;
@override @useResult
$Res call({
@UtcDateTime() DateTime endsAt, int totalSeconds, String? setId
});




}
/// @nodoc
class __$RestTimerCopyWithImpl<$Res>
    implements _$RestTimerCopyWith<$Res> {
  __$RestTimerCopyWithImpl(this._self, this._then);

  final _RestTimer _self;
  final $Res Function(_RestTimer) _then;

/// Create a copy of RestTimer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? endsAt = null,Object? totalSeconds = null,Object? setId = freezed,}) {
  return _then(_RestTimer(
endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,totalSeconds: null == totalSeconds ? _self.totalSeconds : totalSeconds // ignore: cast_nullable_to_non_nullable
as int,setId: freezed == setId ? _self.setId : setId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LiveMeta {

 String get workoutId;/// Targets by workout-exercise id, aligned with its sets by index.
 Map<String, List<SetTarget>> get targets;/// Rest by workout-exercise id (routine slot), else the user default.
 Map<String, int> get restSeconds; RestTimer? get rest;
/// Create a copy of LiveMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveMetaCopyWith<LiveMeta> get copyWith => _$LiveMetaCopyWithImpl<LiveMeta>(this as LiveMeta, _$identity);

  /// Serializes this LiveMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LiveMeta;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveMeta&&(identical(other.workoutId, _this.workoutId) || other.workoutId == _this.workoutId)&&const DeepCollectionEquality().equals(other.targets, _this.targets)&&const DeepCollectionEquality().equals(other.restSeconds, _this.restSeconds)&&(identical(other.rest, _this.rest) || other.rest == _this.rest));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LiveMeta;
  return Object.hash(runtimeType,_this.workoutId,const DeepCollectionEquality().hash(_this.targets),const DeepCollectionEquality().hash(_this.restSeconds),_this.rest);
}

@override
String toString() {
  final _this = this as LiveMeta;
  return 'LiveMeta(workoutId: ${_this.workoutId}, targets: ${_this.targets}, restSeconds: ${_this.restSeconds}, rest: ${_this.rest})';
}


}

/// @nodoc
abstract mixin class $LiveMetaCopyWith<$Res>  {
  factory $LiveMetaCopyWith(LiveMeta value, $Res Function(LiveMeta) _then) = _$LiveMetaCopyWithImpl;
@useResult
$Res call({
 String workoutId, Map<String, List<SetTarget>> targets, Map<String, int> restSeconds, RestTimer? rest
});


$RestTimerCopyWith<$Res>? get rest;

}
/// @nodoc
class _$LiveMetaCopyWithImpl<$Res>
    implements $LiveMetaCopyWith<$Res> {
  _$LiveMetaCopyWithImpl(this._self, this._then);

  final LiveMeta _self;
  final $Res Function(LiveMeta) _then;

/// Create a copy of LiveMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workoutId = null,Object? targets = null,Object? restSeconds = null,Object? rest = freezed,}) {
  return _then(LiveMeta(
workoutId: null == workoutId ? _self.workoutId : workoutId // ignore: cast_nullable_to_non_nullable
as String,targets: null == targets ? _self.targets : targets // ignore: cast_nullable_to_non_nullable
as Map<String, List<SetTarget>>,restSeconds: null == restSeconds ? _self.restSeconds : restSeconds // ignore: cast_nullable_to_non_nullable
as Map<String, int>,rest: freezed == rest ? _self.rest : rest // ignore: cast_nullable_to_non_nullable
as RestTimer?,
  ));
}
/// Create a copy of LiveMeta
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RestTimerCopyWith<$Res>? get rest {
    if (_self.rest == null) {
    return null;
  }

  return $RestTimerCopyWith<$Res>(_self.rest!, (value) {
    return _then(_self.copyWith(rest: value));
  });
}
}


/// Adds pattern-matching-related methods to [LiveMeta].
extension LiveMetaPatterns on LiveMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LiveMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LiveMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LiveMeta value)  $default,){
final _that = this;
switch (_that) {
case _LiveMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LiveMeta value)?  $default,){
final _that = this;
switch (_that) {
case _LiveMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String workoutId,  Map<String, List<SetTarget>> targets,  Map<String, int> restSeconds,  RestTimer? rest)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LiveMeta() when $default != null:
return $default(_that.workoutId,_that.targets,_that.restSeconds,_that.rest);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String workoutId,  Map<String, List<SetTarget>> targets,  Map<String, int> restSeconds,  RestTimer? rest)  $default,) {final _that = this;
switch (_that) {
case _LiveMeta():
return $default(_that.workoutId,_that.targets,_that.restSeconds,_that.rest);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String workoutId,  Map<String, List<SetTarget>> targets,  Map<String, int> restSeconds,  RestTimer? rest)?  $default,) {final _that = this;
switch (_that) {
case _LiveMeta() when $default != null:
return $default(_that.workoutId,_that.targets,_that.restSeconds,_that.rest);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LiveMeta implements LiveMeta {
  const _LiveMeta({required this.workoutId,  Map<String, List<SetTarget>> targets = const {},  Map<String, int> restSeconds = const {}, this.rest}): _targets = targets,_restSeconds = restSeconds;
  factory _LiveMeta.fromJson(Map<String, dynamic> json) => _$LiveMetaFromJson(json);

@override final  String workoutId;
/// Targets by workout-exercise id, aligned with its sets by index.
 final  Map<String, List<SetTarget>> _targets;
/// Targets by workout-exercise id, aligned with its sets by index.
@override@JsonKey() Map<String, List<SetTarget>> get targets {
  if (_targets is EqualUnmodifiableMapView) return _targets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_targets);
}

/// Rest by workout-exercise id (routine slot), else the user default.
 final  Map<String, int> _restSeconds;
/// Rest by workout-exercise id (routine slot), else the user default.
@override@JsonKey() Map<String, int> get restSeconds {
  if (_restSeconds is EqualUnmodifiableMapView) return _restSeconds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_restSeconds);
}

@override final  RestTimer? rest;

/// Create a copy of LiveMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiveMetaCopyWith<_LiveMeta> get copyWith => __$LiveMetaCopyWithImpl<_LiveMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LiveMetaToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LiveMeta&&(identical(other.workoutId, workoutId) || other.workoutId == workoutId)&&const DeepCollectionEquality().equals(other.targets, _targets)&&const DeepCollectionEquality().equals(other.restSeconds, _restSeconds)&&(identical(other.rest, rest) || other.rest == rest));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,workoutId,const DeepCollectionEquality().hash(_targets),const DeepCollectionEquality().hash(_restSeconds),rest);
}

@override
String toString() {
    return 'LiveMeta(workoutId: $workoutId, targets: $targets, restSeconds: $restSeconds, rest: $rest)';
}


}

/// @nodoc
abstract mixin class _$LiveMetaCopyWith<$Res> implements $LiveMetaCopyWith<$Res> {
  factory _$LiveMetaCopyWith(_LiveMeta value, $Res Function(_LiveMeta) _then) = __$LiveMetaCopyWithImpl;
@override @useResult
$Res call({
 String workoutId, Map<String, List<SetTarget>> targets, Map<String, int> restSeconds, RestTimer? rest
});


@override $RestTimerCopyWith<$Res>? get rest;

}
/// @nodoc
class __$LiveMetaCopyWithImpl<$Res>
    implements _$LiveMetaCopyWith<$Res> {
  __$LiveMetaCopyWithImpl(this._self, this._then);

  final _LiveMeta _self;
  final $Res Function(_LiveMeta) _then;

/// Create a copy of LiveMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workoutId = null,Object? targets = null,Object? restSeconds = null,Object? rest = freezed,}) {
  return _then(_LiveMeta(
workoutId: null == workoutId ? _self.workoutId : workoutId // ignore: cast_nullable_to_non_nullable
as String,targets: null == targets ? _self._targets : targets // ignore: cast_nullable_to_non_nullable
as Map<String, List<SetTarget>>,restSeconds: null == restSeconds ? _self._restSeconds : restSeconds // ignore: cast_nullable_to_non_nullable
as Map<String, int>,rest: freezed == rest ? _self.rest : rest // ignore: cast_nullable_to_non_nullable
as RestTimer?,
  ));
}

/// Create a copy of LiveMeta
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RestTimerCopyWith<$Res>? get rest {
    if (_self.rest == null) {
    return null;
  }

  return $RestTimerCopyWith<$Res>(_self.rest!, (value) {
    return _then(_self.copyWith(rest: value));
  });
}
}

/// @nodoc
mixin _$LiveSession {

 Workout get workout; LiveMeta get meta;/// Last time each exercise was done: its sets (by exercise id).
 Map<String, List<WorkoutSet>> get previous;/// Display names by exercise id.
 Map<String, String> get names;
/// Create a copy of LiveSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveSessionCopyWith<LiveSession> get copyWith => _$LiveSessionCopyWithImpl<LiveSession>(this as LiveSession, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LiveSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveSession&&(identical(other.workout, _this.workout) || other.workout == _this.workout)&&(identical(other.meta, _this.meta) || other.meta == _this.meta)&&const DeepCollectionEquality().equals(other.previous, _this.previous)&&const DeepCollectionEquality().equals(other.names, _this.names));
}


@override
int get hashCode {
  final _this = this as LiveSession;
  return Object.hash(runtimeType,_this.workout,_this.meta,const DeepCollectionEquality().hash(_this.previous),const DeepCollectionEquality().hash(_this.names));
}

@override
String toString() {
  final _this = this as LiveSession;
  return 'LiveSession(workout: ${_this.workout}, meta: ${_this.meta}, previous: ${_this.previous}, names: ${_this.names})';
}


}

/// @nodoc
abstract mixin class $LiveSessionCopyWith<$Res>  {
  factory $LiveSessionCopyWith(LiveSession value, $Res Function(LiveSession) _then) = _$LiveSessionCopyWithImpl;
@useResult
$Res call({
 Workout workout, LiveMeta meta, Map<String, List<WorkoutSet>> previous, Map<String, String> names
});


$WorkoutCopyWith<$Res> get workout;$LiveMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$LiveSessionCopyWithImpl<$Res>
    implements $LiveSessionCopyWith<$Res> {
  _$LiveSessionCopyWithImpl(this._self, this._then);

  final LiveSession _self;
  final $Res Function(LiveSession) _then;

/// Create a copy of LiveSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workout = null,Object? meta = null,Object? previous = null,Object? names = null,}) {
  return _then(LiveSession(
workout: null == workout ? _self.workout : workout // ignore: cast_nullable_to_non_nullable
as Workout,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as LiveMeta,previous: null == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as Map<String, List<WorkoutSet>>,names: null == names ? _self.names : names // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}
/// Create a copy of LiveSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkoutCopyWith<$Res> get workout {
  
  return $WorkoutCopyWith<$Res>(_self.workout, (value) {
    return _then(_self.copyWith(workout: value));
  });
}/// Create a copy of LiveSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LiveMetaCopyWith<$Res> get meta {
  
  return $LiveMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [LiveSession].
extension LiveSessionPatterns on LiveSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LiveSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LiveSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LiveSession value)  $default,){
final _that = this;
switch (_that) {
case _LiveSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LiveSession value)?  $default,){
final _that = this;
switch (_that) {
case _LiveSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Workout workout,  LiveMeta meta,  Map<String, List<WorkoutSet>> previous,  Map<String, String> names)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LiveSession() when $default != null:
return $default(_that.workout,_that.meta,_that.previous,_that.names);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Workout workout,  LiveMeta meta,  Map<String, List<WorkoutSet>> previous,  Map<String, String> names)  $default,) {final _that = this;
switch (_that) {
case _LiveSession():
return $default(_that.workout,_that.meta,_that.previous,_that.names);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Workout workout,  LiveMeta meta,  Map<String, List<WorkoutSet>> previous,  Map<String, String> names)?  $default,) {final _that = this;
switch (_that) {
case _LiveSession() when $default != null:
return $default(_that.workout,_that.meta,_that.previous,_that.names);case _:
  return null;

}
}

}

/// @nodoc


class _LiveSession implements LiveSession {
  const _LiveSession({required this.workout, required this.meta,  Map<String, List<WorkoutSet>> previous = const {},  Map<String, String> names = const {}}): _previous = previous,_names = names;
  

@override final  Workout workout;
@override final  LiveMeta meta;
/// Last time each exercise was done: its sets (by exercise id).
 final  Map<String, List<WorkoutSet>> _previous;
/// Last time each exercise was done: its sets (by exercise id).
@override@JsonKey() Map<String, List<WorkoutSet>> get previous {
  if (_previous is EqualUnmodifiableMapView) return _previous;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_previous);
}

/// Display names by exercise id.
 final  Map<String, String> _names;
/// Display names by exercise id.
@override@JsonKey() Map<String, String> get names {
  if (_names is EqualUnmodifiableMapView) return _names;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_names);
}


/// Create a copy of LiveSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiveSessionCopyWith<_LiveSession> get copyWith => __$LiveSessionCopyWithImpl<_LiveSession>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LiveSession&&(identical(other.workout, workout) || other.workout == workout)&&(identical(other.meta, meta) || other.meta == meta)&&const DeepCollectionEquality().equals(other.previous, _previous)&&const DeepCollectionEquality().equals(other.names, _names));
}


@override
int get hashCode {
    return Object.hash(runtimeType,workout,meta,const DeepCollectionEquality().hash(_previous),const DeepCollectionEquality().hash(_names));
}

@override
String toString() {
    return 'LiveSession(workout: $workout, meta: $meta, previous: $previous, names: $names)';
}


}

/// @nodoc
abstract mixin class _$LiveSessionCopyWith<$Res> implements $LiveSessionCopyWith<$Res> {
  factory _$LiveSessionCopyWith(_LiveSession value, $Res Function(_LiveSession) _then) = __$LiveSessionCopyWithImpl;
@override @useResult
$Res call({
 Workout workout, LiveMeta meta, Map<String, List<WorkoutSet>> previous, Map<String, String> names
});


@override $WorkoutCopyWith<$Res> get workout;@override $LiveMetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$LiveSessionCopyWithImpl<$Res>
    implements _$LiveSessionCopyWith<$Res> {
  __$LiveSessionCopyWithImpl(this._self, this._then);

  final _LiveSession _self;
  final $Res Function(_LiveSession) _then;

/// Create a copy of LiveSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workout = null,Object? meta = null,Object? previous = null,Object? names = null,}) {
  return _then(_LiveSession(
workout: null == workout ? _self.workout : workout // ignore: cast_nullable_to_non_nullable
as Workout,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as LiveMeta,previous: null == previous ? _self._previous : previous // ignore: cast_nullable_to_non_nullable
as Map<String, List<WorkoutSet>>,names: null == names ? _self._names : names // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

/// Create a copy of LiveSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkoutCopyWith<$Res> get workout {
  
  return $WorkoutCopyWith<$Res>(_self.workout, (value) {
    return _then(_self.copyWith(workout: value));
  });
}/// Create a copy of LiveSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LiveMetaCopyWith<$Res> get meta {
  
  return $LiveMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

// dart format on
