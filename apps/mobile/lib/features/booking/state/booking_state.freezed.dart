// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookingState {

 CustomDateTimeRange? get timeRange; String? get bookingId; String? get hostId; String? get title; String? get description; LocationData? get location; String? get password; String? get occurrenceId; RecurrenceState get recurrenceState; int get recurrenceFrequency;
/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingStateCopyWith<BookingState> get copyWith => _$BookingStateCopyWithImpl<BookingState>(this as BookingState, _$identity);

  /// Serializes this BookingState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingState&&(identical(other.timeRange, timeRange) || other.timeRange == timeRange)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.password, password) || other.password == password)&&(identical(other.occurrenceId, occurrenceId) || other.occurrenceId == occurrenceId)&&(identical(other.recurrenceState, recurrenceState) || other.recurrenceState == recurrenceState)&&(identical(other.recurrenceFrequency, recurrenceFrequency) || other.recurrenceFrequency == recurrenceFrequency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timeRange,bookingId,hostId,title,description,location,password,occurrenceId,recurrenceState,recurrenceFrequency);

@override
String toString() {
  return 'BookingState(timeRange: $timeRange, bookingId: $bookingId, hostId: $hostId, title: $title, description: $description, location: $location, password: $password, occurrenceId: $occurrenceId, recurrenceState: $recurrenceState, recurrenceFrequency: $recurrenceFrequency)';
}


}

