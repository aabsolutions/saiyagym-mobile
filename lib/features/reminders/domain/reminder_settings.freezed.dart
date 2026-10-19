// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReminderSettings {

 bool get trainingEnabled; Set<int> get trainingDays; int get trainingHour; int get trainingMinute; bool get weighInEnabled; int get weighInDay; int get weighInHour; int get weighInMinute;/// The weekly weigh-in reminder was suggested once (after a weigh-in).
 bool get weighInOffered;
/// Create a copy of ReminderSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderSettingsCopyWith<ReminderSettings> get copyWith => _$ReminderSettingsCopyWithImpl<ReminderSettings>(this as ReminderSettings, _$identity);

  /// Serializes this ReminderSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReminderSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderSettings&&(identical(other.trainingEnabled, _this.trainingEnabled) || other.trainingEnabled == _this.trainingEnabled)&&const DeepCollectionEquality().equals(other.trainingDays, _this.trainingDays)&&(identical(other.trainingHour, _this.trainingHour) || other.trainingHour == _this.trainingHour)&&(identical(other.trainingMinute, _this.trainingMinute) || other.trainingMinute == _this.trainingMinute)&&(identical(other.weighInEnabled, _this.weighInEnabled) || other.weighInEnabled == _this.weighInEnabled)&&(identical(other.weighInDay, _this.weighInDay) || other.weighInDay == _this.weighInDay)&&(identical(other.weighInHour, _this.weighInHour) || other.weighInHour == _this.weighInHour)&&(identical(other.weighInMinute, _this.weighInMinute) || other.weighInMinute == _this.weighInMinute)&&(identical(other.weighInOffered, _this.weighInOffered) || other.weighInOffered == _this.weighInOffered));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReminderSettings;
  return Object.hash(runtimeType,_this.trainingEnabled,const DeepCollectionEquality().hash(_this.trainingDays),_this.trainingHour,_this.trainingMinute,_this.weighInEnabled,_this.weighInDay,_this.weighInHour,_this.weighInMinute,_this.weighInOffered);
}

@override
String toString() {
  final _this = this as ReminderSettings;
  return 'ReminderSettings(trainingEnabled: ${_this.trainingEnabled}, trainingDays: ${_this.trainingDays}, trainingHour: ${_this.trainingHour}, trainingMinute: ${_this.trainingMinute}, weighInEnabled: ${_this.weighInEnabled}, weighInDay: ${_this.weighInDay}, weighInHour: ${_this.weighInHour}, weighInMinute: ${_this.weighInMinute}, weighInOffered: ${_this.weighInOffered})';
}


}

