// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'zoom_meeting_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ZoomMeetingModel {

 String? get topic;@JsonKey(name: 'agenda') String? get description; int? get duration; String? get password;@RecurrenceConfigurationConverter()@JsonKey(name: 'recurrence') RecurrenceConfigurationModel? get recurrenceConfiguration;@JsonKey(name: 'start_time') DateTime get startTime;@JsonKey(defaultValue: 2) int get type;@JsonKey(name: 'default_password', defaultValue: false) bool get defaultPassword;
/// Create a copy of ZoomMeetingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ZoomMeetingModelCopyWith<ZoomMeetingModel> get copyWith => _$ZoomMeetingModelCopyWithImpl<ZoomMeetingModel>(this as ZoomMeetingModel, _$identity);

  /// Serializes this ZoomMeetingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ZoomMeetingModel&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.description, description) || other.description == description)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.password, password) || other.password == password)&&(identical(other.recurrenceConfiguration, recurrenceConfiguration) || other.recurrenceConfiguration == recurrenceConfiguration)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.type, type) || other.type == type)&&(identical(other.defaultPassword, defaultPassword) || other.defaultPassword == defaultPassword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,topic,description,duration,password,recurrenceConfiguration,startTime,type,defaultPassword);

@override
String toString() {
  return 'ZoomMeetingModel(topic: $topic, description: $description, duration: $duration, password: $password, recurrenceConfiguration: $recurrenceConfiguration, startTime: $startTime, type: $type, defaultPassword: $defaultPassword)';
}


}

