// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entitlements.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Entitlements {

 Set<PlanFeature> get features;/// `null` value = unlimited. A missing key (a limit unknown to this app
/// version) is treated as unlimited too: the API still enforces it.
 Map<PlanLimit, int?> get limits;/// `null` = full history.
 int? get statsHistoryDays;
/// Create a copy of Entitlements
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntitlementsCopyWith<Entitlements> get copyWith => _$EntitlementsCopyWithImpl<Entitlements>(this as Entitlements, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Entitlements;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Entitlements&&const DeepCollectionEquality().equals(other.features, _this.features)&&const DeepCollectionEquality().equals(other.limits, _this.limits)&&(identical(other.statsHistoryDays, _this.statsHistoryDays) || other.statsHistoryDays == _this.statsHistoryDays));
}


@override
int get hashCode {
  final _this = this as Entitlements;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.features),const DeepCollectionEquality().hash(_this.limits),_this.statsHistoryDays);
}

@override
String toString() {
  final _this = this as Entitlements;
  return 'Entitlements(features: ${_this.features}, limits: ${_this.limits}, statsHistoryDays: ${_this.statsHistoryDays})';
}


}

/// @nodoc
abstract mixin class $EntitlementsCopyWith<$Res>  {
  factory $EntitlementsCopyWith(Entitlements value, $Res Function(Entitlements) _then) = _$EntitlementsCopyWithImpl;
@useResult
$Res call({
 Set<PlanFeature> features, Map<PlanLimit, int?> limits, int? statsHistoryDays
});




}
/// @nodoc
class _$EntitlementsCopyWithImpl<$Res>
    implements $EntitlementsCopyWith<$Res> {
  _$EntitlementsCopyWithImpl(this._self, this._then);

  final Entitlements _self;
  final $Res Function(Entitlements) _then;

/// Create a copy of Entitlements
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? features = null,Object? limits = null,Object? statsHistoryDays = freezed,}) {
  return _then(Entitlements(
features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as Set<PlanFeature>,limits: null == limits ? _self.limits : limits // ignore: cast_nullable_to_non_nullable
as Map<PlanLimit, int?>,statsHistoryDays: freezed == statsHistoryDays ? _self.statsHistoryDays : statsHistoryDays // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Entitlements].
extension EntitlementsPatterns on Entitlements {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Entitlements value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Entitlements() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Entitlements value)  $default,){
final _that = this;
switch (_that) {
case _Entitlements():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Entitlements value)?  $default,){
final _that = this;
switch (_that) {
case _Entitlements() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<PlanFeature> features,  Map<PlanLimit, int?> limits,  int? statsHistoryDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Entitlements() when $default != null:
return $default(_that.features,_that.limits,_that.statsHistoryDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<PlanFeature> features,  Map<PlanLimit, int?> limits,  int? statsHistoryDays)  $default,) {final _that = this;
switch (_that) {
case _Entitlements():
return $default(_that.features,_that.limits,_that.statsHistoryDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<PlanFeature> features,  Map<PlanLimit, int?> limits,  int? statsHistoryDays)?  $default,) {final _that = this;
switch (_that) {
case _Entitlements() when $default != null:
return $default(_that.features,_that.limits,_that.statsHistoryDays);case _:
  return null;

}
}

}

/// @nodoc


class _Entitlements extends Entitlements {
  const _Entitlements({ Set<PlanFeature> features = const {},  Map<PlanLimit, int?> limits = const {}, this.statsHistoryDays}): _features = features,_limits = limits,super._();
  

 final  Set<PlanFeature> _features;
@override@JsonKey() Set<PlanFeature> get features {
  if (_features is EqualUnmodifiableSetView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_features);
}

/// `null` value = unlimited. A missing key (a limit unknown to this app
/// version) is treated as unlimited too: the API still enforces it.
 final  Map<PlanLimit, int?> _limits;
/// `null` value = unlimited. A missing key (a limit unknown to this app
/// version) is treated as unlimited too: the API still enforces it.
@override@JsonKey() Map<PlanLimit, int?> get limits {
  if (_limits is EqualUnmodifiableMapView) return _limits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_limits);
}

/// `null` = full history.
@override final  int? statsHistoryDays;

/// Create a copy of Entitlements
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntitlementsCopyWith<_Entitlements> get copyWith => __$EntitlementsCopyWithImpl<_Entitlements>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Entitlements&&const DeepCollectionEquality().equals(other.features, _features)&&const DeepCollectionEquality().equals(other.limits, _limits)&&(identical(other.statsHistoryDays, statsHistoryDays) || other.statsHistoryDays == statsHistoryDays));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_features),const DeepCollectionEquality().hash(_limits),statsHistoryDays);
}

@override
String toString() {
    return 'Entitlements(features: $features, limits: $limits, statsHistoryDays: $statsHistoryDays)';
}


}

/// @nodoc
abstract mixin class _$EntitlementsCopyWith<$Res> implements $EntitlementsCopyWith<$Res> {
  factory _$EntitlementsCopyWith(_Entitlements value, $Res Function(_Entitlements) _then) = __$EntitlementsCopyWithImpl;
@override @useResult
$Res call({
 Set<PlanFeature> features, Map<PlanLimit, int?> limits, int? statsHistoryDays
});




}
/// @nodoc
class __$EntitlementsCopyWithImpl<$Res>
    implements _$EntitlementsCopyWith<$Res> {
  __$EntitlementsCopyWithImpl(this._self, this._then);

  final _Entitlements _self;
  final $Res Function(_Entitlements) _then;

/// Create a copy of Entitlements
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? features = null,Object? limits = null,Object? statsHistoryDays = freezed,}) {
  return _then(_Entitlements(
features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as Set<PlanFeature>,limits: null == limits ? _self._limits : limits // ignore: cast_nullable_to_non_nullable
as Map<PlanLimit, int?>,statsHistoryDays: freezed == statsHistoryDays ? _self.statsHistoryDays : statsHistoryDays // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
