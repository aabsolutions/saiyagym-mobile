// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Tiers {

@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) Tier? get hypertrophy;@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) Tier? get powerlifting;
/// Create a copy of Tiers
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TiersCopyWith<Tiers> get copyWith => _$TiersCopyWithImpl<Tiers>(this as Tiers, _$identity);

  /// Serializes this Tiers to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Tiers;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Tiers&&(identical(other.hypertrophy, _this.hypertrophy) || other.hypertrophy == _this.hypertrophy)&&(identical(other.powerlifting, _this.powerlifting) || other.powerlifting == _this.powerlifting));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Tiers;
  return Object.hash(runtimeType,_this.hypertrophy,_this.powerlifting);
}

@override
String toString() {
  final _this = this as Tiers;
  return 'Tiers(hypertrophy: ${_this.hypertrophy}, powerlifting: ${_this.powerlifting})';
}


}

/// @nodoc
abstract mixin class $TiersCopyWith<$Res>  {
  factory $TiersCopyWith(Tiers value, $Res Function(Tiers) _then) = _$TiersCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) Tier? hypertrophy,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) Tier? powerlifting
});




}
/// @nodoc
class _$TiersCopyWithImpl<$Res>
    implements $TiersCopyWith<$Res> {
  _$TiersCopyWithImpl(this._self, this._then);

  final Tiers _self;
  final $Res Function(Tiers) _then;

/// Create a copy of Tiers
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hypertrophy = freezed,Object? powerlifting = freezed,}) {
  return _then(Tiers(
hypertrophy: freezed == hypertrophy ? _self.hypertrophy : hypertrophy // ignore: cast_nullable_to_non_nullable
as Tier?,powerlifting: freezed == powerlifting ? _self.powerlifting : powerlifting // ignore: cast_nullable_to_non_nullable
as Tier?,
  ));
}

}


/// Adds pattern-matching-related methods to [Tiers].
extension TiersPatterns on Tiers {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Tiers value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Tiers() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Tiers value)  $default,){
final _that = this;
switch (_that) {
case _Tiers():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Tiers value)?  $default,){
final _that = this;
switch (_that) {
case _Tiers() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  Tier? hypertrophy, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  Tier? powerlifting)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Tiers() when $default != null:
return $default(_that.hypertrophy,_that.powerlifting);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  Tier? hypertrophy, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  Tier? powerlifting)  $default,) {final _that = this;
switch (_that) {
case _Tiers():
return $default(_that.hypertrophy,_that.powerlifting);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  Tier? hypertrophy, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  Tier? powerlifting)?  $default,) {final _that = this;
switch (_that) {
case _Tiers() when $default != null:
return $default(_that.hypertrophy,_that.powerlifting);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Tiers extends Tiers {
  const _Tiers({@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) this.hypertrophy, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) this.powerlifting}): super._();
  factory _Tiers.fromJson(Map<String, dynamic> json) => _$TiersFromJson(json);

@override@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) final  Tier? hypertrophy;
@override@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) final  Tier? powerlifting;

/// Create a copy of Tiers
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TiersCopyWith<_Tiers> get copyWith => __$TiersCopyWithImpl<_Tiers>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TiersToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Tiers&&(identical(other.hypertrophy, hypertrophy) || other.hypertrophy == hypertrophy)&&(identical(other.powerlifting, powerlifting) || other.powerlifting == powerlifting));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,hypertrophy,powerlifting);
}

@override
String toString() {
    return 'Tiers(hypertrophy: $hypertrophy, powerlifting: $powerlifting)';
}


}