/// @nodoc
abstract mixin class $ReminderSettingsCopyWith<$Res>  {
  factory $ReminderSettingsCopyWith(ReminderSettings value, $Res Function(ReminderSettings) _then) = _$ReminderSettingsCopyWithImpl;
@useResult
$Res call({
 bool trainingEnabled, Set<int> trainingDays, int trainingHour, int trainingMinute, bool weighInEnabled, int weighInDay, int weighInHour, int weighInMinute, bool weighInOffered
});




}
/// @nodoc
class _$ReminderSettingsCopyWithImpl<$Res>
    implements $ReminderSettingsCopyWith<$Res> {
  _$ReminderSettingsCopyWithImpl(this._self, this._then);

  final ReminderSettings _self;
  final $Res Function(ReminderSettings) _then;

/// Create a copy of ReminderSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trainingEnabled = null,Object? trainingDays = null,Object? trainingHour = null,Object? trainingMinute = null,Object? weighInEnabled = null,Object? weighInDay = null,Object? weighInHour = null,Object? weighInMinute = null,Object? weighInOffered = null,}) {
  return _then(ReminderSettings(
trainingEnabled: null == trainingEnabled ? _self.trainingEnabled : trainingEnabled // ignore: cast_nullable_to_non_nullable
as bool,trainingDays: null == trainingDays ? _self.trainingDays : trainingDays // ignore: cast_nullable_to_non_nullable
as Set<int>,trainingHour: null == trainingHour ? _self.trainingHour : trainingHour // ignore: cast_nullable_to_non_nullable
as int,trainingMinute: null == trainingMinute ? _self.trainingMinute : trainingMinute // ignore: cast_nullable_to_non_nullable
as int,weighInEnabled: null == weighInEnabled ? _self.weighInEnabled : weighInEnabled // ignore: cast_nullable_to_non_nullable
as bool,weighInDay: null == weighInDay ? _self.weighInDay : weighInDay // ignore: cast_nullable_to_non_nullable
as int,weighInHour: null == weighInHour ? _self.weighInHour : weighInHour // ignore: cast_nullable_to_non_nullable
as int,weighInMinute: null == weighInMinute ? _self.weighInMinute : weighInMinute // ignore: cast_nullable_to_non_nullable
as int,weighInOffered: null == weighInOffered ? _self.weighInOffered : weighInOffered // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReminderSettings].
extension ReminderSettingsPatterns on ReminderSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderSettings value)  $default,){
final _that = this;
switch (_that) {
case _ReminderSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderSettings value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool trainingEnabled,  Set<int> trainingDays,  int trainingHour,  int trainingMinute,  bool weighInEnabled,  int weighInDay,  int weighInHour,  int weighInMinute,  bool weighInOffered)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReminderSettings() when $default != null:
return $default(_that.trainingEnabled,_that.trainingDays,_that.trainingHour,_that.trainingMinute,_that.weighInEnabled,_that.weighInDay,_that.weighInHour,_that.weighInMinute,_that.weighInOffered);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool trainingEnabled,  Set<int> trainingDays,  int trainingHour,  int trainingMinute,  bool weighInEnabled,  int weighInDay,  int weighInHour,  int weighInMinute,  bool weighInOffered)  $default,) {final _that = this;
switch (_that) {
case _ReminderSettings():
return $default(_that.trainingEnabled,_that.trainingDays,_that.trainingHour,_that.trainingMinute,_that.weighInEnabled,_that.weighInDay,_that.weighInHour,_that.weighInMinute,_that.weighInOffered);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool trainingEnabled,  Set<int> trainingDays,  int trainingHour,  int trainingMinute,  bool weighInEnabled,  int weighInDay,  int weighInHour,  int weighInMinute,  bool weighInOffered)?  $default,) {final _that = this;
switch (_that) {
case _ReminderSettings() when $default != null:
return $default(_that.trainingEnabled,_that.trainingDays,_that.trainingHour,_that.trainingMinute,_that.weighInEnabled,_that.weighInDay,_that.weighInHour,_that.weighInMinute,_that.weighInOffered);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReminderSettings implements ReminderSettings {
  const _ReminderSettings({this.trainingEnabled = false,  Set<int> trainingDays = const {1, 3, 5}, this.trainingHour = 18, this.trainingMinute = 0, this.weighInEnabled = false, this.weighInDay = 1, this.weighInHour = 8, this.weighInMinute = 0, this.weighInOffered = false}): _trainingDays = trainingDays;
  factory _ReminderSettings.fromJson(Map<String, dynamic> json) => _$ReminderSettingsFromJson(json);

@override@JsonKey() final  bool trainingEnabled;
 final  Set<int> _trainingDays;
@override@JsonKey() Set<int> get trainingDays {
  if (_trainingDays is EqualUnmodifiableSetView) return _trainingDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_trainingDays);
}

@override@JsonKey() final  int trainingHour;
@override@JsonKey() final  int trainingMinute;
@override@JsonKey() final  bool weighInEnabled;
@override@JsonKey() final  int weighInDay;
@override@JsonKey() final  int weighInHour;
@override@JsonKey() final  int weighInMinute;
/// The weekly weigh-in reminder was suggested once (after a weigh-in).
@override@JsonKey() final  bool weighInOffered;

/// Create a copy of ReminderSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderSettingsCopyWith<_ReminderSettings> get copyWith => __$ReminderSettingsCopyWithImpl<_ReminderSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReminderSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderSettings&&(identical(other.trainingEnabled, trainingEnabled) || other.trainingEnabled == trainingEnabled)&&const DeepCollectionEquality().equals(other.trainingDays, _trainingDays)&&(identical(other.trainingHour, trainingHour) || other.trainingHour == trainingHour)&&(identical(other.trainingMinute, trainingMinute) || other.trainingMinute == trainingMinute)&&(identical(other.weighInEnabled, weighInEnabled) || other.weighInEnabled == weighInEnabled)&&(identical(other.weighInDay, weighInDay) || other.weighInDay == weighInDay)&&(identical(other.weighInHour, weighInHour) || other.weighInHour == weighInHour)&&(identical(other.weighInMinute, weighInMinute) || other.weighInMinute == weighInMinute)&&(identical(other.weighInOffered, weighInOffered) || other.weighInOffered == weighInOffered));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,trainingEnabled,const DeepCollectionEquality().hash(_trainingDays),trainingHour,trainingMinute,weighInEnabled,weighInDay,weighInHour,weighInMinute,weighInOffered);
}

@override
String toString() {
    return 'ReminderSettings(trainingEnabled: $trainingEnabled, trainingDays: $trainingDays, trainingHour: $trainingHour, trainingMinute: $trainingMinute, weighInEnabled: $weighInEnabled, weighInDay: $weighInDay, weighInHour: $weighInHour, weighInMinute: $weighInMinute, weighInOffered: $weighInOffered)';
}


}

