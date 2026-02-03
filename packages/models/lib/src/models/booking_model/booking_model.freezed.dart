// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookingModel {

 String get title;@CustomDateTimeRangeConverter() RecurrenceState get recurrenceState; String get host; DateTime get createdAt;@CustomDateTimeRangeConverter() CustomDateTimeRange get timeRange; String get userId; String get id;@LocationDataConverter() LocationData get location; String get description; String? get password;@RecurrenceConfigurationConverter() RecurrenceConfigurationModel? get recurrenceModel; String? get occurrenceId; String? get groupId;
/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingModelCopyWith<BookingModel> get copyWith => _$BookingModelCopyWithImpl<BookingModel>(this as BookingModel, _$identity);

  /// Serializes this BookingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingModel&&(identical(other.title, title) || other.title == title)&&(identical(other.recurrenceState, recurrenceState) || other.recurrenceState == recurrenceState)&&(identical(other.host, host) || other.host == host)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.timeRange, timeRange) || other.timeRange == timeRange)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.id, id) || other.id == id)&&(identical(other.location, location) || other.location == location)&&(identical(other.description, description) || other.description == description)&&(identical(other.password, password) || other.password == password)&&(identical(other.recurrenceModel, recurrenceModel) || other.recurrenceModel == recurrenceModel)&&(identical(other.occurrenceId, occurrenceId) || other.occurrenceId == occurrenceId)&&(identical(other.groupId, groupId) || other.groupId == groupId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,recurrenceState,host,createdAt,timeRange,userId,id,location,description,password,recurrenceModel,occurrenceId,groupId);

@override
String toString() {
  return 'BookingModel(title: $title, recurrenceState: $recurrenceState, host: $host, createdAt: $createdAt, timeRange: $timeRange, userId: $userId, id: $id, location: $location, description: $description, password: $password, recurrenceModel: $recurrenceModel, occurrenceId: $occurrenceId, groupId: $groupId)';
}


}

/// @nodoc
abstract mixin class $BookingModelCopyWith<$Res>  {
  factory $BookingModelCopyWith(BookingModel value, $Res Function(BookingModel) _then) = _$BookingModelCopyWithImpl;
@useResult
$Res call({
 String title,@CustomDateTimeRangeConverter() RecurrenceState recurrenceState, String host, DateTime createdAt,@CustomDateTimeRangeConverter() CustomDateTimeRange timeRange, String userId, String id,@LocationDataConverter() LocationData location, String description, String? password,@RecurrenceConfigurationConverter() RecurrenceConfigurationModel? recurrenceModel, String? occurrenceId, String? groupId
});


$RecurrenceConfigurationModelCopyWith<$Res>? get recurrenceModel;

}
/// @nodoc
class _$BookingModelCopyWithImpl<$Res>
    implements $BookingModelCopyWith<$Res> {
  _$BookingModelCopyWithImpl(this._self, this._then);

  final BookingModel _self;
  final $Res Function(BookingModel) _then;

/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? recurrenceState = null,Object? host = null,Object? createdAt = null,Object? timeRange = null,Object? userId = null,Object? id = null,Object? location = null,Object? description = null,Object? password = freezed,Object? recurrenceModel = freezed,Object? occurrenceId = freezed,Object? groupId = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,recurrenceState: null == recurrenceState ? _self.recurrenceState : recurrenceState // ignore: cast_nullable_to_non_nullable
as RecurrenceState,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,timeRange: null == timeRange ? _self.timeRange : timeRange // ignore: cast_nullable_to_non_nullable
as CustomDateTimeRange,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LocationData,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,recurrenceModel: freezed == recurrenceModel ? _self.recurrenceModel : recurrenceModel // ignore: cast_nullable_to_non_nullable
as RecurrenceConfigurationModel?,occurrenceId: freezed == occurrenceId ? _self.occurrenceId : occurrenceId // ignore: cast_nullable_to_non_nullable
as String?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecurrenceConfigurationModelCopyWith<$Res>? get recurrenceModel {
    if (_self.recurrenceModel == null) {
    return null;
  }

  return $RecurrenceConfigurationModelCopyWith<$Res>(_self.recurrenceModel!, (value) {
    return _then(_self.copyWith(recurrenceModel: value));
  });
}
}