/// @nodoc
abstract mixin class _$TiersCopyWith<$Res> implements $TiersCopyWith<$Res> {
  factory _$TiersCopyWith(_Tiers value, $Res Function(_Tiers) _then) = __$TiersCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) Tier? hypertrophy,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) Tier? powerlifting
});




}
/// @nodoc
class __$TiersCopyWithImpl<$Res>
    implements _$TiersCopyWith<$Res> {
  __$TiersCopyWithImpl(this._self, this._then);

  final _Tiers _self;
  final $Res Function(_Tiers) _then;

/// Create a copy of Tiers
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hypertrophy = freezed,Object? powerlifting = freezed,}) {
  return _then(_Tiers(
hypertrophy: freezed == hypertrophy ? _self.hypertrophy : hypertrophy // ignore: cast_nullable_to_non_nullable
as Tier?,powerlifting: freezed == powerlifting ? _self.powerlifting : powerlifting // ignore: cast_nullable_to_non_nullable
as Tier?,
  ));
}


}


/// @nodoc
mixin _$Exercise {

 String get id;/// In the UI language.
 String get name; String get primaryMuscle; String get equipment; List<String> get secondaryMuscles; String? get mechanic; String? get category; String? get slug; String? get imageUrl; List<String> get tags; Tiers get tiers; bool get isGlobal; bool get isCustom;
/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseCopyWith<Exercise> get copyWith => _$ExerciseCopyWithImpl<Exercise>(this as Exercise, _$identity);

  /// Serializes this Exercise to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Exercise;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Exercise&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.primaryMuscle, _this.primaryMuscle) || other.primaryMuscle == _this.primaryMuscle)&&(identical(other.equipment, _this.equipment) || other.equipment == _this.equipment)&&const DeepCollectionEquality().equals(other.secondaryMuscles, _this.secondaryMuscles)&&(identical(other.mechanic, _this.mechanic) || other.mechanic == _this.mechanic)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&const DeepCollectionEquality().equals(other.tags, _this.tags)&&(identical(other.tiers, _this.tiers) || other.tiers == _this.tiers)&&(identical(other.isGlobal, _this.isGlobal) || other.isGlobal == _this.isGlobal)&&(identical(other.isCustom, _this.isCustom) || other.isCustom == _this.isCustom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Exercise;
  return Object.hash(runtimeType,_this.id,_this.name,_this.primaryMuscle,_this.equipment,const DeepCollectionEquality().hash(_this.secondaryMuscles),_this.mechanic,_this.category,_this.slug,_this.imageUrl,const DeepCollectionEquality().hash(_this.tags),_this.tiers,_this.isGlobal,_this.isCustom);
}

@override
String toString() {
  final _this = this as Exercise;
  return 'Exercise(id: ${_this.id}, name: ${_this.name}, primaryMuscle: ${_this.primaryMuscle}, equipment: ${_this.equipment}, secondaryMuscles: ${_this.secondaryMuscles}, mechanic: ${_this.mechanic}, category: ${_this.category}, slug: ${_this.slug}, imageUrl: ${_this.imageUrl}, tags: ${_this.tags}, tiers: ${_this.tiers}, isGlobal: ${_this.isGlobal}, isCustom: ${_this.isCustom})';
}


}

/// @nodoc
abstract mixin class $ExerciseCopyWith<$Res>  {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) _then) = _$ExerciseCopyWithImpl;
@useResult
$Res call({
 String id, String name, String primaryMuscle, String equipment, List<String> secondaryMuscles, String? mechanic, String? category, String? slug, String? imageUrl, List<String> tags, Tiers tiers, bool isGlobal, bool isCustom
});


