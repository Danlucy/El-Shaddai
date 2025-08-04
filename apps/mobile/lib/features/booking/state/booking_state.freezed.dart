// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookingState _$BookingStateFromJson(Map<String, dynamic> json) {
  return _BookingState.fromJson(json);
}

/// @nodoc
mixin _$BookingState {
  CustomDateTimeRange? get timeRange => throw _privateConstructorUsedError;
  String? get bookingId => throw _privateConstructorUsedError;
  String? get hostId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  LocationData? get location => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  RecurrenceState get recurrenceState => throw _privateConstructorUsedError;
  int get recurrenceFrequency => throw _privateConstructorUsedError;

  /// Serializes this BookingState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingStateCopyWith<BookingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingStateCopyWith<$Res> {
  factory $BookingStateCopyWith(
          BookingState value, $Res Function(BookingState) then) =
      _$BookingStateCopyWithImpl<$Res, BookingState>;
  @useResult
  $Res call(
      {CustomDateTimeRange? timeRange,
      String? bookingId,
      String? hostId,
      String? title,
      String? description,
      LocationData? location,
      String? password,
      RecurrenceState recurrenceState,
      int recurrenceFrequency});
}

/// @nodoc
class _$BookingStateCopyWithImpl<$Res, $Val extends BookingState>
    implements $BookingStateCopyWith<$Res> {
  _$BookingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timeRange = freezed,
    Object? bookingId = freezed,
    Object? hostId = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? location = freezed,
    Object? password = freezed,
    Object? recurrenceState = null,
    Object? recurrenceFrequency = null,
  }) {
    return _then(_value.copyWith(
      timeRange: freezed == timeRange
          ? _value.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as CustomDateTimeRange?,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      hostId: freezed == hostId
          ? _value.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LocationData?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      recurrenceState: null == recurrenceState
          ? _value.recurrenceState
          : recurrenceState // ignore: cast_nullable_to_non_nullable
              as RecurrenceState,
      recurrenceFrequency: null == recurrenceFrequency
          ? _value.recurrenceFrequency
          : recurrenceFrequency // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingStateImplCopyWith<$Res>
    implements $BookingStateCopyWith<$Res> {
  factory _$$BookingStateImplCopyWith(
          _$BookingStateImpl value, $Res Function(_$BookingStateImpl) then) =
      __$$BookingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {CustomDateTimeRange? timeRange,
      String? bookingId,
      String? hostId,
      String? title,
      String? description,
      LocationData? location,
      String? password,
      RecurrenceState recurrenceState,
      int recurrenceFrequency});
}

/// @nodoc
class __$$BookingStateImplCopyWithImpl<$Res>
    extends _$BookingStateCopyWithImpl<$Res, _$BookingStateImpl>
    implements _$$BookingStateImplCopyWith<$Res> {
  __$$BookingStateImplCopyWithImpl(
      _$BookingStateImpl _value, $Res Function(_$BookingStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timeRange = freezed,
    Object? bookingId = freezed,
    Object? hostId = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? location = freezed,
    Object? password = freezed,
    Object? recurrenceState = null,
    Object? recurrenceFrequency = null,
  }) {
    return _then(_$BookingStateImpl(
      timeRange: freezed == timeRange
          ? _value.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as CustomDateTimeRange?,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      hostId: freezed == hostId
          ? _value.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LocationData?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      recurrenceState: null == recurrenceState
          ? _value.recurrenceState
          : recurrenceState // ignore: cast_nullable_to_non_nullable
              as RecurrenceState,
      recurrenceFrequency: null == recurrenceFrequency
          ? _value.recurrenceFrequency
          : recurrenceFrequency // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@CustomDateTimeRangeConverter()
@LocationDataConverter()
class _$BookingStateImpl extends _BookingState {
  const _$BookingStateImpl(
      {this.timeRange,
      this.bookingId,
      this.hostId,
      this.title,
      this.description,
      this.location,
      this.password,
      this.recurrenceState = RecurrenceState.none,
      this.recurrenceFrequency = 2})
      : super._();

  factory _$BookingStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingStateImplFromJson(json);

  @override
  final CustomDateTimeRange? timeRange;
  @override
  final String? bookingId;
  @override
  final String? hostId;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final LocationData? location;
  @override
  final String? password;
  @override
  @JsonKey()
  final RecurrenceState recurrenceState;
  @override
  @JsonKey()
  final int recurrenceFrequency;

  @override
  String toString() {
    return 'BookingState(timeRange: $timeRange, bookingId: $bookingId, hostId: $hostId, title: $title, description: $description, location: $location, password: $password, recurrenceState: $recurrenceState, recurrenceFrequency: $recurrenceFrequency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingStateImpl &&
            (identical(other.timeRange, timeRange) ||
                other.timeRange == timeRange) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.recurrenceState, recurrenceState) ||
                other.recurrenceState == recurrenceState) &&
            (identical(other.recurrenceFrequency, recurrenceFrequency) ||
                other.recurrenceFrequency == recurrenceFrequency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      timeRange,
      bookingId,
      hostId,
      title,
      description,
      location,
      password,
      recurrenceState,
      recurrenceFrequency);

  /// Create a copy of BookingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingStateImplCopyWith<_$BookingStateImpl> get copyWith =>
      __$$BookingStateImplCopyWithImpl<_$BookingStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingStateImplToJson(
      this,
    );
  }
}

abstract class _BookingState extends BookingState {
  const factory _BookingState(
      {final CustomDateTimeRange? timeRange,
      final String? bookingId,
      final String? hostId,
      final String? title,
      final String? description,
      final LocationData? location,
      final String? password,
      final RecurrenceState recurrenceState,
      final int recurrenceFrequency}) = _$BookingStateImpl;
  const _BookingState._() : super._();

  factory _BookingState.fromJson(Map<String, dynamic> json) =
      _$BookingStateImpl.fromJson;

  @override
  CustomDateTimeRange? get timeRange;
  @override
  String? get bookingId;
  @override
  String? get hostId;
  @override
  String? get title;
  @override
  String? get description;
  @override
  LocationData? get location;
  @override
  String? get password;
  @override
  RecurrenceState get recurrenceState;
  @override
  int get recurrenceFrequency;

  /// Create a copy of BookingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingStateImplCopyWith<_$BookingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