/// @nodoc
abstract mixin class $BookingStateCopyWith<$Res>  {
  factory $BookingStateCopyWith(BookingState value, $Res Function(BookingState) _then) = _$BookingStateCopyWithImpl;
@useResult
$Res call({
 CustomDateTimeRange? timeRange, String? bookingId, String? hostId, String? title, String? description, LocationData? location, String? password, String? occurrenceId, RecurrenceState recurrenceState, int recurrenceFrequency
});




}
/// @nodoc
class _$BookingStateCopyWithImpl<$Res>
    implements $BookingStateCopyWith<$Res> {
  _$BookingStateCopyWithImpl(this._self, this._then);

  final BookingState _self;
  final $Res Function(BookingState) _then;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timeRange = freezed,Object? bookingId = freezed,Object? hostId = freezed,Object? title = freezed,Object? description = freezed,Object? location = freezed,Object? password = freezed,Object? occurrenceId = freezed,Object? recurrenceState = null,Object? recurrenceFrequency = null,}) {
  return _then(_self.copyWith(
timeRange: freezed == timeRange ? _self.timeRange : timeRange // ignore: cast_nullable_to_non_nullable
as CustomDateTimeRange?,bookingId: freezed == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String?,hostId: freezed == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LocationData?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,occurrenceId: freezed == occurrenceId ? _self.occurrenceId : occurrenceId // ignore: cast_nullable_to_non_nullable
as String?,recurrenceState: null == recurrenceState ? _self.recurrenceState : recurrenceState // ignore: cast_nullable_to_non_nullable
as RecurrenceState,recurrenceFrequency: null == recurrenceFrequency ? _self.recurrenceFrequency : recurrenceFrequency // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingState].
extension BookingStatePatterns on BookingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingState value)  $default,){
final _that = this;
switch (_that) {
case _BookingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingState value)?  $default,){
final _that = this;
switch (_that) {
case _BookingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CustomDateTimeRange? timeRange,  String? bookingId,  String? hostId,  String? title,  String? description,  LocationData? location,  String? password,  String? occurrenceId,  RecurrenceState recurrenceState,  int recurrenceFrequency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingState() when $default != null:
return $default(_that.timeRange,_that.bookingId,_that.hostId,_that.title,_that.description,_that.location,_that.password,_that.occurrenceId,_that.recurrenceState,_that.recurrenceFrequency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CustomDateTimeRange? timeRange,  String? bookingId,  String? hostId,  String? title,  String? description,  LocationData? location,  String? password,  String? occurrenceId,  RecurrenceState recurrenceState,  int recurrenceFrequency)  $default,) {final _that = this;
switch (_that) {
case _BookingState():
return $default(_that.timeRange,_that.bookingId,_that.hostId,_that.title,_that.description,_that.location,_that.password,_that.occurrenceId,_that.recurrenceState,_that.recurrenceFrequency);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CustomDateTimeRange? timeRange,  String? bookingId,  String? hostId,  String? title,  String? description,  LocationData? location,  String? password,  String? occurrenceId,  RecurrenceState recurrenceState,  int recurrenceFrequency)?  $default,) {final _that = this;
switch (_that) {
case _BookingState() when $default != null:
return $default(_that.timeRange,_that.bookingId,_that.hostId,_that.title,_that.description,_that.location,_that.password,_that.occurrenceId,_that.recurrenceState,_that.recurrenceFrequency);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()
@CustomDateTimeRangeConverter()
@LocationDataConverter()
class _BookingState extends BookingState {
  const _BookingState({this.timeRange, this.bookingId, this.hostId, this.title, this.description, this.location, this.password, this.occurrenceId, this.recurrenceState = RecurrenceState.none, this.recurrenceFrequency = 2}): super._();
  factory _BookingState.fromJson(Map<String, dynamic> json) => _$BookingStateFromJson(json);

@override final  CustomDateTimeRange? timeRange;
@override final  String? bookingId;
@override final  String? hostId;
@override final  String? title;
@override final  String? description;
@override final  LocationData? location;
@override final  String? password;
@override final  String? occurrenceId;
@override@JsonKey() final  RecurrenceState recurrenceState;
@override@JsonKey() final  int recurrenceFrequency;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingStateCopyWith<_BookingState> get copyWith => __$BookingStateCopyWithImpl<_BookingState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingState&&(identical(other.timeRange, timeRange) || other.timeRange == timeRange)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.password, password) || other.password == password)&&(identical(other.occurrenceId, occurrenceId) || other.occurrenceId == occurrenceId)&&(identical(other.recurrenceState, recurrenceState) || other.recurrenceState == recurrenceState)&&(identical(other.recurrenceFrequency, recurrenceFrequency) || other.recurrenceFrequency == recurrenceFrequency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timeRange,bookingId,hostId,title,description,location,password,occurrenceId,recurrenceState,recurrenceFrequency);

@override
String toString() {
  return 'BookingState(timeRange: $timeRange, bookingId: $bookingId, hostId: $hostId, title: $title, description: $description, location: $location, password: $password, occurrenceId: $occurrenceId, recurrenceState: $recurrenceState, recurrenceFrequency: $recurrenceFrequency)';
}


}

/// @nodoc
abstract mixin class _$BookingStateCopyWith<$Res> implements $BookingStateCopyWith<$Res> {
  factory _$BookingStateCopyWith(_BookingState value, $Res Function(_BookingState) _then) = __$BookingStateCopyWithImpl;
@override @useResult
$Res call({
 CustomDateTimeRange? timeRange, String? bookingId, String? hostId, String? title, String? description, LocationData? location, String? password, String? occurrenceId, RecurrenceState recurrenceState, int recurrenceFrequency
});




}
/// @nodoc
class __$BookingStateCopyWithImpl<$Res>
    implements _$BookingStateCopyWith<$Res> {
  __$BookingStateCopyWithImpl(this._self, this._then);

  final _BookingState _self;
  final $Res Function(_BookingState) _then;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timeRange = freezed,Object? bookingId = freezed,Object? hostId = freezed,Object? title = freezed,Object? description = freezed,Object? location = freezed,Object? password = freezed,Object? occurrenceId = freezed,Object? recurrenceState = null,Object? recurrenceFrequency = null,}) {
  return _then(_BookingState(
timeRange: freezed == timeRange ? _self.timeRange : timeRange // ignore: cast_nullable_to_non_nullable
as CustomDateTimeRange?,bookingId: freezed == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String?,hostId: freezed == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LocationData?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,occurrenceId: freezed == occurrenceId ? _self.occurrenceId : occurrenceId // ignore: cast_nullable_to_non_nullable
as String?,recurrenceState: null == recurrenceState ? _self.recurrenceState : recurrenceState // ignore: cast_nullable_to_non_nullable
as RecurrenceState,recurrenceFrequency: null == recurrenceFrequency ? _self.recurrenceFrequency : recurrenceFrequency // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