$TiersCopyWith<$Res> get tiers;

}
/// @nodoc
class _$ExerciseCopyWithImpl<$Res>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._self, this._then);

  final Exercise _self;
  final $Res Function(Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? primaryMuscle = null,Object? equipment = null,Object? secondaryMuscles = null,Object? mechanic = freezed,Object? category = freezed,Object? slug = freezed,Object? imageUrl = freezed,Object? tags = null,Object? tiers = null,Object? isGlobal = null,Object? isCustom = null,}) {
  return _then(Exercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,primaryMuscle: null == primaryMuscle ? _self.primaryMuscle : primaryMuscle // ignore: cast_nullable_to_non_nullable
as String,equipment: null == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as String,secondaryMuscles: null == secondaryMuscles ? _self.secondaryMuscles : secondaryMuscles // ignore: cast_nullable_to_non_nullable
as List<String>,mechanic: freezed == mechanic ? _self.mechanic : mechanic // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,tiers: null == tiers ? _self.tiers : tiers // ignore: cast_nullable_to_non_nullable
as Tiers,isGlobal: null == isGlobal ? _self.isGlobal : isGlobal // ignore: cast_nullable_to_non_nullable
as bool,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TiersCopyWith<$Res> get tiers {
  
  return $TiersCopyWith<$Res>(_self.tiers, (value) {
    return _then(_self.copyWith(tiers: value));
  });
}
}


/// Adds pattern-matching-related methods to [Exercise].
extension ExercisePatterns on Exercise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Exercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Exercise value)  $default,){
final _that = this;
switch (_that) {
case _Exercise():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Exercise value)?  $default,){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String primaryMuscle,  String equipment,  List<String> secondaryMuscles,  String? mechanic,  String? category,  String? slug,  String? imageUrl,  List<String> tags,  Tiers tiers,  bool isGlobal,  bool isCustom)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.id,_that.name,_that.primaryMuscle,_that.equipment,_that.secondaryMuscles,_that.mechanic,_that.category,_that.slug,_that.imageUrl,_that.tags,_that.tiers,_that.isGlobal,_that.isCustom);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String primaryMuscle,  String equipment,  List<String> secondaryMuscles,  String? mechanic,  String? category,  String? slug,  String? imageUrl,  List<String> tags,  Tiers tiers,  bool isGlobal,  bool isCustom)  $default,) {final _that = this;
switch (_that) {
case _Exercise():
return $default(_that.id,_that.name,_that.primaryMuscle,_that.equipment,_that.secondaryMuscles,_that.mechanic,_that.category,_that.slug,_that.imageUrl,_that.tags,_that.tiers,_that.isGlobal,_that.isCustom);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String primaryMuscle,  String equipment,  List<String> secondaryMuscles,  String? mechanic,  String? category,  String? slug,  String? imageUrl,  List<String> tags,  Tiers tiers,  bool isGlobal,  bool isCustom)?  $default,) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.id,_that.name,_that.primaryMuscle,_that.equipment,_that.secondaryMuscles,_that.mechanic,_that.category,_that.slug,_that.imageUrl,_that.tags,_that.tiers,_that.isGlobal,_that.isCustom);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Exercise implements Exercise {
  const _Exercise({required this.id, required this.name, required this.primaryMuscle, required this.equipment,  List<String> secondaryMuscles = const [], this.mechanic, this.category, this.slug, this.imageUrl,  List<String> tags = const [], this.tiers = const Tiers(), this.isGlobal = false, this.isCustom = false}): _secondaryMuscles = secondaryMuscles,_tags = tags;
  factory _Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);

@override final  String id;
/// In the UI language.
@override final  String name;
@override final  String primaryMuscle;
@override final  String equipment;
 final  List<String> _secondaryMuscles;
@override@JsonKey() List<String> get secondaryMuscles {
  if (_secondaryMuscles is EqualUnmodifiableListView) return _secondaryMuscles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_secondaryMuscles);
}

@override final  String? mechanic;
@override final  String? category;
@override final  String? slug;
@override final  String? imageUrl;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey() final  Tiers tiers;
@override@JsonKey() final  bool isGlobal;
@override@JsonKey() final  bool isCustom;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseCopyWith<_Exercise> get copyWith => __$ExerciseCopyWithImpl<_Exercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Exercise&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.primaryMuscle, primaryMuscle) || other.primaryMuscle == primaryMuscle)&&(identical(other.equipment, equipment) || other.equipment == equipment)&&const DeepCollectionEquality().equals(other.secondaryMuscles, _secondaryMuscles)&&(identical(other.mechanic, mechanic) || other.mechanic == mechanic)&&(identical(other.category, category) || other.category == category)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.tags, _tags)&&(identical(other.tiers, tiers) || other.tiers == tiers)&&(identical(other.isGlobal, isGlobal) || other.isGlobal == isGlobal)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,primaryMuscle,equipment,const DeepCollectionEquality().hash(_secondaryMuscles),mechanic,category,slug,imageUrl,const DeepCollectionEquality().hash(_tags),tiers,isGlobal,isCustom);
}

