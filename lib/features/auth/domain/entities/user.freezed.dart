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

 String get id; String get email; UserRole get role; bool get emailVerified; UserProfile get profile; UserPreferences get preferences; UserPlan get plan;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as User;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.emailVerified, _this.emailVerified) || other.emailVerified == _this.emailVerified)&&(identical(other.profile, _this.profile) || other.profile == _this.profile)&&(identical(other.preferences, _this.preferences) || other.preferences == _this.preferences)&&(identical(other.plan, _this.plan) || other.plan == _this.plan));
}


@override
int get hashCode {
  final _this = this as User;
  return Object.hash(runtimeType,_this.id,_this.email,_this.role,_this.emailVerified,_this.profile,_this.preferences,_this.plan);
}

@override
String toString() {
  final _this = this as User;
  return 'User(id: ${_this.id}, email: ${_this.email}, role: ${_this.role}, emailVerified: ${_this.emailVerified}, profile: ${_this.profile}, preferences: ${_this.preferences}, plan: ${_this.plan})';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String id, String email, UserRole role, bool emailVerified, UserProfile profile, UserPreferences preferences, UserPlan plan
});


$UserProfileCopyWith<$Res> get profile;$UserPreferencesCopyWith<$Res> get preferences;$UserPlanCopyWith<$Res> get plan;

}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? role = null,Object? emailVerified = null,Object? profile = null,Object? preferences = null,Object? plan = null,}) {
  return _then(User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as UserProfile,preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as UserPreferences,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as UserPlan,
  ));
}
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res> get profile {
  
  return $UserProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of User
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  UserRole role,  bool emailVerified,  UserProfile profile,  UserPreferences preferences,  UserPlan plan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.email,_that.role,_that.emailVerified,_that.profile,_that.preferences,_that.plan);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  UserRole role,  bool emailVerified,  UserProfile profile,  UserPreferences preferences,  UserPlan plan)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.email,_that.role,_that.emailVerified,_that.profile,_that.preferences,_that.plan);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  UserRole role,  bool emailVerified,  UserProfile profile,  UserPreferences preferences,  UserPlan plan)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.email,_that.role,_that.emailVerified,_that.profile,_that.preferences,_that.plan);case _:
  return null;

}
}

}

/// @nodoc


class _User extends User {
  const _User({required this.id, required this.email, required this.role, required this.emailVerified, required this.profile, required this.preferences, required this.plan}): super._();
  

@override final  String id;
@override final  String email;
@override final  UserRole role;
@override final  bool emailVerified;
@override final  UserProfile profile;
@override final  UserPreferences preferences;
@override final  UserPlan plan;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.preferences, preferences) || other.preferences == preferences)&&(identical(other.plan, plan) || other.plan == plan));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,email,role,emailVerified,profile,preferences,plan);
}

@override
String toString() {
    return 'User(id: $id, email: $email, role: $role, emailVerified: $emailVerified, profile: $profile, preferences: $preferences, plan: $plan)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, UserRole role, bool emailVerified, UserProfile profile, UserPreferences preferences, UserPlan plan
});


@override $UserProfileCopyWith<$Res> get profile;@override $UserPreferencesCopyWith<$Res> get preferences;@override $UserPlanCopyWith<$Res> get plan;

}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? role = null,Object? emailVerified = null,Object? profile = null,Object? preferences = null,Object? plan = null,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as UserProfile,preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as UserPreferences,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as UserPlan,
  ));
}

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res> get profile {
  
  return $UserProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of User
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
mixin _$UserProfile {

 String? get name;/// Calendar date (no time zone meaning).
 DateTime? get birthDate; Sex? get sex; double? get heightCm; TrainingLevel? get level; TrainingGoal? get goal;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UserProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.birthDate, _this.birthDate) || other.birthDate == _this.birthDate)&&(identical(other.sex, _this.sex) || other.sex == _this.sex)&&(identical(other.heightCm, _this.heightCm) || other.heightCm == _this.heightCm)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.goal, _this.goal) || other.goal == _this.goal));
}


