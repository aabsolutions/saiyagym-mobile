// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$User {

 String get id; String get email; UserRole get role; bool get emailVerified; UserPreferences get preferences; UserPlan get plan; String? get name;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as User;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.emailVerified, _this.emailVerified) || other.emailVerified == _this.emailVerified)&&(identical(other.preferences, _this.preferences) || other.preferences == _this.preferences)&&(identical(other.plan, _this.plan) || other.plan == _this.plan)&&(identical(other.name, _this.name) || other.name == _this.name));
}


@override
int get hashCode {
  final _this = this as User;
  return Object.hash(runtimeType,_this.id,_this.email,_this.role,_this.emailVerified,_this.preferences,_this.plan,_this.name);
}

@override
String toString() {
  final _this = this as User;
  return 'User(id: ${_this.id}, email: ${_this.email}, role: ${_this.role}, emailVerified: ${_this.emailVerified}, preferences: ${_this.preferences}, plan: ${_this.plan}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String id, String email, UserRole role, bool emailVerified, UserPreferences preferences, UserPlan plan, String? name
});


$UserPreferencesCopyWith<$Res> get preferences;$UserPlanCopyWith<$Res> get plan;

}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? role = null,Object? emailVerified = null,Object? preferences = null,Object? plan = null,Object? name = freezed,}) {
  return _then(User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as UserPreferences,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as UserPlan,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserPreferencesCopyWith<$Res> get preferences {
  
  return $UserPreferencesCopyWith<$Res>(_self.preferences, (value) {
    return _then(_self.copyWith(preferences: value));
  });
}/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserPlanCopyWith<$Res> get plan {
  
  return $UserPlanCopyWith<$Res>(_self.plan, (value) {
    return _then(_self.copyWith(plan: value));
  });
}
}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  UserRole role,  bool emailVerified,  UserPreferences preferences,  UserPlan plan,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.email,_that.role,_that.emailVerified,_that.preferences,_that.plan,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  UserRole role,  bool emailVerified,  UserPreferences preferences,  UserPlan plan,  String? name)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.email,_that.role,_that.emailVerified,_that.preferences,_that.plan,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  UserRole role,  bool emailVerified,  UserPreferences preferences,  UserPlan plan,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.email,_that.role,_that.emailVerified,_that.preferences,_that.plan,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _User implements User {
  const _User({required this.id, required this.email, required this.role, required this.emailVerified, required this.preferences, required this.plan, this.name});
  

@override final  String id;
@override final  String email;
@override final  UserRole role;
@override final  bool emailVerified;
@override final  UserPreferences preferences;
@override final  UserPlan plan;
@override final  String? name;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.preferences, preferences) || other.preferences == preferences)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,email,role,emailVerified,preferences,plan,name);
}

@override
String toString() {
    return 'User(id: $id, email: $email, role: $role, emailVerified: $emailVerified, preferences: $preferences, plan: $plan, name: $name)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, UserRole role, bool emailVerified, UserPreferences preferences, UserPlan plan, String? name
});


@override $UserPreferencesCopyWith<$Res> get preferences;@override $UserPlanCopyWith<$Res> get plan;

}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? role = null,Object? emailVerified = null,Object? preferences = null,Object? plan = null,Object? name = freezed,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as UserPreferences,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as UserPlan,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserPreferencesCopyWith<$Res> get preferences {
  
  return $UserPreferencesCopyWith<$Res>(_self.preferences, (value) {
    return _then(_self.copyWith(preferences: value));
  });
}/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserPlanCopyWith<$Res> get plan {
  
  return $UserPlanCopyWith<$Res>(_self.plan, (value) {
    return _then(_self.copyWith(plan: value));
  });
}
}

/// @nodoc
mixin _$UserPreferences {

 UnitSystem get units; ThemePreference get theme; String get language; int get defaultRestSeconds;/// ISO weekday: 1 = Monday … 7 = Sunday.
 int get firstDayOfWeek;
/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserPreferencesCopyWith<UserPreferences> get copyWith => _$UserPreferencesCopyWithImpl<UserPreferences>(this as UserPreferences, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UserPreferences;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserPreferences&&(identical(other.units, _this.units) || other.units == _this.units)&&(identical(other.theme, _this.theme) || other.theme == _this.theme)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.defaultRestSeconds, _this.defaultRestSeconds) || other.defaultRestSeconds == _this.defaultRestSeconds)&&(identical(other.firstDayOfWeek, _this.firstDayOfWeek) || other.firstDayOfWeek == _this.firstDayOfWeek));
}