@override
String toString() {
    return 'Exercise(id: $id, name: $name, primaryMuscle: $primaryMuscle, equipment: $equipment, secondaryMuscles: $secondaryMuscles, mechanic: $mechanic, category: $category, slug: $slug, imageUrl: $imageUrl, tags: $tags, tiers: $tiers, isGlobal: $isGlobal, isCustom: $isCustom)';
}


}

/// @nodoc
abstract mixin class _$ExerciseCopyWith<$Res> implements $ExerciseCopyWith<$Res> {
  factory _$ExerciseCopyWith(_Exercise value, $Res Function(_Exercise) _then) = __$ExerciseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String primaryMuscle, String equipment, List<String> secondaryMuscles, String? mechanic, String? category, String? slug, String? imageUrl, List<String> tags, Tiers tiers, bool isGlobal, bool isCustom
});


@override $TiersCopyWith<$Res> get tiers;

}
/// @nodoc
class __$ExerciseCopyWithImpl<$Res>
    implements _$ExerciseCopyWith<$Res> {
  __$ExerciseCopyWithImpl(this._self, this._then);

  final _Exercise _self;
  final $Res Function(_Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? primaryMuscle = null,Object? equipment = null,Object? secondaryMuscles = null,Object? mechanic = freezed,Object? category = freezed,Object? slug = freezed,Object? imageUrl = freezed,Object? tags = null,Object? tiers = null,Object? isGlobal = null,Object? isCustom = null,}) {
  return _then(_Exercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,primaryMuscle: null == primaryMuscle ? _self.primaryMuscle : primaryMuscle // ignore: cast_nullable_to_non_nullable
as String,equipment: null == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as String,secondaryMuscles: null == secondaryMuscles ? _self._secondaryMuscles : secondaryMuscles // ignore: cast_nullable_to_non_nullable
as List<String>,mechanic: freezed == mechanic ? _self.mechanic : mechanic // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,tiers: null == tiers ? _self.tiers : tiers // ignore: cast_nullable_to_non_nullable
as Tiers,isGlobal: null == isGlobal ? _self.isGlobal : isGlobal // ignore: cast_nullable_to_non_nullable
as bool,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TiersCopyWith<$Res> get tiers {
  
  return $TiersCopyWith<$Res>(_self.tiers, (value) {
    return _then(_self.copyWith(tiers: value));
  });
}
}


/// @nodoc
mixin _$ExercisePref {

 String get exerciseId; bool get isFavorite; Tiers get personalTiers;
/// Create a copy of ExercisePref
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExercisePrefCopyWith<ExercisePref> get copyWith => _$ExercisePrefCopyWithImpl<ExercisePref>(this as ExercisePref, _$identity);

  /// Serializes this ExercisePref to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExercisePref;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExercisePref&&(identical(other.exerciseId, _this.exerciseId) || other.exerciseId == _this.exerciseId)&&(identical(other.isFavorite, _this.isFavorite) || other.isFavorite == _this.isFavorite)&&(identical(other.personalTiers, _this.personalTiers) || other.personalTiers == _this.personalTiers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExercisePref;
  return Object.hash(runtimeType,_this.exerciseId,_this.isFavorite,_this.personalTiers);
}

@override
String toString() {
  final _this = this as ExercisePref;
  return 'ExercisePref(exerciseId: ${_this.exerciseId}, isFavorite: ${_this.isFavorite}, personalTiers: ${_this.personalTiers})';
}


}