@override
int get hashCode {
  final _this = this as UserProfile;
  return Object.hash(runtimeType,_this.name,_this.birthDate,_this.sex,_this.heightCm,_this.level,_this.goal);
}

@override
String toString() {
  final _this = this as UserProfile;
  return 'UserProfile(name: ${_this.name}, birthDate: ${_this.birthDate}, sex: ${_this.sex}, heightCm: ${_this.heightCm}, level: ${_this.level}, goal: ${_this.goal})';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String? name, DateTime? birthDate, Sex? sex, double? heightCm, TrainingLevel? level, TrainingGoal? goal
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? birthDate = freezed,Object? sex = freezed,Object? heightCm = freezed,Object? level = freezed,Object? goal = freezed,}) {
  return _then(UserProfile(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as Sex?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as TrainingLevel?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as TrainingGoal?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  DateTime? birthDate,  Sex? sex,  double? heightCm,  TrainingLevel? level,  TrainingGoal? goal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.name,_that.birthDate,_that.sex,_that.heightCm,_that.level,_that.goal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  DateTime? birthDate,  Sex? sex,  double? heightCm,  TrainingLevel? level,  TrainingGoal? goal)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.name,_that.birthDate,_that.sex,_that.heightCm,_that.level,_that.goal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  DateTime? birthDate,  Sex? sex,  double? heightCm,  TrainingLevel? level,  TrainingGoal? goal)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.name,_that.birthDate,_that.sex,_that.heightCm,_that.level,_that.goal);case _:
  return null;

}
}

}

/// @nodoc


class _UserProfile implements UserProfile {
  const _UserProfile({this.name, this.birthDate, this.sex, this.heightCm, this.level, this.goal});
  

@override final  String? name;
/// Calendar date (no time zone meaning).
@override final  DateTime? birthDate;
@override final  Sex? sex;
@override final  double? heightCm;
@override final  TrainingLevel? level;
@override final  TrainingGoal? goal;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.name, name) || other.name == name)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.level, level) || other.level == level)&&(identical(other.goal, goal) || other.goal == goal));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,birthDate,sex,heightCm,level,goal);
}

@override
String toString() {
    return 'UserProfile(name: $name, birthDate: $birthDate, sex: $sex, heightCm: $heightCm, level: $level, goal: $goal)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String? name, DateTime? birthDate, Sex? sex, double? heightCm, TrainingLevel? level, TrainingGoal? goal
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? birthDate = freezed,Object? sex = freezed,Object? heightCm = freezed,Object? level = freezed,Object? goal = freezed,}) {
  return _then(_UserProfile(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as Sex?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as TrainingLevel?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as TrainingGoal?,
  ));
}


}

/// @nodoc
mixin _$UserPreferences {

 UnitSystem get units; ThemePreference get theme; String get language; int get defaultRestSeconds;/// ISO weekday: 1 = Monday … 7 = Sunday.
 int get firstDayOfWeek;/// Rest-alarm sound. The API returns the EFFECTIVE id: `null` when none
/// is chosen, it was deleted, or the plan no longer allows it.
 String? get restSoundId;/// Same contract as [restSoundId], for the training / weigh-in reminders.
 String? get trainingReminderSoundId; String? get weighInSoundId;
/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserPreferencesCopyWith<UserPreferences> get copyWith => _$UserPreferencesCopyWithImpl<UserPreferences>(this as UserPreferences, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UserPreferences;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserPreferences&&(identical(other.units, _this.units) || other.units == _this.units)&&(identical(other.theme, _this.theme) || other.theme == _this.theme)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.defaultRestSeconds, _this.defaultRestSeconds) || other.defaultRestSeconds == _this.defaultRestSeconds)&&(identical(other.firstDayOfWeek, _this.firstDayOfWeek) || other.firstDayOfWeek == _this.firstDayOfWeek)&&(identical(other.restSoundId, _this.restSoundId) || other.restSoundId == _this.restSoundId)&&(identical(other.trainingReminderSoundId, _this.trainingReminderSoundId) || other.trainingReminderSoundId == _this.trainingReminderSoundId)&&(identical(other.weighInSoundId, _this.weighInSoundId) || other.weighInSoundId == _this.weighInSoundId));
}


