// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurrence_configuration_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecurrenceConfigurationModel {

@JsonKey(name: 'end_times') int get recurrenceFrequency; int? get weeklyDays; int get type;@JsonKey(name: 'repeat_interval') int get recurrenceInterval;
/// Create a copy of RecurrenceConfigurationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurrenceConfigurationModelCopyWith<RecurrenceConfigurationModel> get copyWith => _$RecurrenceConfigurationModelCopyWithImpl<RecurrenceConfigurationModel>(this as RecurrenceConfigurationModel, _$identity);

  /// Serializes this RecurrenceConfigurationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurrenceConfigurationModel&&(identical(other.recurrenceFrequency, recurrenceFrequency) || other.recurrenceFrequency == recurrenceFrequency)&&(identical(other.weeklyDays, weeklyDays) || other.weeklyDays == weeklyDays)&&(identical(other.type, type) || other.type == type)&&(identical(other.recurrenceInterval, recurrenceInterval) || other.recurrenceInterval == recurrenceInterval));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recurrenceFrequency,weeklyDays,type,recurrenceInterval);

@override
String toString() {
  return 'RecurrenceConfigurationModel(recurrenceFrequency: $recurrenceFrequency, weeklyDays: $weeklyDays, type: $type, recurrenceInterval: $recurrenceInterval)';
}


}

/// @nodoc
abstract mixin class $RecurrenceConfigurationModelCopyWith<$Res>  {
  factory $RecurrenceConfigurationModelCopyWith(RecurrenceConfigurationModel value, $Res Function(RecurrenceConfigurationModel) _then) = _$RecurrenceConfigurationModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'end_times') int recurrenceFrequency, int? weeklyDays, int type,@JsonKey(name: 'repeat_interval') int recurrenceInterval
});




}
/// @nodoc
class _$RecurrenceConfigurationModelCopyWithImpl<$Res>
    implements $RecurrenceConfigurationModelCopyWith<$Res> {
  _$RecurrenceConfigurationModelCopyWithImpl(this._self, this._then);

  final RecurrenceConfigurationModel _self;
  final $Res Function(RecurrenceConfigurationModel) _then;

/// Create a copy of RecurrenceConfigurationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recurrenceFrequency = null,Object? weeklyDays = freezed,Object? type = null,Object? recurrenceInterval = null,}) {
  return _then(_self.copyWith(
recurrenceFrequency: null == recurrenceFrequency ? _self.recurrenceFrequency : recurrenceFrequency // ignore: cast_nullable_to_non_nullable
as int,weeklyDays: freezed == weeklyDays ? _self.weeklyDays : weeklyDays // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,recurrenceInterval: null == recurrenceInterval ? _self.recurrenceInterval : recurrenceInterval // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurrenceConfigurationModel].
extension RecurrenceConfigurationModelPatterns on RecurrenceConfigurationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurrenceConfigurationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurrenceConfigurationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurrenceConfigurationModel value)  $default,){
final _that = this;
switch (_that) {
case _RecurrenceConfigurationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurrenceConfigurationModel value)?  $default,){
final _that = this;
switch (_that) {
case _RecurrenceConfigurationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'end_times')  int recurrenceFrequency,  int? weeklyDays,  int type, @JsonKey(name: 'repeat_interval')  int recurrenceInterval)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurrenceConfigurationModel() when $default != null:
return $default(_that.recurrenceFrequency,_that.weeklyDays,_that.type,_that.recurrenceInterval);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'end_times')  int recurrenceFrequency,  int? weeklyDays,  int type, @JsonKey(name: 'repeat_interval')  int recurrenceInterval)  $default,) {final _that = this;
switch (_that) {
case _RecurrenceConfigurationModel():
return $default(_that.recurrenceFrequency,_that.weeklyDays,_that.type,_that.recurrenceInterval);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'end_times')  int recurrenceFrequency,  int? weeklyDays,  int type, @JsonKey(name: 'repeat_interval')  int recurrenceInterval)?  $default,) {final _that = this;
switch (_that) {
case _RecurrenceConfigurationModel() when $default != null:
return $default(_that.recurrenceFrequency,_that.weeklyDays,_that.type,_that.recurrenceInterval);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _RecurrenceConfigurationModel implements RecurrenceConfigurationModel {
  const _RecurrenceConfigurationModel({@JsonKey(name: 'end_times') required this.recurrenceFrequency, this.weeklyDays, required this.type, @JsonKey(name: 'repeat_interval') required this.recurrenceInterval});
  factory _RecurrenceConfigurationModel.fromJson(Map<String, dynamic> json) => _$RecurrenceConfigurationModelFromJson(json);

@override@JsonKey(name: 'end_times') final  int recurrenceFrequency;
@override final  int? weeklyDays;
@override final  int type;
@override@JsonKey(name: 'repeat_interval') final  int recurrenceInterval;

/// Create a copy of RecurrenceConfigurationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurrenceConfigurationModelCopyWith<_RecurrenceConfigurationModel> get copyWith => __$RecurrenceConfigurationModelCopyWithImpl<_RecurrenceConfigurationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecurrenceConfigurationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurrenceConfigurationModel&&(identical(other.recurrenceFrequency, recurrenceFrequency) || other.recurrenceFrequency == recurrenceFrequency)&&(identical(other.weeklyDays, weeklyDays) || other.weeklyDays == weeklyDays)&&(identical(other.type, type) || other.type == type)&&(identical(other.recurrenceInterval, recurrenceInterval) || other.recurrenceInterval == recurrenceInterval));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recurrenceFrequency,weeklyDays,type,recurrenceInterval);

@override
String toString() {
  return 'RecurrenceConfigurationModel(recurrenceFrequency: $recurrenceFrequency, weeklyDays: $weeklyDays, type: $type, recurrenceInterval: $recurrenceInterval)';
}


}

/// @nodoc
abstract mixin class _$RecurrenceConfigurationModelCopyWith<$Res> implements $RecurrenceConfigurationModelCopyWith<$Res> {
  factory _$RecurrenceConfigurationModelCopyWith(_RecurrenceConfigurationModel value, $Res Function(_RecurrenceConfigurationModel) _then) = __$RecurrenceConfigurationModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'end_times') int recurrenceFrequency, int? weeklyDays, int type,@JsonKey(name: 'repeat_interval') int recurrenceInterval
});




}
/// @nodoc
class __$RecurrenceConfigurationModelCopyWithImpl<$Res>
    implements _$RecurrenceConfigurationModelCopyWith<$Res> {
  __$RecurrenceConfigurationModelCopyWithImpl(this._self, this._then);

  final _RecurrenceConfigurationModel _self;
  final $Res Function(_RecurrenceConfigurationModel) _then;

/// Create a copy of RecurrenceConfigurationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recurrenceFrequency = null,Object? weeklyDays = freezed,Object? type = null,Object? recurrenceInterval = null,}) {
  return _then(_RecurrenceConfigurationModel(
recurrenceFrequency: null == recurrenceFrequency ? _self.recurrenceFrequency : recurrenceFrequency // ignore: cast_nullable_to_non_nullable
as int,weeklyDays: freezed == weeklyDays ? _self.weeklyDays : weeklyDays // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,recurrenceInterval: null == recurrenceInterval ? _self.recurrenceInterval : recurrenceInterval // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
