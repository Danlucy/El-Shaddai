// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_submission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookingDTO {

 String get requestId; String get organizationId; bool get isUpdating; String? get bookingId; int get timezoneOffsetMinutes; String get title; RecurrenceState get recurrenceState; String get host;@EpochMillisecondsDateTimeRangeConverter() CustomDateTimeRange get timeRange;@LocationDataConverter() LocationData get location; String get description; String? get password; RecurrenceConfigurationModel? get recurrence; List<BookingSubmissionZoomOccurrence>? get zoomOccurrences;
/// Create a copy of BookingDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingDTOCopyWith<BookingDTO> get copyWith => _$BookingDTOCopyWithImpl<BookingDTO>(this as BookingDTO, _$identity);

  /// Serializes this BookingDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingDTO&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.isUpdating, isUpdating) || other.isUpdating == isUpdating)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.timezoneOffsetMinutes, timezoneOffsetMinutes) || other.timezoneOffsetMinutes == timezoneOffsetMinutes)&&(identical(other.title, title) || other.title == title)&&(identical(other.recurrenceState, recurrenceState) || other.recurrenceState == recurrenceState)&&(identical(other.host, host) || other.host == host)&&(identical(other.timeRange, timeRange) || other.timeRange == timeRange)&&(identical(other.location, location) || other.location == location)&&(identical(other.description, description) || other.description == description)&&(identical(other.password, password) || other.password == password)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&const DeepCollectionEquality().equals(other.zoomOccurrences, zoomOccurrences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,organizationId,isUpdating,bookingId,timezoneOffsetMinutes,title,recurrenceState,host,timeRange,location,description,password,recurrence,const DeepCollectionEquality().hash(zoomOccurrences));

@override
String toString() {
  return 'BookingDTO(requestId: $requestId, organizationId: $organizationId, isUpdating: $isUpdating, bookingId: $bookingId, timezoneOffsetMinutes: $timezoneOffsetMinutes, title: $title, recurrenceState: $recurrenceState, host: $host, timeRange: $timeRange, location: $location, description: $description, password: $password, recurrence: $recurrence, zoomOccurrences: $zoomOccurrences)';
}


}

/// @nodoc
abstract mixin class $BookingDTOCopyWith<$Res>  {
  factory $BookingDTOCopyWith(BookingDTO value, $Res Function(BookingDTO) _then) = _$BookingDTOCopyWithImpl;
@useResult
$Res call({
 String requestId, String organizationId, bool isUpdating, String? bookingId, int timezoneOffsetMinutes, String title, RecurrenceState recurrenceState, String host,@EpochMillisecondsDateTimeRangeConverter() CustomDateTimeRange timeRange,@LocationDataConverter() LocationData location, String description, String? password, RecurrenceConfigurationModel? recurrence, List<BookingSubmissionZoomOccurrence>? zoomOccurrences
});


$RecurrenceConfigurationModelCopyWith<$Res>? get recurrence;

}
/// @nodoc
class _$BookingDTOCopyWithImpl<$Res>
    implements $BookingDTOCopyWith<$Res> {
  _$BookingDTOCopyWithImpl(this._self, this._then);

  final BookingDTO _self;
  final $Res Function(BookingDTO) _then;

/// Create a copy of BookingDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? organizationId = null,Object? isUpdating = null,Object? bookingId = freezed,Object? timezoneOffsetMinutes = null,Object? title = null,Object? recurrenceState = null,Object? host = null,Object? timeRange = null,Object? location = null,Object? description = null,Object? password = freezed,Object? recurrence = freezed,Object? zoomOccurrences = freezed,}) {
  return _then(_self.copyWith(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,isUpdating: null == isUpdating ? _self.isUpdating : isUpdating // ignore: cast_nullable_to_non_nullable
as bool,bookingId: freezed == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String?,timezoneOffsetMinutes: null == timezoneOffsetMinutes ? _self.timezoneOffsetMinutes : timezoneOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,recurrenceState: null == recurrenceState ? _self.recurrenceState : recurrenceState // ignore: cast_nullable_to_non_nullable
as RecurrenceState,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,timeRange: null == timeRange ? _self.timeRange : timeRange // ignore: cast_nullable_to_non_nullable
as CustomDateTimeRange,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LocationData,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as RecurrenceConfigurationModel?,zoomOccurrences: freezed == zoomOccurrences ? _self.zoomOccurrences : zoomOccurrences // ignore: cast_nullable_to_non_nullable
as List<BookingSubmissionZoomOccurrence>?,
  ));
}
/// Create a copy of BookingDTO
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecurrenceConfigurationModelCopyWith<$Res>? get recurrence {
    if (_self.recurrence == null) {
    return null;
  }

  return $RecurrenceConfigurationModelCopyWith<$Res>(_self.recurrence!, (value) {
    return _then(_self.copyWith(recurrence: value));
  });
}
}