/// @nodoc
abstract mixin class $ExercisePrefCopyWith<$Res>  {
  factory $ExercisePrefCopyWith(ExercisePref value, $Res Function(ExercisePref) _then) = _$ExercisePrefCopyWithImpl;
@useResult
$Res call({
 String exerciseId, bool isFavorite, Tiers personalTiers
});


$TiersCopyWith<$Res> get personalTiers;

}
/// @nodoc
class _$ExercisePrefCopyWithImpl<$Res>
    implements $ExercisePrefCopyWith<$Res> {
  _$ExercisePrefCopyWithImpl(this._self, this._then);

  final ExercisePref _self;
  final $Res Function(ExercisePref) _then;

/// Create a copy of ExercisePref
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exerciseId = null,Object? isFavorite = null,Object? personalTiers = null,}) {
  return _then(ExercisePref(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,personalTiers: null == personalTiers ? _self.personalTiers : personalTiers // ignore: cast_nullable_to_non_nullable
as Tiers,
  ));
}
/// Create a copy of ExercisePref
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TiersCopyWith<$Res> get personalTiers {
  
  return $TiersCopyWith<$Res>(_self.personalTiers, (value) {
    return _then(_self.copyWith(personalTiers: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExercisePref].
extension ExercisePrefPatterns on ExercisePref {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExercisePref value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExercisePref() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExercisePref value)  $default,){
final _that = this;
switch (_that) {
case _ExercisePref():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExercisePref value)?  $default,){
final _that = this;
switch (_that) {
case _ExercisePref() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String exerciseId,  bool isFavorite,  Tiers personalTiers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExercisePref() when $default != null:
return $default(_that.exerciseId,_that.isFavorite,_that.personalTiers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String exerciseId,  bool isFavorite,  Tiers personalTiers)  $default,) {final _that = this;
switch (_that) {
case _ExercisePref():
return $default(_that.exerciseId,_that.isFavorite,_that.personalTiers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String exerciseId,  bool isFavorite,  Tiers personalTiers)?  $default,) {final _that = this;
switch (_that) {
case _ExercisePref() when $default != null:
return $default(_that.exerciseId,_that.isFavorite,_that.personalTiers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExercisePref implements ExercisePref {
  const _ExercisePref({required this.exerciseId, this.isFavorite = false, this.personalTiers = const Tiers()});
  factory _ExercisePref.fromJson(Map<String, dynamic> json) => _$ExercisePrefFromJson(json);

@override final  String exerciseId;
@override@JsonKey() final  bool isFavorite;
@override@JsonKey() final  Tiers personalTiers;

/// Create a copy of ExercisePref
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExercisePrefCopyWith<_ExercisePref> get copyWith => __$ExercisePrefCopyWithImpl<_ExercisePref>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExercisePrefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExercisePref&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.personalTiers, personalTiers) || other.personalTiers == personalTiers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,exerciseId,isFavorite,personalTiers);
}

@override
String toString() {
    return 'ExercisePref(exerciseId: $exerciseId, isFavorite: $isFavorite, personalTiers: $personalTiers)';
}


}

/// @nodoc
abstract mixin class _$ExercisePrefCopyWith<$Res> implements $ExercisePrefCopyWith<$Res> {
  factory _$ExercisePrefCopyWith(_ExercisePref value, $Res Function(_ExercisePref) _then) = __$ExercisePrefCopyWithImpl;
@override @useResult
$Res call({
 String exerciseId, bool isFavorite, Tiers personalTiers
});


@override $TiersCopyWith<$Res> get personalTiers;

}
/// @nodoc
class __$ExercisePrefCopyWithImpl<$Res>
    implements _$ExercisePrefCopyWith<$Res> {
  __$ExercisePrefCopyWithImpl(this._self, this._then);

  final _ExercisePref _self;
  final $Res Function(_ExercisePref) _then;

/// Create a copy of ExercisePref
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exerciseId = null,Object? isFavorite = null,Object? personalTiers = null,}) {
  return _then(_ExercisePref(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,personalTiers: null == personalTiers ? _self.personalTiers : personalTiers // ignore: cast_nullable_to_non_nullable
as Tiers,
  ));
}

/// Create a copy of ExercisePref
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TiersCopyWith<$Res> get personalTiers {
  
  return $TiersCopyWith<$Res>(_self.personalTiers, (value) {
    return _then(_self.copyWith(personalTiers: value));
  });
}
}

// dart format on
