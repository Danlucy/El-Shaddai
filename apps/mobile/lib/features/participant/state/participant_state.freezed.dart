// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ParticipantState _$ParticipantStateFromJson(Map<String, dynamic> json) {
  return _ParticipantState.fromJson(json);
}

/// @nodoc
mixin _$ParticipantState {
  String? get userId => throw _privateConstructorUsedError;
  String? get bookingId => throw _privateConstructorUsedError;

  /// Serializes this ParticipantState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ParticipantState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParticipantStateCopyWith<ParticipantState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticipantStateCopyWith<$Res> {
  factory $ParticipantStateCopyWith(
          ParticipantState value, $Res Function(ParticipantState) then) =
      _$ParticipantStateCopyWithImpl<$Res, ParticipantState>;
  @useResult
  $Res call({String? userId, String? bookingId});
}

/// @nodoc
class _$ParticipantStateCopyWithImpl<$Res, $Val extends ParticipantState>
    implements $ParticipantStateCopyWith<$Res> {
  _$ParticipantStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParticipantState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? bookingId = freezed,
  }) {
    return _then(_value.copyWith(
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParticipantStateImplCopyWith<$Res>
    implements $ParticipantStateCopyWith<$Res> {
  factory _$$ParticipantStateImplCopyWith(_$ParticipantStateImpl value,
          $Res Function(_$ParticipantStateImpl) then) =
      __$$ParticipantStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? userId, String? bookingId});
}

/// @nodoc
class __$$ParticipantStateImplCopyWithImpl<$Res>
    extends _$ParticipantStateCopyWithImpl<$Res, _$ParticipantStateImpl>
    implements _$$ParticipantStateImplCopyWith<$Res> {
  __$$ParticipantStateImplCopyWithImpl(_$ParticipantStateImpl _value,
      $Res Function(_$ParticipantStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ParticipantState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? bookingId = freezed,
  }) {
    return _then(_$ParticipantStateImpl(
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParticipantStateImpl extends _ParticipantState {
  const _$ParticipantStateImpl({this.userId, this.bookingId}) : super._();

  factory _$ParticipantStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParticipantStateImplFromJson(json);

  @override
  final String? userId;
  @override
  final String? bookingId;

  @override
  String toString() {
    return 'ParticipantState(userId: $userId, bookingId: $bookingId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParticipantStateImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, bookingId);

  /// Create a copy of ParticipantState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParticipantStateImplCopyWith<_$ParticipantStateImpl> get copyWith =>
      __$$ParticipantStateImplCopyWithImpl<_$ParticipantStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParticipantStateImplToJson(
      this,
    );
  }
}

abstract class _ParticipantState extends ParticipantState {
  const factory _ParticipantState(
      {final String? userId, final String? bookingId}) = _$ParticipantStateImpl;
  const _ParticipantState._() : super._();

  factory _ParticipantState.fromJson(Map<String, dynamic> json) =
      _$ParticipantStateImpl.fromJson;

  @override
  String? get userId;
  @override
  String? get bookingId;

  /// Create a copy of ParticipantState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParticipantStateImplCopyWith<_$ParticipantStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