/// Adds pattern-matching-related methods to [BookingDTO].
extension BookingDTOPatterns on BookingDTO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingDTO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingDTO() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingDTO value)  $default,){
final _that = this;
switch (_that) {
case _BookingDTO():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingDTO value)?  $default,){
final _that = this;
switch (_that) {
case _BookingDTO() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String requestId,  String organizationId,  bool isUpdating,  String? bookingId,  int timezoneOffsetMinutes,  String title,  RecurrenceState recurrenceState,  String host, @EpochMillisecondsDateTimeRangeConverter()  CustomDateTimeRange timeRange, @LocationDataConverter()  LocationData location,  String description,  String? password,  RecurrenceConfigurationModel? recurrence,  List<BookingSubmissionZoomOccurrence>? zoomOccurrences)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingDTO() when $default != null:
return $default(_that.requestId,_that.organizationId,_that.isUpdating,_that.bookingId,_that.timezoneOffsetMinutes,_that.title,_that.recurrenceState,_that.host,_that.timeRange,_that.location,_that.description,_that.password,_that.recurrence,_that.zoomOccurrences);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String requestId,  String organizationId,  bool isUpdating,  String? bookingId,  int timezoneOffsetMinutes,  String title,  RecurrenceState recurrenceState,  String host, @EpochMillisecondsDateTimeRangeConverter()  CustomDateTimeRange timeRange, @LocationDataConverter()  LocationData location,  String description,  String? password,  RecurrenceConfigurationModel? recurrence,  List<BookingSubmissionZoomOccurrence>? zoomOccurrences)  $default,) {final _that = this;
switch (_that) {
case _BookingDTO():
return $default(_that.requestId,_that.organizationId,_that.isUpdating,_that.bookingId,_that.timezoneOffsetMinutes,_that.title,_that.recurrenceState,_that.host,_that.timeRange,_that.location,_that.description,_that.password,_that.recurrence,_that.zoomOccurrences);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String requestId,  String organizationId,  bool isUpdating,  String? bookingId,  int timezoneOffsetMinutes,  String title,  RecurrenceState recurrenceState,  String host, @EpochMillisecondsDateTimeRangeConverter()  CustomDateTimeRange timeRange, @LocationDataConverter()  LocationData location,  String description,  String? password,  RecurrenceConfigurationModel? recurrence,  List<BookingSubmissionZoomOccurrence>? zoomOccurrences)?  $default,) {final _that = this;
switch (_that) {
case _BookingDTO() when $default != null:
return $default(_that.requestId,_that.organizationId,_that.isUpdating,_that.bookingId,_that.timezoneOffsetMinutes,_that.title,_that.recurrenceState,_that.host,_that.timeRange,_that.location,_that.description,_that.password,_that.recurrence,_that.zoomOccurrences);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BookingDTO extends BookingDTO {
  const _BookingDTO({required this.requestId, required this.organizationId, required this.isUpdating, required this.bookingId, required this.timezoneOffsetMinutes, required this.title, required this.recurrenceState, required this.host, @EpochMillisecondsDateTimeRangeConverter() required this.timeRange, @LocationDataConverter() required this.location, required this.description, required this.password, required this.recurrence, required final  List<BookingSubmissionZoomOccurrence>? zoomOccurrences}): _zoomOccurrences = zoomOccurrences,super._();
  factory _BookingDTO.fromJson(Map<String, dynamic> json) => _$BookingDTOFromJson(json);

@override final  String requestId;
@override final  String organizationId;
@override final  bool isUpdating;
@override final  String? bookingId;
@override final  int timezoneOffsetMinutes;
@override final  String title;
@override final  RecurrenceState recurrenceState;
@override final  String host;
@override@EpochMillisecondsDateTimeRangeConverter() final  CustomDateTimeRange timeRange;
@override@LocationDataConverter() final  LocationData location;
@override final  String description;
@override final  String? password;
@override final  RecurrenceConfigurationModel? recurrence;
 final  List<BookingSubmissionZoomOccurrence>? _zoomOccurrences;
@override List<BookingSubmissionZoomOccurrence>? get zoomOccurrences {
  final value = _zoomOccurrences;
  if (value == null) return null;
  if (_zoomOccurrences is EqualUnmodifiableListView) return _zoomOccurrences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of BookingDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingDTOCopyWith<_BookingDTO> get copyWith => __$BookingDTOCopyWithImpl<_BookingDTO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingDTOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingDTO&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.isUpdating, isUpdating) || other.isUpdating == isUpdating)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.timezoneOffsetMinutes, timezoneOffsetMinutes) || other.timezoneOffsetMinutes == timezoneOffsetMinutes)&&(identical(other.title, title) || other.title == title)&&(identical(other.recurrenceState, recurrenceState) || other.recurrenceState == recurrenceState)&&(identical(other.host, host) || other.host == host)&&(identical(other.timeRange, timeRange) || other.timeRange == timeRange)&&(identical(other.location, location) || other.location == location)&&(identical(other.description, description) || other.description == description)&&(identical(other.password, password) || other.password == password)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&const DeepCollectionEquality().equals(other._zoomOccurrences, _zoomOccurrences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,organizationId,isUpdating,bookingId,timezoneOffsetMinutes,title,recurrenceState,host,timeRange,location,description,password,recurrence,const DeepCollectionEquality().hash(_zoomOccurrences));