/// @nodoc
abstract mixin class $ZoomMeetingModelCopyWith<$Res>  {
  factory $ZoomMeetingModelCopyWith(ZoomMeetingModel value, $Res Function(ZoomMeetingModel) _then) = _$ZoomMeetingModelCopyWithImpl;
@useResult
$Res call({
 String? topic,@JsonKey(name: 'agenda') String? description, int? duration, String? password,@RecurrenceConfigurationConverter()@JsonKey(name: 'recurrence') RecurrenceConfigurationModel? recurrenceConfiguration,@JsonKey(name: 'start_time') DateTime startTime,@JsonKey(defaultValue: 2) int type,@JsonKey(name: 'default_password', defaultValue: false) bool defaultPassword
});


$RecurrenceConfigurationModelCopyWith<$Res>? get recurrenceConfiguration;

}
/// @nodoc
class _$ZoomMeetingModelCopyWithImpl<$Res>
    implements $ZoomMeetingModelCopyWith<$Res> {
  _$ZoomMeetingModelCopyWithImpl(this._self, this._then);

  final ZoomMeetingModel _self;
  final $Res Function(ZoomMeetingModel) _then;

/// Create a copy of ZoomMeetingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? topic = freezed,Object? description = freezed,Object? duration = freezed,Object? password = freezed,Object? recurrenceConfiguration = freezed,Object? startTime = null,Object? type = null,Object? defaultPassword = null,}) {
  return _then(_self.copyWith(
topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,recurrenceConfiguration: freezed == recurrenceConfiguration ? _self.recurrenceConfiguration : recurrenceConfiguration // ignore: cast_nullable_to_non_nullable
as RecurrenceConfigurationModel?,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,defaultPassword: null == defaultPassword ? _self.defaultPassword : defaultPassword // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ZoomMeetingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecurrenceConfigurationModelCopyWith<$Res>? get recurrenceConfiguration {
    if (_self.recurrenceConfiguration == null) {
    return null;
  }

  return $RecurrenceConfigurationModelCopyWith<$Res>(_self.recurrenceConfiguration!, (value) {
    return _then(_self.copyWith(recurrenceConfiguration: value));
  });
}
}


/// Adds pattern-matching-related methods to [ZoomMeetingModel].
extension ZoomMeetingModelPatterns on ZoomMeetingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ZoomMeetingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ZoomMeetingModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ZoomMeetingModel value)  $default,){
final _that = this;
switch (_that) {
case _ZoomMeetingModel():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ZoomMeetingModel value)?  $default,){
final _that = this;
switch (_that) {
case _ZoomMeetingModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? topic, @JsonKey(name: 'agenda')  String? description,  int? duration,  String? password, @RecurrenceConfigurationConverter()@JsonKey(name: 'recurrence')  RecurrenceConfigurationModel? recurrenceConfiguration, @JsonKey(name: 'start_time')  DateTime startTime, @JsonKey(defaultValue: 2)  int type, @JsonKey(name: 'default_password', defaultValue: false)  bool defaultPassword)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ZoomMeetingModel() when $default != null:
return $default(_that.topic,_that.description,_that.duration,_that.password,_that.recurrenceConfiguration,_that.startTime,_that.type,_that.defaultPassword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? topic, @JsonKey(name: 'agenda')  String? description,  int? duration,  String? password, @RecurrenceConfigurationConverter()@JsonKey(name: 'recurrence')  RecurrenceConfigurationModel? recurrenceConfiguration, @JsonKey(name: 'start_time')  DateTime startTime, @JsonKey(defaultValue: 2)  int type, @JsonKey(name: 'default_password', defaultValue: false)  bool defaultPassword)  $default,) {final _that = this;
switch (_that) {
case _ZoomMeetingModel():
return $default(_that.topic,_that.description,_that.duration,_that.password,_that.recurrenceConfiguration,_that.startTime,_that.type,_that.defaultPassword);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? topic, @JsonKey(name: 'agenda')  String? description,  int? duration,  String? password, @RecurrenceConfigurationConverter()@JsonKey(name: 'recurrence')  RecurrenceConfigurationModel? recurrenceConfiguration, @JsonKey(name: 'start_time')  DateTime startTime, @JsonKey(defaultValue: 2)  int type, @JsonKey(name: 'default_password', defaultValue: false)  bool defaultPassword)?  $default,) {final _that = this;
switch (_that) {
case _ZoomMeetingModel() when $default != null:
return $default(_that.topic,_that.description,_that.duration,_that.password,_that.recurrenceConfiguration,_that.startTime,_that.type,_that.defaultPassword);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ZoomMeetingModel extends ZoomMeetingModel {
   _ZoomMeetingModel({this.topic, @JsonKey(name: 'agenda') this.description, this.duration, this.password, @RecurrenceConfigurationConverter()@JsonKey(name: 'recurrence') this.recurrenceConfiguration, @JsonKey(name: 'start_time') required this.startTime, @JsonKey(defaultValue: 2) required this.type, @JsonKey(name: 'default_password', defaultValue: false) required this.defaultPassword}): super._();
  factory _ZoomMeetingModel.fromJson(Map<String, dynamic> json) => _$ZoomMeetingModelFromJson(json);

@override final  String? topic;
@override@JsonKey(name: 'agenda') final  String? description;
@override final  int? duration;
@override final  String? password;
@override@RecurrenceConfigurationConverter()@JsonKey(name: 'recurrence') final  RecurrenceConfigurationModel? recurrenceConfiguration;
@override@JsonKey(name: 'start_time') final  DateTime startTime;
@override@JsonKey(defaultValue: 2) final  int type;
@override@JsonKey(name: 'default_password', defaultValue: false) final  bool defaultPassword;

/// Create a copy of ZoomMeetingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ZoomMeetingModelCopyWith<_ZoomMeetingModel> get copyWith => __$ZoomMeetingModelCopyWithImpl<_ZoomMeetingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ZoomMeetingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ZoomMeetingModel&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.description, description) || other.description == description)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.password, password) || other.password == password)&&(identical(other.recurrenceConfiguration, recurrenceConfiguration) || other.recurrenceConfiguration == recurrenceConfiguration)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.type, type) || other.type == type)&&(identical(other.defaultPassword, defaultPassword) || other.defaultPassword == defaultPassword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,topic,description,duration,password,recurrenceConfiguration,startTime,type,defaultPassword);

@override
String toString() {
  return 'ZoomMeetingModel(topic: $topic, description: $description, duration: $duration, password: $password, recurrenceConfiguration: $recurrenceConfiguration, startTime: $startTime, type: $type, defaultPassword: $defaultPassword)';
}


}

/// @nodoc
abstract mixin class _$ZoomMeetingModelCopyWith<$Res> implements $ZoomMeetingModelCopyWith<$Res> {
  factory _$ZoomMeetingModelCopyWith(_ZoomMeetingModel value, $Res Function(_ZoomMeetingModel) _then) = __$ZoomMeetingModelCopyWithImpl;
@override @useResult
$Res call({
 String? topic,@JsonKey(name: 'agenda') String? description, int? duration, String? password,@RecurrenceConfigurationConverter()@JsonKey(name: 'recurrence') RecurrenceConfigurationModel? recurrenceConfiguration,@JsonKey(name: 'start_time') DateTime startTime,@JsonKey(defaultValue: 2) int type,@JsonKey(name: 'default_password', defaultValue: false) bool defaultPassword
});


@override $RecurrenceConfigurationModelCopyWith<$Res>? get recurrenceConfiguration;

}
/// @nodoc
class __$ZoomMeetingModelCopyWithImpl<$Res>
    implements _$ZoomMeetingModelCopyWith<$Res> {
  __$ZoomMeetingModelCopyWithImpl(this._self, this._then);

  final _ZoomMeetingModel _self;
  final $Res Function(_ZoomMeetingModel) _then;

/// Create a copy of ZoomMeetingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? topic = freezed,Object? description = freezed,Object? duration = freezed,Object? password = freezed,Object? recurrenceConfiguration = freezed,Object? startTime = null,Object? type = null,Object? defaultPassword = null,}) {
  return _then(_ZoomMeetingModel(
topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,recurrenceConfiguration: freezed == recurrenceConfiguration ? _self.recurrenceConfiguration : recurrenceConfiguration // ignore: cast_nullable_to_non_nullable
as RecurrenceConfigurationModel?,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,defaultPassword: null == defaultPassword ? _self.defaultPassword : defaultPassword // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ZoomMeetingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecurrenceConfigurationModelCopyWith<$Res>? get recurrenceConfiguration {
    if (_self.recurrenceConfiguration == null) {
    return null;
  }

  return $RecurrenceConfigurationModelCopyWith<$Res>(_self.recurrenceConfiguration!, (value) {
    return _then(_self.copyWith(recurrenceConfiguration: value));
  });
}
}

// dart format on