@override
int get hashCode {
  final _this = this as UserPreferences;
  return Object.hash(runtimeType,_this.units,_this.theme,_this.language,_this.defaultRestSeconds,_this.firstDayOfWeek);
}

@override
String toString() {
  final _this = this as UserPreferences;
  return 'UserPreferences(units: ${_this.units}, theme: ${_this.theme}, language: ${_this.language}, defaultRestSeconds: ${_this.defaultRestSeconds}, firstDayOfWeek: ${_this.firstDayOfWeek})';
}


}

/// @nodoc
abstract mixin class $UserPreferencesCopyWith<$Res>  {
  factory $UserPreferencesCopyWith(UserPreferences value, $Res Function(UserPreferences) _then) = _$UserPreferencesCopyWithImpl;
@useResult
$Res call({
 UnitSystem units, ThemePreference theme, String language, int defaultRestSeconds, int firstDayOfWeek
});




}
/// @nodoc
class _$UserPreferencesCopyWithImpl<$Res>
    implements $UserPreferencesCopyWith<$Res> {
  _$UserPreferencesCopyWithImpl(this._self, this._then);

  final UserPreferences _self;
  final $Res Function(UserPreferences) _then;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? units = null,Object? theme = null,Object? language = null,Object? defaultRestSeconds = null,Object? firstDayOfWeek = null,}) {
  return _then(UserPreferences(
units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as UnitSystem,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemePreference,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,defaultRestSeconds: null == defaultRestSeconds ? _self.defaultRestSeconds : defaultRestSeconds // ignore: cast_nullable_to_non_nullable
as int,firstDayOfWeek: null == firstDayOfWeek ? _self.firstDayOfWeek : firstDayOfWeek // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserPreferences].
extension UserPreferencesPatterns on UserPreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserPreferences value)  $default,){
final _that = this;
switch (_that) {
case _UserPreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UnitSystem units,  ThemePreference theme,  String language,  int defaultRestSeconds,  int firstDayOfWeek)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
return $default(_that.units,_that.theme,_that.language,_that.defaultRestSeconds,_that.firstDayOfWeek);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UnitSystem units,  ThemePreference theme,  String language,  int defaultRestSeconds,  int firstDayOfWeek)  $default,) {final _that = this;
switch (_that) {
case _UserPreferences():
return $default(_that.units,_that.theme,_that.language,_that.defaultRestSeconds,_that.firstDayOfWeek);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UnitSystem units,  ThemePreference theme,  String language,  int defaultRestSeconds,  int firstDayOfWeek)?  $default,) {final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
return $default(_that.units,_that.theme,_that.language,_that.defaultRestSeconds,_that.firstDayOfWeek);case _:
  return null;

}
}

}

/// @nodoc


class _UserPreferences implements UserPreferences {
  const _UserPreferences({this.units = UnitSystem.metric, this.theme = ThemePreference.system, this.language = 'es', this.defaultRestSeconds = 90, this.firstDayOfWeek = 1});
  

@override@JsonKey() final  UnitSystem units;
@override@JsonKey() final  ThemePreference theme;
@override@JsonKey() final  String language;
@override@JsonKey() final  int defaultRestSeconds;
/// ISO weekday: 1 = Monday … 7 = Sunday.
@override@JsonKey() final  int firstDayOfWeek;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserPreferencesCopyWith<_UserPreferences> get copyWith => __$UserPreferencesCopyWithImpl<_UserPreferences>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserPreferences&&(identical(other.units, units) || other.units == units)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.language, language) || other.language == language)&&(identical(other.defaultRestSeconds, defaultRestSeconds) || other.defaultRestSeconds == defaultRestSeconds)&&(identical(other.firstDayOfWeek, firstDayOfWeek) || other.firstDayOfWeek == firstDayOfWeek));
}


@override
int get hashCode {
    return Object.hash(runtimeType,units,theme,language,defaultRestSeconds,firstDayOfWeek);
}

