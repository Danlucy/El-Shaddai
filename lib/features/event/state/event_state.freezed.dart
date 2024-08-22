// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventState _$EventStateFromJson(Map<String, dynamic> json) {
  return _EventState.fromJson(json);
}

/// @nodoc
mixin _$EventState {
  DateTimeRange? get timeRange => throw _privateConstructorUsedError;
  String? get eventId => throw _privateConstructorUsedError;
  String? get hostId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  LocationData? get location => throw _privateConstructorUsedError;
  RecurrenceState get recurrenceState => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventStateCopyWith<EventState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventStateCopyWith<$Res> {
  factory $EventStateCopyWith(
          EventState value, $Res Function(EventState) then) =
      _$EventStateCopyWithImpl<$Res, EventState>;
  @useResult
  $Res call(
      {DateTimeRange? timeRange,
      String? eventId,
      String? hostId,
      String? title,
      String? description,
      LocationData? location,
      RecurrenceState recurrenceState});
}

/// @nodoc
class _$EventStateCopyWithImpl<$Res, $Val extends EventState>
    implements $EventStateCopyWith<$Res> {
  _$EventStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timeRange = freezed,
    Object? eventId = freezed,
    Object? hostId = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? location = freezed,
    Object? recurrenceState = null,
  }) {
    return _then(_value.copyWith(
      timeRange: freezed == timeRange
          ? _value.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as DateTimeRange?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
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
      recurrenceState: null == recurrenceState
          ? _value.recurrenceState
          : recurrenceState // ignore: cast_nullable_to_non_nullable
              as RecurrenceState,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventStateImplCopyWith<$Res>
    implements $EventStateCopyWith<$Res> {
  factory _$$EventStateImplCopyWith(
          _$EventStateImpl value, $Res Function(_$EventStateImpl) then) =
      __$$EventStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTimeRange? timeRange,
      String? eventId,
      String? hostId,
      String? title,
      String? description,
      LocationData? location,
      RecurrenceState recurrenceState});
}

/// @nodoc
class __$$EventStateImplCopyWithImpl<$Res>
    extends _$EventStateCopyWithImpl<$Res, _$EventStateImpl>
    implements _$$EventStateImplCopyWith<$Res> {
  __$$EventStateImplCopyWithImpl(
      _$EventStateImpl _value, $Res Function(_$EventStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timeRange = freezed,
    Object? eventId = freezed,
    Object? hostId = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? location = freezed,
    Object? recurrenceState = null,
  }) {
    return _then(_$EventStateImpl(
      timeRange: freezed == timeRange
          ? _value.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as DateTimeRange?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
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
      recurrenceState: null == recurrenceState
          ? _value.recurrenceState
          : recurrenceState // ignore: cast_nullable_to_non_nullable
              as RecurrenceState,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@DateTimeRangeConverter()
@LocationDataConverter()
class _$EventStateImpl extends _EventState {
  const _$EventStateImpl(
      {this.timeRange,
      this.eventId,
      this.hostId,
      this.title,
      this.description,
      this.location,
      this.recurrenceState = RecurrenceState.none})
      : super._();

  factory _$EventStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventStateImplFromJson(json);

  @override
  final DateTimeRange? timeRange;
  @override
  final String? eventId;
  @override
  final String? hostId;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final LocationData? location;
  @override
  @JsonKey()
  final RecurrenceState recurrenceState;

  @override
  String toString() {
    return 'EventState(timeRange: $timeRange, eventId: $eventId, hostId: $hostId, title: $title, description: $description, location: $location, recurrenceState: $recurrenceState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventStateImpl &&
            (identical(other.timeRange, timeRange) ||
                other.timeRange == timeRange) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.recurrenceState, recurrenceState) ||
                other.recurrenceState == recurrenceState));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, timeRange, eventId, hostId,
      title, description, location, recurrenceState);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventStateImplCopyWith<_$EventStateImpl> get copyWith =>
      __$$EventStateImplCopyWithImpl<_$EventStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventStateImplToJson(
      this,
    );
  }
}

abstract class _EventState extends EventState {
  const factory _EventState(
      {final DateTimeRange? timeRange,
      final String? eventId,
      final String? hostId,
      final String? title,
      final String? description,
      final LocationData? location,
      final RecurrenceState recurrenceState}) = _$EventStateImpl;
  const _EventState._() : super._();

  factory _EventState.fromJson(Map<String, dynamic> json) =
      _$EventStateImpl.fromJson;

  @override
  DateTimeRange? get timeRange;
  @override
  String? get eventId;
  @override
  String? get hostId;
  @override
  String? get title;
  @override
  String? get description;
  @override
  LocationData? get location;
  @override
  RecurrenceState get recurrenceState;
  @override
  @JsonKey(ignore: true)
  _$$EventStateImplCopyWith<_$EventStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
