// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParticipantState {
  String? get userId;
  String? get bookingId;

  /// Create a copy of ParticipantState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ParticipantStateCopyWith<ParticipantState> get copyWith =>
      _$ParticipantStateCopyWithImpl<ParticipantState>(
          this as ParticipantState, _$identity);

  /// Serializes this ParticipantState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ParticipantState &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, bookingId);

  @override
  String toString() {
    return 'ParticipantState(userId: $userId, bookingId: $bookingId)';
  }
}

/// @nodoc
abstract mixin class $ParticipantStateCopyWith<$Res> {
  factory $ParticipantStateCopyWith(
          ParticipantState value, $Res Function(ParticipantState) _then) =
      _$ParticipantStateCopyWithImpl;
  @useResult
  $Res call({String? userId, String? bookingId});
}

/// @nodoc
class _$ParticipantStateCopyWithImpl<$Res>
    implements $ParticipantStateCopyWith<$Res> {
  _$ParticipantStateCopyWithImpl(this._self, this._then);

  final ParticipantState _self;
  final $Res Function(ParticipantState) _then;

  /// Create a copy of ParticipantState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? bookingId = freezed,
  }) {
    return _then(_self.copyWith(
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: freezed == bookingId
          ? _self.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ParticipantState].
extension ParticipantStatePatterns on ParticipantState {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ParticipantState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ParticipantState() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ParticipantState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParticipantState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ParticipantState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParticipantState() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String? userId, String? bookingId)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ParticipantState() when $default != null:
        return $default(_that.userId, _that.bookingId);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String? userId, String? bookingId) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParticipantState():
        return $default(_that.userId, _that.bookingId);
      case _:
        throw StateError('Unexpected subclass');
    }
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String? userId, String? bookingId)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParticipantState() when $default != null:
        return $default(_that.userId, _that.bookingId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ParticipantState extends ParticipantState {
  const _ParticipantState({this.userId, this.bookingId}) : super._();
  factory _ParticipantState.fromJson(Map<String, dynamic> json) =>
      _$ParticipantStateFromJson(json);

  @override
  final String? userId;
  @override
  final String? bookingId;

  /// Create a copy of ParticipantState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ParticipantStateCopyWith<_ParticipantState> get copyWith =>
      __$ParticipantStateCopyWithImpl<_ParticipantState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ParticipantStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ParticipantState &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, bookingId);

  @override
  String toString() {
    return 'ParticipantState(userId: $userId, bookingId: $bookingId)';
  }
}

/// @nodoc
abstract mixin class _$ParticipantStateCopyWith<$Res>
    implements $ParticipantStateCopyWith<$Res> {
  factory _$ParticipantStateCopyWith(
          _ParticipantState value, $Res Function(_ParticipantState) _then) =
      __$ParticipantStateCopyWithImpl;
  @override
  @useResult
  $Res call({String? userId, String? bookingId});
}

/// @nodoc
class __$ParticipantStateCopyWithImpl<$Res>
    implements _$ParticipantStateCopyWith<$Res> {
  __$ParticipantStateCopyWithImpl(this._self, this._then);

  final _ParticipantState _self;
  final $Res Function(_ParticipantState) _then;

  /// Create a copy of ParticipantState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = freezed,
    Object? bookingId = freezed,
  }) {
    return _then(_ParticipantState(
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: freezed == bookingId
          ? _self.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