/// @nodoc
abstract mixin class _$ReminderSettingsCopyWith<$Res> implements $ReminderSettingsCopyWith<$Res> {
  factory _$ReminderSettingsCopyWith(_ReminderSettings value, $Res Function(_ReminderSettings) _then) = __$ReminderSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool trainingEnabled, Set<int> trainingDays, int trainingHour, int trainingMinute, bool weighInEnabled, int weighInDay, int weighInHour, int weighInMinute, bool weighInOffered
});




}
/// @nodoc
class __$ReminderSettingsCopyWithImpl<$Res>
    implements _$ReminderSettingsCopyWith<$Res> {
  __$ReminderSettingsCopyWithImpl(this._self, this._then);

  final _ReminderSettings _self;
  final $Res Function(_ReminderSettings) _then;

/// Create a copy of ReminderSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trainingEnabled = null,Object? trainingDays = null,Object? trainingHour = null,Object? trainingMinute = null,Object? weighInEnabled = null,Object? weighInDay = null,Object? weighInHour = null,Object? weighInMinute = null,Object? weighInOffered = null,}) {
  return _then(_ReminderSettings(
trainingEnabled: null == trainingEnabled ? _self.trainingEnabled : trainingEnabled // ignore: cast_nullable_to_non_nullable
as bool,trainingDays: null == trainingDays ? _self._trainingDays : trainingDays // ignore: cast_nullable_to_non_nullable
as Set<int>,trainingHour: null == trainingHour ? _self.trainingHour : trainingHour // ignore: cast_nullable_to_non_nullable
as int,trainingMinute: null == trainingMinute ? _self.trainingMinute : trainingMinute // ignore: cast_nullable_to_non_nullable
as int,weighInEnabled: null == weighInEnabled ? _self.weighInEnabled : weighInEnabled // ignore: cast_nullable_to_non_nullable
as bool,weighInDay: null == weighInDay ? _self.weighInDay : weighInDay // ignore: cast_nullable_to_non_nullable
as int,weighInHour: null == weighInHour ? _self.weighInHour : weighInHour // ignore: cast_nullable_to_non_nullable
as int,weighInMinute: null == weighInMinute ? _self.weighInMinute : weighInMinute // ignore: cast_nullable_to_non_nullable
as int,weighInOffered: null == weighInOffered ? _self.weighInOffered : weighInOffered // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
