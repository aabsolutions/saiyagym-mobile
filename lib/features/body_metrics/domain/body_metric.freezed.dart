// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'body_metric.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BodyMetric {

 String get id;@UtcDateTime() DateTime get measuredAt; double? get weightKg; double? get bodyFatPercent; double? get waistCm; double? get chestCm; double? get hipsCm; double? get armCm; double? get thighCm; double? get calfCm; double? get neckCm; String get notes;
/// Create a copy of BodyMetric
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BodyMetricCopyWith<BodyMetric> get copyWith => _$BodyMetricCopyWithImpl<BodyMetric>(this as BodyMetric, _$identity);

  /// Serializes this BodyMetric to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BodyMetric;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BodyMetric&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.measuredAt, _this.measuredAt) || other.measuredAt == _this.measuredAt)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.bodyFatPercent, _this.bodyFatPercent) || other.bodyFatPercent == _this.bodyFatPercent)&&(identical(other.waistCm, _this.waistCm) || other.waistCm == _this.waistCm)&&(identical(other.chestCm, _this.chestCm) || other.chestCm == _this.chestCm)&&(identical(other.hipsCm, _this.hipsCm) || other.hipsCm == _this.hipsCm)&&(identical(other.armCm, _this.armCm) || other.armCm == _this.armCm)&&(identical(other.thighCm, _this.thighCm) || other.thighCm == _this.thighCm)&&(identical(other.calfCm, _this.calfCm) || other.calfCm == _this.calfCm)&&(identical(other.neckCm, _this.neckCm) || other.neckCm == _this.neckCm)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BodyMetric;
  return Object.hash(runtimeType,_this.id,_this.measuredAt,_this.weightKg,_this.bodyFatPercent,_this.waistCm,_this.chestCm,_this.hipsCm,_this.armCm,_this.thighCm,_this.calfCm,_this.neckCm,_this.notes);
}