@override
String toString() {
    return 'UserPreferences(units: $units, theme: $theme, language: $language, defaultRestSeconds: $defaultRestSeconds, firstDayOfWeek: $firstDayOfWeek)';
}


}

/// @nodoc
abstract mixin class _$UserPreferencesCopyWith<$Res> implements $UserPreferencesCopyWith<$Res> {
  factory _$UserPreferencesCopyWith(_UserPreferences value, $Res Function(_UserPreferences) _then) = __$UserPreferencesCopyWithImpl;
@override @useResult
$Res call({
 UnitSystem units, ThemePreference theme, String language, int defaultRestSeconds, int firstDayOfWeek
});




}
/// @nodoc
class __$UserPreferencesCopyWithImpl<$Res>
    implements _$UserPreferencesCopyWith<$Res> {
  __$UserPreferencesCopyWithImpl(this._self, this._then);

  final _UserPreferences _self;
  final $Res Function(_UserPreferences) _then;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? units = null,Object? theme = null,Object? language = null,Object? defaultRestSeconds = null,Object? firstDayOfWeek = null,}) {
  return _then(_UserPreferences(
units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as UnitSystem,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemePreference,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,defaultRestSeconds: null == defaultRestSeconds ? _self.defaultRestSeconds : defaultRestSeconds // ignore: cast_nullable_to_non_nullable
as int,firstDayOfWeek: null == firstDayOfWeek ? _self.firstDayOfWeek : firstDayOfWeek // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$UserPlan {

 String get code; String get name;
/// Create a copy of UserPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserPlanCopyWith<UserPlan> get copyWith => _$UserPlanCopyWithImpl<UserPlan>(this as UserPlan, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UserPlan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserPlan&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name));
}


@override
int get hashCode {
  final _this = this as UserPlan;
  return Object.hash(runtimeType,_this.code,_this.name);
}

@override
String toString() {
  final _this = this as UserPlan;
  return 'UserPlan(code: ${_this.code}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $UserPlanCopyWith<$Res>  {
  factory $UserPlanCopyWith(UserPlan value, $Res Function(UserPlan) _then) = _$UserPlanCopyWithImpl;
@useResult
$Res call({
 String code, String name
});




}
/// @nodoc
class _$UserPlanCopyWithImpl<$Res>
    implements $UserPlanCopyWith<$Res> {
  _$UserPlanCopyWithImpl(this._self, this._then);

  final UserPlan _self;
  final $Res Function(UserPlan) _then;

/// Create a copy of UserPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? name = null,}) {
  return _then(UserPlan(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserPlan].
extension UserPlanPatterns on UserPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserPlan value)  $default,){
final _that = this;
switch (_that) {
case _UserPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserPlan value)?  $default,){
final _that = this;
switch (_that) {
case _UserPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserPlan() when $default != null:
return $default(_that.code,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String name)  $default,) {final _that = this;
switch (_that) {
case _UserPlan():
return $default(_that.code,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String name)?  $default,) {final _that = this;
switch (_that) {
case _UserPlan() when $default != null:
return $default(_that.code,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _UserPlan implements UserPlan {
  const _UserPlan({required this.code, required this.name});
  

@override final  String code;
@override final  String name;

/// Create a copy of UserPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserPlanCopyWith<_UserPlan> get copyWith => __$UserPlanCopyWithImpl<_UserPlan>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserPlan&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,name);
}

@override
String toString() {
    return 'UserPlan(code: $code, name: $name)';
}


}

/// @nodoc
abstract mixin class _$UserPlanCopyWith<$Res> implements $UserPlanCopyWith<$Res> {
  factory _$UserPlanCopyWith(_UserPlan value, $Res Function(_UserPlan) _then) = __$UserPlanCopyWithImpl;
@override @useResult
$Res call({
 String code, String name
});




}
/// @nodoc
class __$UserPlanCopyWithImpl<$Res>
    implements _$UserPlanCopyWith<$Res> {
  __$UserPlanCopyWithImpl(this._self, this._then);

  final _UserPlan _self;
  final $Res Function(_UserPlan) _then;

/// Create a copy of UserPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? name = null,}) {
  return _then(_UserPlan(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