@override
String toString() {
  return 'BookingDTO(requestId: $requestId, organizationId: $organizationId, isUpdating: $isUpdating, bookingId: $bookingId, timezoneOffsetMinutes: $timezoneOffsetMinutes, title: $title, recurrenceState: $recurrenceState, host: $host, timeRange: $timeRange, location: $location, description: $description, password: $password, recurrence: $recurrence, zoomOccurrences: $zoomOccurrences)';
}


}

/// @nodoc
abstract mixin class _$BookingDTOCopyWith<$Res> implements $BookingDTOCopyWith<$Res> {
  factory _$BookingDTOCopyWith(_BookingDTO value, $Res Function(_BookingDTO) _then) = __$BookingDTOCopyWithImpl;
@override @useResult
$Res call({
 String requestId, String organizationId, bool isUpdating, String? bookingId, int timezoneOffsetMinutes, String title, RecurrenceState recurrenceState, String host,@EpochMillisecondsDateTimeRangeConverter() CustomDateTimeRange timeRange,@LocationDataConverter() LocationData location, String description, String? password, RecurrenceConfigurationModel? recurrence, List<BookingSubmissionZoomOccurrence>? zoomOccurrences
});


@override $RecurrenceConfigurationModelCopyWith<$Res>? get recurrence;

}
/// @nodoc
class __$BookingDTOCopyWithImpl<$Res>
    implements _$BookingDTOCopyWith<$Res> {
  __$BookingDTOCopyWithImpl(this._self, this._then);

  final _BookingDTO _self;
  final $Res Function(_BookingDTO) _then;

/// Create a copy of BookingDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? organizationId = null,Object? isUpdating = null,Object? bookingId = freezed,Object? timezoneOffsetMinutes = null,Object? title = null,Object? recurrenceState = null,Object? host = null,Object? timeRange = null,Object? location = null,Object? description = null,Object? password = freezed,Object? recurrence = freezed,Object? zoomOccurrences = freezed,}) {
  return _then(_BookingDTO(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,isUpdating: null == isUpdating ? _self.isUpdating : isUpdating // ignore: cast_nullable_to_non_nullable
as bool,bookingId: freezed == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String?,timezoneOffsetMinutes: null == timezoneOffsetMinutes ? _self.timezoneOffsetMinutes : timezoneOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,recurrenceState: null == recurrenceState ? _self.recurrenceState : recurrenceState // ignore: cast_nullable_to_non_nullable
as RecurrenceState,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,timeRange: null == timeRange ? _self.timeRange : timeRange // ignore: cast_nullable_to_non_nullable
as CustomDateTimeRange,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LocationData,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as RecurrenceConfigurationModel?,zoomOccurrences: freezed == zoomOccurrences ? _self._zoomOccurrences : zoomOccurrences // ignore: cast_nullable_to_non_nullable
as List<BookingSubmissionZoomOccurrence>?,
  ));
}

/// Create a copy of BookingDTO
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecurrenceConfigurationModelCopyWith<$Res>? get recurrence {
    if (_self.recurrence == null) {
    return null;
  }

  return $RecurrenceConfigurationModelCopyWith<$Res>(_self.recurrence!, (value) {
    return _then(_self.copyWith(recurrence: value));
  });
}
}


/// @nodoc
mixin _$BookingSubmissionZoomOccurrence {

@JsonKey(fromJson: _nullableStringFromJson) String? get occurrenceId;
/// Create a copy of BookingSubmissionZoomOccurrence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingSubmissionZoomOccurrenceCopyWith<BookingSubmissionZoomOccurrence> get copyWith => _$BookingSubmissionZoomOccurrenceCopyWithImpl<BookingSubmissionZoomOccurrence>(this as BookingSubmissionZoomOccurrence, _$identity);

  /// Serializes this BookingSubmissionZoomOccurrence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingSubmissionZoomOccurrence&&(identical(other.occurrenceId, occurrenceId) || other.occurrenceId == occurrenceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,occurrenceId);

@override
String toString() {
  return 'BookingSubmissionZoomOccurrence(occurrenceId: $occurrenceId)';
}


}

