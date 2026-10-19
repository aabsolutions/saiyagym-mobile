// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'complete_onboarding.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingData {

 UnitSystem get units; String get language; int get defaultRestSeconds; DateTime? get birthDate; Sex? get sex; double? get heightCm; double? get weightKg; TrainingLevel? get level; TrainingGoal? get goal;
/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingDataCopyWith<OnboardingData> get copyWith => _$OnboardingDataCopyWithImpl<OnboardingData>(this as OnboardingData, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OnboardingData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingData&&(identical(other.units, _this.units) || other.units == _this.units)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.defaultRestSeconds, _this.defaultRestSeconds) || other.defaultRestSeconds == _this.defaultRestSeconds)&&(identical(other.birthDate, _this.birthDate) || other.birthDate == _this.birthDate)&&(identical(other.sex, _this.sex) || other.sex == _this.sex)&&(identical(other.heightCm, _this.heightCm) || other.heightCm == _this.heightCm)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.goal, _this.goal) || other.goal == _this.goal));
}


@override
int get hashCode {
  final _this = this as OnboardingData;
  return Object.hash(runtimeType,_this.units,_this.language,_this.defaultRestSeconds,_this.birthDate,_this.sex,_this.heightCm,_this.weightKg,_this.level,_this.goal);
}

@override
String toString() {
  final _this = this as OnboardingData;
  return 'OnboardingData(units: ${_this.units}, language: ${_this.language}, defaultRestSeconds: ${_this.defaultRestSeconds}, birthDate: ${_this.birthDate}, sex: ${_this.sex}, heightCm: ${_this.heightCm}, weightKg: ${_this.weightKg}, level: ${_this.level}, goal: ${_this.goal})';
}


}

/// @nodoc
abstract mixin class $OnboardingDataCopyWith<$Res>  {
  factory $OnboardingDataCopyWith(OnboardingData value, $Res Function(OnboardingData) _then) = _$OnboardingDataCopyWithImpl;
@useResult
$Res call({
 UnitSystem units, String language, int defaultRestSeconds, DateTime? birthDate, Sex? sex, double? heightCm, double? weightKg, TrainingLevel? level, TrainingGoal? goal
});




}
/// @nodoc
class _$OnboardingDataCopyWithImpl<$Res>
    implements $OnboardingDataCopyWith<$Res> {
  _$OnboardingDataCopyWithImpl(this._self, this._then);

  final OnboardingData _self;
  final $Res Function(OnboardingData) _then;

/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? units = null,Object? language = null,Object? defaultRestSeconds = null,Object? birthDate = freezed,Object? sex = freezed,Object? heightCm = freezed,Object? weightKg = freezed,Object? level = freezed,Object? goal = freezed,}) {
  return _then(OnboardingData(
units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as UnitSystem,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,defaultRestSeconds: null == defaultRestSeconds ? _self.defaultRestSeconds : defaultRestSeconds // ignore: cast_nullable_to_non_nullable
as int,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as Sex?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as TrainingLevel?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as TrainingGoal?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingData].
extension OnboardingDataPatterns on OnboardingData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingData value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingData value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UnitSystem units,  String language,  int defaultRestSeconds,  DateTime? birthDate,  Sex? sex,  double? heightCm,  double? weightKg,  TrainingLevel? level,  TrainingGoal? goal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
return $default(_that.units,_that.language,_that.defaultRestSeconds,_that.birthDate,_that.sex,_that.heightCm,_that.weightKg,_that.level,_that.goal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UnitSystem units,  String language,  int defaultRestSeconds,  DateTime? birthDate,  Sex? sex,  double? heightCm,  double? weightKg,  TrainingLevel? level,  TrainingGoal? goal)  $default,) {final _that = this;
switch (_that) {
case _OnboardingData():
return $default(_that.units,_that.language,_that.defaultRestSeconds,_that.birthDate,_that.sex,_that.heightCm,_that.weightKg,_that.level,_that.goal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UnitSystem units,  String language,  int defaultRestSeconds,  DateTime? birthDate,  Sex? sex,  double? heightCm,  double? weightKg,  TrainingLevel? level,  TrainingGoal? goal)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
return $default(_that.units,_that.language,_that.defaultRestSeconds,_that.birthDate,_that.sex,_that.heightCm,_that.weightKg,_that.level,_that.goal);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingData extends OnboardingData {
  const _OnboardingData({required this.units, required this.language, required this.defaultRestSeconds, this.birthDate, this.sex, this.heightCm, this.weightKg, this.level, this.goal}): super._();
  

@override final  UnitSystem units;
@override final  String language;
@override final  int defaultRestSeconds;
@override final  DateTime? birthDate;
@override final  Sex? sex;
@override final  double? heightCm;
@override final  double? weightKg;
@override final  TrainingLevel? level;
@override final  TrainingGoal? goal;

/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingDataCopyWith<_OnboardingData> get copyWith => __$OnboardingDataCopyWithImpl<_OnboardingData>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingData&&(identical(other.units, units) || other.units == units)&&(identical(other.language, language) || other.language == language)&&(identical(other.defaultRestSeconds, defaultRestSeconds) || other.defaultRestSeconds == defaultRestSeconds)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.level, level) || other.level == level)&&(identical(other.goal, goal) || other.goal == goal));
}


@override
int get hashCode {
    return Object.hash(runtimeType,units,language,defaultRestSeconds,birthDate,sex,heightCm,weightKg,level,goal);
}

@override
String toString() {
    return 'OnboardingData(units: $units, language: $language, defaultRestSeconds: $defaultRestSeconds, birthDate: $birthDate, sex: $sex, heightCm: $heightCm, weightKg: $weightKg, level: $level, goal: $goal)';
}


}

/// @nodoc
abstract mixin class _$OnboardingDataCopyWith<$Res> implements $OnboardingDataCopyWith<$Res> {
  factory _$OnboardingDataCopyWith(_OnboardingData value, $Res Function(_OnboardingData) _then) = __$OnboardingDataCopyWithImpl;
@override @useResult
$Res call({
 UnitSystem units, String language, int defaultRestSeconds, DateTime? birthDate, Sex? sex, double? heightCm, double? weightKg, TrainingLevel? level, TrainingGoal? goal
});




}
/// @nodoc
class __$OnboardingDataCopyWithImpl<$Res>
    implements _$OnboardingDataCopyWith<$Res> {
  __$OnboardingDataCopyWithImpl(this._self, this._then);

  final _OnboardingData _self;
  final $Res Function(_OnboardingData) _then;

/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? units = null,Object? language = null,Object? defaultRestSeconds = null,Object? birthDate = freezed,Object? sex = freezed,Object? heightCm = freezed,Object? weightKg = freezed,Object? level = freezed,Object? goal = freezed,}) {
  return _then(_OnboardingData(
units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as UnitSystem,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,defaultRestSeconds: null == defaultRestSeconds ? _self.defaultRestSeconds : defaultRestSeconds // ignore: cast_nullable_to_non_nullable
as int,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as Sex?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as TrainingLevel?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as TrainingGoal?,
  ));
}


}

// dart format on