@override
String toString() {
  final _this = this as BodyMetric;
  return 'BodyMetric(id: ${_this.id}, measuredAt: ${_this.measuredAt}, weightKg: ${_this.weightKg}, bodyFatPercent: ${_this.bodyFatPercent}, waistCm: ${_this.waistCm}, chestCm: ${_this.chestCm}, hipsCm: ${_this.hipsCm}, armCm: ${_this.armCm}, thighCm: ${_this.thighCm}, calfCm: ${_this.calfCm}, neckCm: ${_this.neckCm}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $BodyMetricCopyWith<$Res>  {
  factory $BodyMetricCopyWith(BodyMetric value, $Res Function(BodyMetric) _then) = _$BodyMetricCopyWithImpl;
@useResult
$Res call({
 String id,@UtcDateTime() DateTime measuredAt, double? weightKg, double? bodyFatPercent, double? waistCm, double? chestCm, double? hipsCm, double? armCm, double? thighCm, double? calfCm, double? neckCm, String notes
});




}
/// @nodoc
class _$BodyMetricCopyWithImpl<$Res>
    implements $BodyMetricCopyWith<$Res> {
  _$BodyMetricCopyWithImpl(this._self, this._then);

  final BodyMetric _self;
  final $Res Function(BodyMetric) _then;

/// Create a copy of BodyMetric
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? measuredAt = null,Object? weightKg = freezed,Object? bodyFatPercent = freezed,Object? waistCm = freezed,Object? chestCm = freezed,Object? hipsCm = freezed,Object? armCm = freezed,Object? thighCm = freezed,Object? calfCm = freezed,Object? neckCm = freezed,Object? notes = null,}) {
  return _then(BodyMetric(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,measuredAt: null == measuredAt ? _self.measuredAt : measuredAt // ignore: cast_nullable_to_non_nullable
as DateTime,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,bodyFatPercent: freezed == bodyFatPercent ? _self.bodyFatPercent : bodyFatPercent // ignore: cast_nullable_to_non_nullable
as double?,waistCm: freezed == waistCm ? _self.waistCm : waistCm // ignore: cast_nullable_to_non_nullable
as double?,chestCm: freezed == chestCm ? _self.chestCm : chestCm // ignore: cast_nullable_to_non_nullable
as double?,hipsCm: freezed == hipsCm ? _self.hipsCm : hipsCm // ignore: cast_nullable_to_non_nullable
as double?,armCm: freezed == armCm ? _self.armCm : armCm // ignore: cast_nullable_to_non_nullable
as double?,thighCm: freezed == thighCm ? _self.thighCm : thighCm // ignore: cast_nullable_to_non_nullable
as double?,calfCm: freezed == calfCm ? _self.calfCm : calfCm // ignore: cast_nullable_to_non_nullable
as double?,neckCm: freezed == neckCm ? _self.neckCm : neckCm // ignore: cast_nullable_to_non_nullable
as double?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BodyMetric].
extension BodyMetricPatterns on BodyMetric {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BodyMetric value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BodyMetric() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BodyMetric value)  $default,){
final _that = this;
switch (_that) {
case _BodyMetric():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BodyMetric value)?  $default,){
final _that = this;
switch (_that) {
case _BodyMetric() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @UtcDateTime()  DateTime measuredAt,  double? weightKg,  double? bodyFatPercent,  double? waistCm,  double? chestCm,  double? hipsCm,  double? armCm,  double? thighCm,  double? calfCm,  double? neckCm,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BodyMetric() when $default != null:
return $default(_that.id,_that.measuredAt,_that.weightKg,_that.bodyFatPercent,_that.waistCm,_that.chestCm,_that.hipsCm,_that.armCm,_that.thighCm,_that.calfCm,_that.neckCm,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @UtcDateTime()  DateTime measuredAt,  double? weightKg,  double? bodyFatPercent,  double? waistCm,  double? chestCm,  double? hipsCm,  double? armCm,  double? thighCm,  double? calfCm,  double? neckCm,  String notes)  $default,) {final _that = this;
switch (_that) {
case _BodyMetric():
return $default(_that.id,_that.measuredAt,_that.weightKg,_that.bodyFatPercent,_that.waistCm,_that.chestCm,_that.hipsCm,_that.armCm,_that.thighCm,_that.calfCm,_that.neckCm,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @UtcDateTime()  DateTime measuredAt,  double? weightKg,  double? bodyFatPercent,  double? waistCm,  double? chestCm,  double? hipsCm,  double? armCm,  double? thighCm,  double? calfCm,  double? neckCm,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _BodyMetric() when $default != null:
return $default(_that.id,_that.measuredAt,_that.weightKg,_that.bodyFatPercent,_that.waistCm,_that.chestCm,_that.hipsCm,_that.armCm,_that.thighCm,_that.calfCm,_that.neckCm,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BodyMetric implements BodyMetric {
  const _BodyMetric({required this.id, @UtcDateTime() required this.measuredAt, this.weightKg, this.bodyFatPercent, this.waistCm, this.chestCm, this.hipsCm, this.armCm, this.thighCm, this.calfCm, this.neckCm, this.notes = ''});
  factory _BodyMetric.fromJson(Map<String, dynamic> json) => _$BodyMetricFromJson(json);

@override final  String id;
@override@UtcDateTime() final  DateTime measuredAt;
@override final  double? weightKg;
@override final  double? bodyFatPercent;
@override final  double? waistCm;
@override final  double? chestCm;
@override final  double? hipsCm;
@override final  double? armCm;
@override final  double? thighCm;
@override final  double? calfCm;
@override final  double? neckCm;
@override@JsonKey() final  String notes;

/// Create a copy of BodyMetric
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BodyMetricCopyWith<_BodyMetric> get copyWith => __$BodyMetricCopyWithImpl<_BodyMetric>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BodyMetricToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BodyMetric&&(identical(other.id, id) || other.id == id)&&(identical(other.measuredAt, measuredAt) || other.measuredAt == measuredAt)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.bodyFatPercent, bodyFatPercent) || other.bodyFatPercent == bodyFatPercent)&&(identical(other.waistCm, waistCm) || other.waistCm == waistCm)&&(identical(other.chestCm, chestCm) || other.chestCm == chestCm)&&(identical(other.hipsCm, hipsCm) || other.hipsCm == hipsCm)&&(identical(other.armCm, armCm) || other.armCm == armCm)&&(identical(other.thighCm, thighCm) || other.thighCm == thighCm)&&(identical(other.calfCm, calfCm) || other.calfCm == calfCm)&&(identical(other.neckCm, neckCm) || other.neckCm == neckCm)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,measuredAt,weightKg,bodyFatPercent,waistCm,chestCm,hipsCm,armCm,thighCm,calfCm,neckCm,notes);
}

@override
String toString() {
    return 'BodyMetric(id: $id, measuredAt: $measuredAt, weightKg: $weightKg, bodyFatPercent: $bodyFatPercent, waistCm: $waistCm, chestCm: $chestCm, hipsCm: $hipsCm, armCm: $armCm, thighCm: $thighCm, calfCm: $calfCm, neckCm: $neckCm, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$BodyMetricCopyWith<$Res> implements $BodyMetricCopyWith<$Res> {
  factory _$BodyMetricCopyWith(_BodyMetric value, $Res Function(_BodyMetric) _then) = __$BodyMetricCopyWithImpl;
@override @useResult
$Res call({
 String id,@UtcDateTime() DateTime measuredAt, double? weightKg, double? bodyFatPercent, double? waistCm, double? chestCm, double? hipsCm, double? armCm, double? thighCm, double? calfCm, double? neckCm, String notes
});




}
/// @nodoc
class __$BodyMetricCopyWithImpl<$Res>
    implements _$BodyMetricCopyWith<$Res> {
  __$BodyMetricCopyWithImpl(this._self, this._then);

  final _BodyMetric _self;
  final $Res Function(_BodyMetric) _then;

/// Create a copy of BodyMetric
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? measuredAt = null,Object? weightKg = freezed,Object? bodyFatPercent = freezed,Object? waistCm = freezed,Object? chestCm = freezed,Object? hipsCm = freezed,Object? armCm = freezed,Object? thighCm = freezed,Object? calfCm = freezed,Object? neckCm = freezed,Object? notes = null,}) {
  return _then(_BodyMetric(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,measuredAt: null == measuredAt ? _self.measuredAt : measuredAt // ignore: cast_nullable_to_non_nullable
as DateTime,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,bodyFatPercent: freezed == bodyFatPercent ? _self.bodyFatPercent : bodyFatPercent // ignore: cast_nullable_to_non_nullable
as double?,waistCm: freezed == waistCm ? _self.waistCm : waistCm // ignore: cast_nullable_to_non_nullable
as double?,chestCm: freezed == chestCm ? _self.chestCm : chestCm // ignore: cast_nullable_to_non_nullable
as double?,hipsCm: freezed == hipsCm ? _self.hipsCm : hipsCm // ignore: cast_nullable_to_non_nullable
as double?,armCm: freezed == armCm ? _self.armCm : armCm // ignore: cast_nullable_to_non_nullable
as double?,thighCm: freezed == thighCm ? _self.thighCm : thighCm // ignore: cast_nullable_to_non_nullable
as double?,calfCm: freezed == calfCm ? _self.calfCm : calfCm // ignore: cast_nullable_to_non_nullable
as double?,neckCm: freezed == neckCm ? _self.neckCm : neckCm // ignore: cast_nullable_to_non_nullable
as double?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