/// Adds pattern-matching-related methods to [BookingModel].
extension BookingModelPatterns on BookingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingModel value)  $default,){
final _that = this;
switch (_that) {
case _BookingModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingModel value)?  $default,){
final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title, @CustomDateTimeRangeConverter()  RecurrenceState recurrenceState,  String host,  DateTime createdAt, @CustomDateTimeRangeConverter()  CustomDateTimeRange timeRange,  String userId,  String id, @LocationDataConverter()  LocationData location,  String description,  String? password, @RecurrenceConfigurationConverter()  RecurrenceConfigurationModel? recurrenceModel,  String? occurrenceId,  String? groupId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
return $default(_that.title,_that.recurrenceState,_that.host,_that.createdAt,_that.timeRange,_that.userId,_that.id,_that.location,_that.description,_that.password,_that.recurrenceModel,_that.occurrenceId,_that.groupId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title, @CustomDateTimeRangeConverter()  RecurrenceState recurrenceState,  String host,  DateTime createdAt, @CustomDateTimeRangeConverter()  CustomDateTimeRange timeRange,  String userId,  String id, @LocationDataConverter()  LocationData location,  String description,  String? password, @RecurrenceConfigurationConverter()  RecurrenceConfigurationModel? recurrenceModel,  String? occurrenceId,  String? groupId)  $default,) {final _that = this;
switch (_that) {
case _BookingModel():
return $default(_that.title,_that.recurrenceState,_that.host,_that.createdAt,_that.timeRange,_that.userId,_that.id,_that.location,_that.description,_that.password,_that.recurrenceModel,_that.occurrenceId,_that.groupId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title, @CustomDateTimeRangeConverter()  RecurrenceState recurrenceState,  String host,  DateTime createdAt, @CustomDateTimeRangeConverter()  CustomDateTimeRange timeRange,  String userId,  String id, @LocationDataConverter()  LocationData location,  String description,  String? password, @RecurrenceConfigurationConverter()  RecurrenceConfigurationModel? recurrenceModel,  String? occurrenceId,  String? groupId)?  $default,) {final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
return $default(_that.title,_that.recurrenceState,_that.host,_that.createdAt,_that.timeRange,_that.userId,_that.id,_that.location,_that.description,_that.password,_that.recurrenceModel,_that.occurrenceId,_that.groupId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingModel extends BookingModel {
  const _BookingModel({required this.title, @CustomDateTimeRangeConverter() required this.recurrenceState, required this.host, required this.createdAt, @CustomDateTimeRangeConverter() required this.timeRange, required this.userId, required this.id, @LocationDataConverter() required this.location, required this.description, this.password, @RecurrenceConfigurationConverter() this.recurrenceModel, this.occurrenceId, this.groupId}): super._();
  factory _BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);

@override final  String title;
@override@CustomDateTimeRangeConverter() final  RecurrenceState recurrenceState;
@override final  String host;
@override final  DateTime createdAt;
@override@CustomDateTimeRangeConverter() final  CustomDateTimeRange timeRange;
@override final  String userId;
@override final  String id;
@override@LocationDataConverter() final  LocationData location;
@override final  String description;
@override final  String? password;
@override@RecurrenceConfigurationConverter() final  RecurrenceConfigurationModel? recurrenceModel;
@override final  String? occurrenceId;
@override final  String? groupId;

/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingModelCopyWith<_BookingModel> get copyWith => __$BookingModelCopyWithImpl<_BookingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingModel&&(identical(other.title, title) || other.title == title)&&(identical(other.recurrenceState, recurrenceState) || other.recurrenceState == recurrenceState)&&(identical(other.host, host) || other.host == host)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.timeRange, timeRange) || other.timeRange == timeRange)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.id, id) || other.id == id)&&(identical(other.location, location) || other.location == location)&&(identical(other.description, description) || other.description == description)&&(identical(other.password, password) || other.password == password)&&(identical(other.recurrenceModel, recurrenceModel) || other.recurrenceModel == recurrenceModel)&&(identical(other.occurrenceId, occurrenceId) || other.occurrenceId == occurrenceId)&&(identical(other.groupId, groupId) || other.groupId == groupId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,recurrenceState,host,createdAt,timeRange,userId,id,location,description,password,recurrenceModel,occurrenceId,groupId);

@override
String toString() {
  return 'BookingModel(title: $title, recurrenceState: $recurrenceState, host: $host, createdAt: $createdAt, timeRange: $timeRange, userId: $userId, id: $id, location: $location, description: $description, password: $password, recurrenceModel: $recurrenceModel, occurrenceId: $occurrenceId, groupId: $groupId)';
}


}

/// @nodoc
abstract mixin class _$BookingModelCopyWith<$Res> implements $BookingModelCopyWith<$Res> {
  factory _$BookingModelCopyWith(_BookingModel value, $Res Function(_BookingModel) _then) = __$BookingModelCopyWithImpl;
@override @useResult
$Res call({
 String title,@CustomDateTimeRangeConverter() RecurrenceState recurrenceState, String host, DateTime createdAt,@CustomDateTimeRangeConverter() CustomDateTimeRange timeRange, String userId, String id,@LocationDataConverter() LocationData location, String description, String? password,@RecurrenceConfigurationConverter() RecurrenceConfigurationModel? recurrenceModel, String? occurrenceId, String? groupId
});


@override $RecurrenceConfigurationModelCopyWith<$Res>? get recurrenceModel;

}
/// @nodoc
class __$BookingModelCopyWithImpl<$Res>
    implements _$BookingModelCopyWith<$Res> {
  __$BookingModelCopyWithImpl(this._self, this._then);

  final _BookingModel _self;
  final $Res Function(_BookingModel) _then;

/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? recurrenceState = null,Object? host = null,Object? createdAt = null,Object? timeRange = null,Object? userId = null,Object? id = null,Object? location = null,Object? description = null,Object? password = freezed,Object? recurrenceModel = freezed,Object? occurrenceId = freezed,Object? groupId = freezed,}) {
  return _then(_BookingModel(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,recurrenceState: null == recurrenceState ? _self.recurrenceState : recurrenceState // ignore: cast_nullable_to_non_nullable
as RecurrenceState,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,timeRange: null == timeRange ? _self.timeRange : timeRange // ignore: cast_nullable_to_non_nullable
as CustomDateTimeRange,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LocationData,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,recurrenceModel: freezed == recurrenceModel ? _self.recurrenceModel : recurrenceModel // ignore: cast_nullable_to_non_nullable
as RecurrenceConfigurationModel?,occurrenceId: freezed == occurrenceId ? _self.occurrenceId : occurrenceId // ignore: cast_nullable_to_non_nullable
as String?,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecurrenceConfigurationModelCopyWith<$Res>? get recurrenceModel {
    if (_self.recurrenceModel == null) {
    return null;
  }

  return $RecurrenceConfigurationModelCopyWith<$Res>(_self.recurrenceModel!, (value) {
    return _then(_self.copyWith(recurrenceModel: value));
  });
}
}

// dart format on