/// @nodoc
abstract mixin class $BookingSubmissionZoomOccurrenceCopyWith<$Res>  {
  factory $BookingSubmissionZoomOccurrenceCopyWith(BookingSubmissionZoomOccurrence value, $Res Function(BookingSubmissionZoomOccurrence) _then) = _$BookingSubmissionZoomOccurrenceCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _nullableStringFromJson) String? occurrenceId
});




}
/// @nodoc
class _$BookingSubmissionZoomOccurrenceCopyWithImpl<$Res>
    implements $BookingSubmissionZoomOccurrenceCopyWith<$Res> {
  _$BookingSubmissionZoomOccurrenceCopyWithImpl(this._self, this._then);

  final BookingSubmissionZoomOccurrence _self;
  final $Res Function(BookingSubmissionZoomOccurrence) _then;

/// Create a copy of BookingSubmissionZoomOccurrence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? occurrenceId = freezed,}) {
  return _then(_self.copyWith(
occurrenceId: freezed == occurrenceId ? _self.occurrenceId : occurrenceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingSubmissionZoomOccurrence].
extension BookingSubmissionZoomOccurrencePatterns on BookingSubmissionZoomOccurrence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingSubmissionZoomOccurrence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingSubmissionZoomOccurrence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingSubmissionZoomOccurrence value)  $default,){
final _that = this;
switch (_that) {
case _BookingSubmissionZoomOccurrence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingSubmissionZoomOccurrence value)?  $default,){
final _that = this;
switch (_that) {
case _BookingSubmissionZoomOccurrence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _nullableStringFromJson)  String? occurrenceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingSubmissionZoomOccurrence() when $default != null:
return $default(_that.occurrenceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _nullableStringFromJson)  String? occurrenceId)  $default,) {final _that = this;
switch (_that) {
case _BookingSubmissionZoomOccurrence():
return $default(_that.occurrenceId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _nullableStringFromJson)  String? occurrenceId)?  $default,) {final _that = this;
switch (_that) {
case _BookingSubmissionZoomOccurrence() when $default != null:
return $default(_that.occurrenceId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _BookingSubmissionZoomOccurrence extends BookingSubmissionZoomOccurrence {
  const _BookingSubmissionZoomOccurrence({@JsonKey(fromJson: _nullableStringFromJson) required this.occurrenceId}): super._();
  factory _BookingSubmissionZoomOccurrence.fromJson(Map<String, dynamic> json) => _$BookingSubmissionZoomOccurrenceFromJson(json);

@override@JsonKey(fromJson: _nullableStringFromJson) final  String? occurrenceId;

/// Create a copy of BookingSubmissionZoomOccurrence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingSubmissionZoomOccurrenceCopyWith<_BookingSubmissionZoomOccurrence> get copyWith => __$BookingSubmissionZoomOccurrenceCopyWithImpl<_BookingSubmissionZoomOccurrence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingSubmissionZoomOccurrenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingSubmissionZoomOccurrence&&(identical(other.occurrenceId, occurrenceId) || other.occurrenceId == occurrenceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,occurrenceId);

@override
String toString() {
  return 'BookingSubmissionZoomOccurrence(occurrenceId: $occurrenceId)';
}


}

/// @nodoc
abstract mixin class _$BookingSubmissionZoomOccurrenceCopyWith<$Res> implements $BookingSubmissionZoomOccurrenceCopyWith<$Res> {
  factory _$BookingSubmissionZoomOccurrenceCopyWith(_BookingSubmissionZoomOccurrence value, $Res Function(_BookingSubmissionZoomOccurrence) _then) = __$BookingSubmissionZoomOccurrenceCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _nullableStringFromJson) String? occurrenceId
});




}
/// @nodoc
class __$BookingSubmissionZoomOccurrenceCopyWithImpl<$Res>
    implements _$BookingSubmissionZoomOccurrenceCopyWith<$Res> {
  __$BookingSubmissionZoomOccurrenceCopyWithImpl(this._self, this._then);

  final _BookingSubmissionZoomOccurrence _self;
  final $Res Function(_BookingSubmissionZoomOccurrence) _then;

/// Create a copy of BookingSubmissionZoomOccurrence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? occurrenceId = freezed,}) {
  return _then(_BookingSubmissionZoomOccurrence(
occurrenceId: freezed == occurrenceId ? _self.occurrenceId : occurrenceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