@override
int get hashCode {
  final _this = this as UserPreferences;
  return Object.hash(runtimeType,_this.units,_this.theme,_this.language,_this.defaultRestSeconds,_this.firstDayOfWeek,_this.restSoundId,_this.trainingReminderSoundId,_this.weighInSoundId);
}

@override
String toString() {
  final _this = this as UserPreferences;
  return 'UserPreferences(units: ${_this.units}, theme: ${_this.theme}, language: ${_this.language}, defaultRestSeconds: ${_this.defaultRestSeconds}, firstDayOfWeek: ${_this.firstDayOfWeek}, restSoundId: ${_this.restSoundId}, trainingReminderSoundId: ${_this.trainingReminderSoundId}, weighInSoundId: ${_this.weighInSoundId})';
}


}

/// @nodoc
abstract mixin class $UserPreferencesCopyWith<$Res>  {
  factory $UserPreferencesCopyWith(UserPreferences value, $Res Function(UserPreferences) _then) = _$UserPreferencesCopyWithImpl;
@useResult
$Res call({
 UnitSystem units, ThemePreference theme, String language, int defaultRestSeconds, int firstDayOfWeek, String? restSoundId, String? trainingReminderSoundId, String? weighInSoundId
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
@pragma('vm:prefer-inline') @override $Res call({Object? units = null,Object? theme = null,Object? language = null,Object? defaultRestSeconds = null,Object? firstDayOfWeek = null,Object? restSoundId = freezed,Object? trainingReminderSoundId = freezed,Object? weighInSoundId = freezed,}) {
  return _then(UserPreferences(
units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as UnitSystem,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemePreference,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,defaultRestSeconds: null == defaultRestSeconds ? _self.defaultRestSeconds : defaultRestSeconds // ignore: cast_nullable_to_non_nullable
as int,firstDayOfWeek: null == firstDayOfWeek ? _self.firstDayOfWeek : firstDayOfWeek // ignore: cast_nullable_to_non_nullable
as int,restSoundId: freezed == restSoundId ? _self.restSoundId : restSoundId // ignore: cast_nullable_to_non_nullable
as String?,trainingReminderSoundId: freezed == trainingReminderSoundId ? _self.trainingReminderSoundId : trainingReminderSoundId // ignore: cast_nullable_to_non_nullable
as String?,weighInSoundId: freezed == weighInSoundId ? _self.weighInSoundId : weighInSoundId // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UnitSystem units,  ThemePreference theme,  String language,  int defaultRestSeconds,  int firstDayOfWeek,  String? restSoundId,  String? trainingReminderSoundId,  String? weighInSoundId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
return $default(_that.units,_that.theme,_that.language,_that.defaultRestSeconds,_that.firstDayOfWeek,_that.restSoundId,_that.trainingReminderSoundId,_that.weighInSoundId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UnitSystem units,  ThemePreference theme,  String language,  int defaultRestSeconds,  int firstDayOfWeek,  String? restSoundId,  String? trainingReminderSoundId,  String? weighInSoundId)  $default,) {final _that = this;
switch (_that) {
case _UserPreferences():
return $default(_that.units,_that.theme,_that.language,_that.defaultRestSeconds,_that.firstDayOfWeek,_that.restSoundId,_that.trainingReminderSoundId,_that.weighInSoundId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UnitSystem units,  ThemePreference theme,  String language,  int defaultRestSeconds,  int firstDayOfWeek,  String? restSoundId,  String? trainingReminderSoundId,  String? weighInSoundId)?  $default,) {final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
return $default(_that.units,_that.theme,_that.language,_that.defaultRestSeconds,_that.firstDayOfWeek,_that.restSoundId,_that.trainingReminderSoundId,_that.weighInSoundId);case _:
  return null;

}
}

}

/// @nodoc


class _UserPreferences implements UserPreferences {
  const _UserPreferences({this.units = UnitSystem.metric, this.theme = ThemePreference.system, this.language = 'es', this.defaultRestSeconds = 90, this.firstDayOfWeek = 1, this.restSoundId, this.trainingReminderSoundId, this.weighInSoundId});
  

@override@JsonKey() final  UnitSystem units;
@override@JsonKey() final  ThemePreference theme;
@override@JsonKey() final  String language;
@override@JsonKey() final  int defaultRestSeconds;
/// ISO weekday: 1 = Monday … 7 = Sunday.
@override@JsonKey() final  int firstDayOfWeek;
/// Rest-alarm sound. The API returns the EFFECTIVE id: `null` when none
/// is chosen, it was deleted, or the plan no longer allows it.
@override final  String? restSoundId;
/// Same contract as [restSoundId], for the training / weigh-in reminders.
@override final  String? trainingReminderSoundId;
@override final  String? weighInSoundId;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserPreferencesCopyWith<_UserPreferences> get copyWith => __$UserPreferencesCopyWithImpl<_UserPreferences>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserPreferences&&(identical(other.units, units) || other.units == units)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.language, language) || other.language == language)&&(identical(other.defaultRestSeconds, defaultRestSeconds) || other.defaultRestSeconds == defaultRestSeconds)&&(identical(other.firstDayOfWeek, firstDayOfWeek) || other.firstDayOfWeek == firstDayOfWeek)&&(identical(other.restSoundId, restSoundId) || other.restSoundId == restSoundId)&&(identical(other.trainingReminderSoundId, trainingReminderSoundId) || other.trainingReminderSoundId == trainingReminderSoundId)&&(identical(other.weighInSoundId, weighInSoundId) || other.weighInSoundId == weighInSoundId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,units,theme,language,defaultRestSeconds,firstDayOfWeek,restSoundId,trainingReminderSoundId,weighInSoundId);
}

@override
String toString() {
    return 'UserPreferences(units: $units, theme: $theme, language: $language, defaultRestSeconds: $defaultRestSeconds, firstDayOfWeek: $firstDayOfWeek, restSoundId: $restSoundId, trainingReminderSoundId: $trainingReminderSoundId, weighInSoundId: $weighInSoundId)';
}


}

/// @nodoc
abstract mixin class _$UserPreferencesCopyWith<$Res> implements $UserPreferencesCopyWith<$Res> {
  factory _$UserPreferencesCopyWith(_UserPreferences value, $Res Function(_UserPreferences) _then) = __$UserPreferencesCopyWithImpl;
@override @useResult
$Res call({
 UnitSystem units, ThemePreference theme, String language, int defaultRestSeconds, int firstDayOfWeek, String? restSoundId, String? trainingReminderSoundId, String? weighInSoundId
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
@override @pragma('vm:prefer-inline') $Res call({Object? units = null,Object? theme = null,Object? language = null,Object? defaultRestSeconds = null,Object? firstDayOfWeek = null,Object? restSoundId = freezed,Object? trainingReminderSoundId = freezed,Object? weighInSoundId = freezed,}) {
  return _then(_UserPreferences(
units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as UnitSystem,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemePreference,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,defaultRestSeconds: null == defaultRestSeconds ? _self.defaultRestSeconds : defaultRestSeconds // ignore: cast_nullable_to_non_nullable
as int,firstDayOfWeek: null == firstDayOfWeek ? _self.firstDayOfWeek : firstDayOfWeek // ignore: cast_nullable_to_non_nullable
as int,restSoundId: freezed == restSoundId ? _self.restSoundId : restSoundId // ignore: cast_nullable_to_non_nullable
as String?,trainingReminderSoundId: freezed == trainingReminderSoundId ? _self.trainingReminderSoundId : trainingReminderSoundId // ignore: cast_nullable_to_non_nullable
as String?,weighInSoundId: freezed == weighInSoundId ? _self.weighInSoundId : weighInSoundId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$UserPlan {

 String get code; String get name; Entitlements get entitlements;
/// Create a copy of UserPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserPlanCopyWith<UserPlan> get copyWith => _$UserPlanCopyWithImpl<UserPlan>(this as UserPlan, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UserPlan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserPlan&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.entitlements, _this.entitlements) || other.entitlements == _this.entitlements));
}


@override
int get hashCode {
  final _this = this as UserPlan;
  return Object.hash(runtimeType,_this.code,_this.name,_this.entitlements);
}

@override
String toString() {
  final _this = this as UserPlan;
  return 'UserPlan(code: ${_this.code}, name: ${_this.name}, entitlements: ${_this.entitlements})';
}


}

/// @nodoc
abstract mixin class $UserPlanCopyWith<$Res>  {
  factory $UserPlanCopyWith(UserPlan value, $Res Function(UserPlan) _then) = _$UserPlanCopyWithImpl;
@useResult
$Res call({
 String code, String name, Entitlements entitlements
});


$EntitlementsCopyWith<$Res> get entitlements;

}
/// @nodoc
class _$UserPlanCopyWithImpl<$Res>
    implements $UserPlanCopyWith<$Res> {
  _$UserPlanCopyWithImpl(this._self, this._then);

  final UserPlan _self;
  final $Res Function(UserPlan) _then;

/// Create a copy of UserPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? name = null,Object? entitlements = null,}) {
  return _then(UserPlan(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,entitlements: null == entitlements ? _self.entitlements : entitlements // ignore: cast_nullable_to_non_nullable
as Entitlements,
  ));
}
/// Create a copy of UserPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EntitlementsCopyWith<$Res> get entitlements {
  
  return $EntitlementsCopyWith<$Res>(_self.entitlements, (value) {
    return _then(_self.copyWith(entitlements: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String name,  Entitlements entitlements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserPlan() when $default != null:
return $default(_that.code,_that.name,_that.entitlements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String name,  Entitlements entitlements)  $default,) {final _that = this;
switch (_that) {
case _UserPlan():
return $default(_that.code,_that.name,_that.entitlements);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String name,  Entitlements entitlements)?  $default,) {final _that = this;
switch (_that) {
case _UserPlan() when $default != null:
return $default(_that.code,_that.name,_that.entitlements);case _:
  return null;

}
}

}

/// @nodoc


class _UserPlan implements UserPlan {
  const _UserPlan({required this.code, required this.name, this.entitlements = Entitlements.none});
  

@override final  String code;
@override final  String name;
@override@JsonKey() final  Entitlements entitlements;

/// Create a copy of UserPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserPlanCopyWith<_UserPlan> get copyWith => __$UserPlanCopyWithImpl<_UserPlan>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserPlan&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.entitlements, entitlements) || other.entitlements == entitlements));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,name,entitlements);
}

@override
String toString() {
    return 'UserPlan(code: $code, name: $name, entitlements: $entitlements)';
}


}

/// @nodoc
abstract mixin class _$UserPlanCopyWith<$Res> implements $UserPlanCopyWith<$Res> {
  factory _$UserPlanCopyWith(_UserPlan value, $Res Function(_UserPlan) _then) = __$UserPlanCopyWithImpl;
@override @useResult
$Res call({
 String code, String name, Entitlements entitlements
});


@override $EntitlementsCopyWith<$Res> get entitlements;

}
/// @nodoc
class __$UserPlanCopyWithImpl<$Res>
    implements _$UserPlanCopyWith<$Res> {
  __$UserPlanCopyWithImpl(this._self, this._then);

  final _UserPlan _self;
  final $Res Function(_UserPlan) _then;

/// Create a copy of UserPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? name = null,Object? entitlements = null,}) {
  return _then(_UserPlan(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,entitlements: null == entitlements ? _self.entitlements : entitlements // ignore: cast_nullable_to_non_nullable
as Entitlements,
  ));
}

/// Create a copy of UserPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EntitlementsCopyWith<$Res> get entitlements {
  
  return $EntitlementsCopyWith<$Res>(_self.entitlements, (value) {
    return _then(_self.copyWith(entitlements: value));
  });
}
}

// dart format on
