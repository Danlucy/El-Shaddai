// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) {
  return _BookingModel.fromJson(json);
}

/// @nodoc
mixin _$BookingModel {
  String get title => throw _privateConstructorUsedError;
  @CustomDateTimeRangeConverter()
  RecurrenceState get recurrenceState => throw _privateConstructorUsedError;
  String get host => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  @CustomDateTimeRangeConverter()
  CustomDateTimeRange get timeRange => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  @LocationDataConverter()
  LocationData get location => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @RecurrenceConfigurationConverter()
  RecurrenceConfigurationModel? get recurrenceModel =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingModelCopyWith<BookingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingModelCopyWith<$Res> {
  factory $BookingModelCopyWith(
          BookingModel value, $Res Function(BookingModel) then) =
      _$BookingModelCopyWithImpl<$Res, BookingModel>;
  @useResult
  $Res call(
      {String title,
      @CustomDateTimeRangeConverter() RecurrenceState recurrenceState,
      String host,
      DateTime createdAt,
      @CustomDateTimeRangeConverter() CustomDateTimeRange timeRange,
      String userId,
      String id,
      @LocationDataConverter() LocationData location,
      String description,
      @RecurrenceConfigurationConverter()
      RecurrenceConfigurationModel? recurrenceModel});

  $RecurrenceConfigurationModelCopyWith<$Res>? get recurrenceModel;
}

/// @nodoc
class _$BookingModelCopyWithImpl<$Res, $Val extends BookingModel>
    implements $BookingModelCopyWith<$Res> {
  _$BookingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? recurrenceState = null,
    Object? host = null,
    Object? createdAt = null,
    Object? timeRange = null,
    Object? userId = null,
    Object? id = null,
    Object? location = null,
    Object? description = null,
    Object? recurrenceModel = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      recurrenceState: null == recurrenceState
          ? _value.recurrenceState
          : recurrenceState // ignore: cast_nullable_to_non_nullable
              as RecurrenceState,
      host: null == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timeRange: null == timeRange
          ? _value.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as CustomDateTimeRange,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LocationData,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      recurrenceModel: freezed == recurrenceModel
          ? _value.recurrenceModel
          : recurrenceModel // ignore: cast_nullable_to_non_nullable
              as RecurrenceConfigurationModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RecurrenceConfigurationModelCopyWith<$Res>? get recurrenceModel {
    if (_value.recurrenceModel == null) {
      return null;
    }

    return $RecurrenceConfigurationModelCopyWith<$Res>(_value.recurrenceModel!,
        (value) {
      return _then(_value.copyWith(recurrenceModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingModelImplCopyWith<$Res>
    implements $BookingModelCopyWith<$Res> {
  factory _$$BookingModelImplCopyWith(
          _$BookingModelImpl value, $Res Function(_$BookingModelImpl) then) =
      __$$BookingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      @CustomDateTimeRangeConverter() RecurrenceState recurrenceState,
      String host,
      DateTime createdAt,
      @CustomDateTimeRangeConverter() CustomDateTimeRange timeRange,
      String userId,
      String id,
      @LocationDataConverter() LocationData location,
      String description,
      @RecurrenceConfigurationConverter()
      RecurrenceConfigurationModel? recurrenceModel});

  @override
  $RecurrenceConfigurationModelCopyWith<$Res>? get recurrenceModel;
}

/// @nodoc
class __$$BookingModelImplCopyWithImpl<$Res>
    extends _$BookingModelCopyWithImpl<$Res, _$BookingModelImpl>
    implements _$$BookingModelImplCopyWith<$Res> {
  __$$BookingModelImplCopyWithImpl(
      _$BookingModelImpl _value, $Res Function(_$BookingModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? recurrenceState = null,
    Object? host = null,
    Object? createdAt = null,
    Object? timeRange = null,
    Object? userId = null,
    Object? id = null,
    Object? location = null,
    Object? description = null,
    Object? recurrenceModel = freezed,
  }) {
    return _then(_$BookingModelImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      recurrenceState: null == recurrenceState
          ? _value.recurrenceState
          : recurrenceState // ignore: cast_nullable_to_non_nullable
              as RecurrenceState,
      host: null == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timeRange: null == timeRange
          ? _value.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as CustomDateTimeRange,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LocationData,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      recurrenceModel: freezed == recurrenceModel
          ? _value.recurrenceModel
          : recurrenceModel // ignore: cast_nullable_to_non_nullable
              as RecurrenceConfigurationModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingModelImpl extends _BookingModel {
  const _$BookingModelImpl(
      {required this.title,
      @CustomDateTimeRangeConverter() required this.recurrenceState,
      required this.host,
      required this.createdAt,
      @CustomDateTimeRangeConverter() required this.timeRange,
      required this.userId,
      required this.id,
      @LocationDataConverter() required this.location,
      required this.description,
      @RecurrenceConfigurationConverter() this.recurrenceModel})
      : super._();

  factory _$BookingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingModelImplFromJson(json);

  @override
  final String title;
  @override
  @CustomDateTimeRangeConverter()
  final RecurrenceState recurrenceState;
  @override
  final String host;
  @override
  final DateTime createdAt;
  @override
  @CustomDateTimeRangeConverter()
  final CustomDateTimeRange timeRange;
  @override
  final String userId;
  @override
  final String id;
  @override
  @LocationDataConverter()
  final LocationData location;
  @override
  final String description;
  @override
  @RecurrenceConfigurationConverter()
  final RecurrenceConfigurationModel? recurrenceModel;

  @override
  String toString() {
    return 'BookingModel(title: $title, recurrenceState: $recurrenceState, host: $host, createdAt: $createdAt, timeRange: $timeRange, userId: $userId, id: $id, location: $location, description: $description, recurrenceModel: $recurrenceModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.recurrenceState, recurrenceState) ||
                other.recurrenceState == recurrenceState) &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.timeRange, timeRange) ||
                other.timeRange == timeRange) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.recurrenceModel, recurrenceModel) ||
                other.recurrenceModel == recurrenceModel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, title, recurrenceState, host,
      createdAt, timeRange, userId, id, location, description, recurrenceModel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      __$$BookingModelImplCopyWithImpl<_$BookingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingModelImplToJson(
      this,
    );
  }
}

abstract class _BookingModel extends BookingModel {
  const factory _BookingModel(
          {required final String title,
          @CustomDateTimeRangeConverter()
          required final RecurrenceState recurrenceState,
          required final String host,
          required final DateTime createdAt,
          @CustomDateTimeRangeConverter()
          required final CustomDateTimeRange timeRange,
          required final String userId,
          required final String id,
          @LocationDataConverter() required final LocationData location,
          required final String description,
          @RecurrenceConfigurationConverter()
          final RecurrenceConfigurationModel? recurrenceModel}) =
      _$BookingModelImpl;
  const _BookingModel._() : super._();

  factory _BookingModel.fromJson(Map<String, dynamic> json) =
      _$BookingModelImpl.fromJson;

  @override
  String get title;
  @override
  @CustomDateTimeRangeConverter()
  RecurrenceState get recurrenceState;
  @override
  String get host;
  @override
  DateTime get createdAt;
  @override
  @CustomDateTimeRangeConverter()
  CustomDateTimeRange get timeRange;
  @override
  String get userId;
  @override
  String get id;
  @override
  @LocationDataConverter()
  LocationData get location;
  @override
  String get description;
  @override
  @RecurrenceConfigurationConverter()
  RecurrenceConfigurationModel? get recurrenceModel;
  @override
  @JsonKey(ignore: true)
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
