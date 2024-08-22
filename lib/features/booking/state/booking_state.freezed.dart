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
  String get userId => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  @DateTimeRangeConverter()
  DateTimeRange get timeRange => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
      {String userId,
      String eventId,
      @DateTimeRangeConverter() DateTimeRange timeRange});
}

/// @nodoc
class _$BookingStateCopyWithImpl<$Res, $Val extends BookingState>
    implements $BookingStateCopyWith<$Res> {
  _$BookingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? eventId = null,
    Object? timeRange = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      timeRange: null == timeRange
          ? _value.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as DateTimeRange,
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
      {String userId,
      String eventId,
      @DateTimeRangeConverter() DateTimeRange timeRange});
}

/// @nodoc
class __$$BookingStateImplCopyWithImpl<$Res>
    extends _$BookingStateCopyWithImpl<$Res, _$BookingStateImpl>
    implements _$$BookingStateImplCopyWith<$Res> {
  __$$BookingStateImplCopyWithImpl(
      _$BookingStateImpl _value, $Res Function(_$BookingStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? eventId = null,
    Object? timeRange = null,
  }) {
    return _then(_$BookingStateImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      timeRange: null == timeRange
          ? _value.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as DateTimeRange,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingStateImpl extends _BookingState {
  const _$BookingStateImpl(
      {required this.userId,
      required this.eventId,
      @DateTimeRangeConverter() required this.timeRange})
      : super._();

  factory _$BookingStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingStateImplFromJson(json);

  @override
  final String userId;
  @override
  final String eventId;
  @override
  @DateTimeRangeConverter()
  final DateTimeRange timeRange;

  @override
  String toString() {
    return 'BookingState(userId: $userId, eventId: $eventId, timeRange: $timeRange)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingStateImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.timeRange, timeRange) ||
                other.timeRange == timeRange));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, eventId, timeRange);

  @JsonKey(ignore: true)
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
          {required final String userId,
          required final String eventId,
          @DateTimeRangeConverter() required final DateTimeRange timeRange}) =
      _$BookingStateImpl;
  const _BookingState._() : super._();

  factory _BookingState.fromJson(Map<String, dynamic> json) =
      _$BookingStateImpl.fromJson;

  @override
  String get userId;
  @override
  String get eventId;
  @override
  @DateTimeRangeConverter()
  DateTimeRange get timeRange;
  @override
  @JsonKey(ignore: true)
  _$$BookingStateImplCopyWith<_$BookingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
