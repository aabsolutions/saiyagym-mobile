// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EntitlementsModel {

 int? get statsHistoryDays; Map<String, int?> get limits; Map<String, bool> get features;
/// Create a copy of EntitlementsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntitlementsModelCopyWith<EntitlementsModel> get copyWith => _$EntitlementsModelCopyWithImpl<EntitlementsModel>(this as EntitlementsModel, _$identity);

  /// Serializes this EntitlementsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EntitlementsModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EntitlementsModel&&(identical(other.statsHistoryDays, _this.statsHistoryDays) || other.statsHistoryDays == _this.statsHistoryDays)&&const DeepCollectionEquality().equals(other.limits, _this.limits)&&const DeepCollectionEquality().equals(other.features, _this.features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EntitlementsModel;
  return Object.hash(runtimeType,_this.statsHistoryDays,const DeepCollectionEquality().hash(_this.limits),const DeepCollectionEquality().hash(_this.features));
}

@override
String toString() {
  final _this = this as EntitlementsModel;
  return 'EntitlementsModel(statsHistoryDays: ${_this.statsHistoryDays}, limits: ${_this.limits}, features: ${_this.features})';
}


}

/// @nodoc
abstract mixin class $EntitlementsModelCopyWith<$Res>  {
  factory $EntitlementsModelCopyWith(EntitlementsModel value, $Res Function(EntitlementsModel) _then) = _$EntitlementsModelCopyWithImpl;
@useResult
$Res call({
 int? statsHistoryDays, Map<String, int?> limits, Map<String, bool> features
});




}
/// @nodoc
class _$EntitlementsModelCopyWithImpl<$Res>
    implements $EntitlementsModelCopyWith<$Res> {
  _$EntitlementsModelCopyWithImpl(this._self, this._then);

  final EntitlementsModel _self;
  final $Res Function(EntitlementsModel) _then;

/// Create a copy of EntitlementsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statsHistoryDays = freezed,Object? limits = null,Object? features = null,}) {
  return _then(EntitlementsModel(
statsHistoryDays: freezed == statsHistoryDays ? _self.statsHistoryDays : statsHistoryDays // ignore: cast_nullable_to_non_nullable
as int?,limits: null == limits ? _self.limits : limits // ignore: cast_nullable_to_non_nullable
as Map<String, int?>,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}

}


/// Adds pattern-matching-related methods to [EntitlementsModel].
extension EntitlementsModelPatterns on EntitlementsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EntitlementsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EntitlementsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EntitlementsModel value)  $default,){
final _that = this;
switch (_that) {
case _EntitlementsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EntitlementsModel value)?  $default,){
final _that = this;
switch (_that) {
case _EntitlementsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? statsHistoryDays,  Map<String, int?> limits,  Map<String, bool> features)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EntitlementsModel() when $default != null:
return $default(_that.statsHistoryDays,_that.limits,_that.features);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? statsHistoryDays,  Map<String, int?> limits,  Map<String, bool> features)  $default,) {final _that = this;
switch (_that) {
case _EntitlementsModel():
return $default(_that.statsHistoryDays,_that.limits,_that.features);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? statsHistoryDays,  Map<String, int?> limits,  Map<String, bool> features)?  $default,) {final _that = this;
switch (_that) {
case _EntitlementsModel() when $default != null:
return $default(_that.statsHistoryDays,_that.limits,_that.features);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EntitlementsModel extends EntitlementsModel {
  const _EntitlementsModel({this.statsHistoryDays,  Map<String, int?> limits = const {},  Map<String, bool> features = const {}}): _limits = limits,_features = features,super._();
  factory _EntitlementsModel.fromJson(Map<String, dynamic> json) => _$EntitlementsModelFromJson(json);

@override final  int? statsHistoryDays;
 final  Map<String, int?> _limits;
@override@JsonKey() Map<String, int?> get limits {
  if (_limits is EqualUnmodifiableMapView) return _limits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_limits);
}

 final  Map<String, bool> _features;
@override@JsonKey() Map<String, bool> get features {
  if (_features is EqualUnmodifiableMapView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_features);
}


/// Create a copy of EntitlementsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntitlementsModelCopyWith<_EntitlementsModel> get copyWith => __$EntitlementsModelCopyWithImpl<_EntitlementsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EntitlementsModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EntitlementsModel&&(identical(other.statsHistoryDays, statsHistoryDays) || other.statsHistoryDays == statsHistoryDays)&&const DeepCollectionEquality().equals(other.limits, _limits)&&const DeepCollectionEquality().equals(other.features, _features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,statsHistoryDays,const DeepCollectionEquality().hash(_limits),const DeepCollectionEquality().hash(_features));
}

@override
String toString() {
    return 'EntitlementsModel(statsHistoryDays: $statsHistoryDays, limits: $limits, features: $features)';
}


}

/// @nodoc
abstract mixin class _$EntitlementsModelCopyWith<$Res> implements $EntitlementsModelCopyWith<$Res> {
  factory _$EntitlementsModelCopyWith(_EntitlementsModel value, $Res Function(_EntitlementsModel) _then) = __$EntitlementsModelCopyWithImpl;
@override @useResult
$Res call({
 int? statsHistoryDays, Map<String, int?> limits, Map<String, bool> features
});




}
/// @nodoc
class __$EntitlementsModelCopyWithImpl<$Res>
    implements _$EntitlementsModelCopyWith<$Res> {
  __$EntitlementsModelCopyWithImpl(this._self, this._then);

  final _EntitlementsModel _self;
  final $Res Function(_EntitlementsModel) _then;

/// Create a copy of EntitlementsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statsHistoryDays = freezed,Object? limits = null,Object? features = null,}) {
  return _then(_EntitlementsModel(
statsHistoryDays: freezed == statsHistoryDays ? _self.statsHistoryDays : statsHistoryDays // ignore: cast_nullable_to_non_nullable
as int?,limits: null == limits ? _self._limits : limits // ignore: cast_nullable_to_non_nullable
as Map<String, int?>,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}


}


/// @nodoc
mixin _$PublicPlanModel {

 String get id; String get code; String get name; EntitlementsModel get entitlements; String get description; bool get isDefault;
/// Create a copy of PublicPlanModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublicPlanModelCopyWith<PublicPlanModel> get copyWith => _$PublicPlanModelCopyWithImpl<PublicPlanModel>(this as PublicPlanModel, _$identity);

  /// Serializes this PublicPlanModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PublicPlanModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublicPlanModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.entitlements, _this.entitlements) || other.entitlements == _this.entitlements)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PublicPlanModel;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.entitlements,_this.description,_this.isDefault);
}

@override
String toString() {
  final _this = this as PublicPlanModel;
  return 'PublicPlanModel(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, entitlements: ${_this.entitlements}, description: ${_this.description}, isDefault: ${_this.isDefault})';
}


}

/// @nodoc
abstract mixin class $PublicPlanModelCopyWith<$Res>  {
  factory $PublicPlanModelCopyWith(PublicPlanModel value, $Res Function(PublicPlanModel) _then) = _$PublicPlanModelCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, EntitlementsModel entitlements, String description, bool isDefault
});


$EntitlementsModelCopyWith<$Res> get entitlements;

}
/// @nodoc
class _$PublicPlanModelCopyWithImpl<$Res>
    implements $PublicPlanModelCopyWith<$Res> {
  _$PublicPlanModelCopyWithImpl(this._self, this._then);

  final PublicPlanModel _self;
  final $Res Function(PublicPlanModel) _then;

/// Create a copy of PublicPlanModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? entitlements = null,Object? description = null,Object? isDefault = null,}) {
  return _then(PublicPlanModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,entitlements: null == entitlements ? _self.entitlements : entitlements // ignore: cast_nullable_to_non_nullable
as EntitlementsModel,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of PublicPlanModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EntitlementsModelCopyWith<$Res> get entitlements {
  
  return $EntitlementsModelCopyWith<$Res>(_self.entitlements, (value) {
    return _then(_self.copyWith(entitlements: value));
  });
}
}


/// Adds pattern-matching-related methods to [PublicPlanModel].
extension PublicPlanModelPatterns on PublicPlanModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublicPlanModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublicPlanModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublicPlanModel value)  $default,){
final _that = this;
switch (_that) {
case _PublicPlanModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublicPlanModel value)?  $default,){
final _that = this;
switch (_that) {
case _PublicPlanModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name,  EntitlementsModel entitlements,  String description,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublicPlanModel() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.entitlements,_that.description,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name,  EntitlementsModel entitlements,  String description,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _PublicPlanModel():
return $default(_that.id,_that.code,_that.name,_that.entitlements,_that.description,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name,  EntitlementsModel entitlements,  String description,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _PublicPlanModel() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.entitlements,_that.description,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublicPlanModel extends PublicPlanModel {
  const _PublicPlanModel({required this.id, required this.code, required this.name, required this.entitlements, this.description = '', this.isDefault = false}): super._();
  factory _PublicPlanModel.fromJson(Map<String, dynamic> json) => _$PublicPlanModelFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;
@override final  EntitlementsModel entitlements;
@override@JsonKey() final  String description;
@override@JsonKey() final  bool isDefault;

/// Create a copy of PublicPlanModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublicPlanModelCopyWith<_PublicPlanModel> get copyWith => __$PublicPlanModelCopyWithImpl<_PublicPlanModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublicPlanModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublicPlanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.entitlements, entitlements) || other.entitlements == entitlements)&&(identical(other.description, description) || other.description == description)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,entitlements,description,isDefault);
}

@override
String toString() {
    return 'PublicPlanModel(id: $id, code: $code, name: $name, entitlements: $entitlements, description: $description, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$PublicPlanModelCopyWith<$Res> implements $PublicPlanModelCopyWith<$Res> {
  factory _$PublicPlanModelCopyWith(_PublicPlanModel value, $Res Function(_PublicPlanModel) _then) = __$PublicPlanModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, EntitlementsModel entitlements, String description, bool isDefault
});


@override $EntitlementsModelCopyWith<$Res> get entitlements;

}
/// @nodoc
class __$PublicPlanModelCopyWithImpl<$Res>
    implements _$PublicPlanModelCopyWith<$Res> {
  __$PublicPlanModelCopyWithImpl(this._self, this._then);

  final _PublicPlanModel _self;
  final $Res Function(_PublicPlanModel) _then;

/// Create a copy of PublicPlanModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? entitlements = null,Object? description = null,Object? isDefault = null,}) {
  return _then(_PublicPlanModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,entitlements: null == entitlements ? _self.entitlements : entitlements // ignore: cast_nullable_to_non_nullable
as EntitlementsModel,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of PublicPlanModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EntitlementsModelCopyWith<$Res> get entitlements {
  
  return $EntitlementsModelCopyWith<$Res>(_self.entitlements, (value) {
    return _then(_self.copyWith(entitlements: value));
  });
}
}

// dart format on
