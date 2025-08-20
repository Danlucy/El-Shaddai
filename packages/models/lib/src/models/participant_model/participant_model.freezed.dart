// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParticipantModel {
  String get bookingId;
  List<String> get participantsId;

  /// Create a copy of ParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ParticipantModelCopyWith<ParticipantModel> get copyWith =>
      _$ParticipantModelCopyWithImpl<ParticipantModel>(
          this as ParticipantModel, _$identity);

  /// Serializes this ParticipantModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ParticipantModel &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            const DeepCollectionEquality()
                .equals(other.participantsId, participantsId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bookingId,
      const DeepCollectionEquality().hash(participantsId));

  @override
  String toString() {
    return 'ParticipantModel(bookingId: $bookingId, participantsId: $participantsId)';
  }
}

/// @nodoc
abstract mixin class $ParticipantModelCopyWith<$Res> {
  factory $ParticipantModelCopyWith(
          ParticipantModel value, $Res Function(ParticipantModel) _then) =
      _$ParticipantModelCopyWithImpl;
  @useResult
  $Res call({String bookingId, List<String> participantsId});
}

/// @nodoc
class _$ParticipantModelCopyWithImpl<$Res>
    implements $ParticipantModelCopyWith<$Res> {
  _$ParticipantModelCopyWithImpl(this._self, this._then);

  final ParticipantModel _self;
  final $Res Function(ParticipantModel) _then;

  /// Create a copy of ParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
    Object? participantsId = null,
  }) {
    return _then(_self.copyWith(
      bookingId: null == bookingId
          ? _self.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      participantsId: null == participantsId
          ? _self.participantsId
          : participantsId // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [ParticipantModel].
extension ParticipantModelPatterns on ParticipantModel {
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
    TResult Function(_ParticipantModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ParticipantModel() when $default != null:
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
    TResult Function(_ParticipantModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParticipantModel():
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
    TResult? Function(_ParticipantModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParticipantModel() when $default != null:
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
    TResult Function(String bookingId, List<String> participantsId)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ParticipantModel() when $default != null:
        return $default(_that.bookingId, _that.participantsId);
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
    TResult Function(String bookingId, List<String> participantsId) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParticipantModel():
        return $default(_that.bookingId, _that.participantsId);
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
    TResult? Function(String bookingId, List<String> participantsId)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParticipantModel() when $default != null:
        return $default(_that.bookingId, _that.participantsId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ParticipantModel extends ParticipantModel {
  const _ParticipantModel(
      {required this.bookingId, required final List<String> participantsId})
      : _participantsId = participantsId,
        super._();
  factory _ParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$ParticipantModelFromJson(json);

  @override
  final String bookingId;
  final List<String> _participantsId;
  @override
  List<String> get participantsId {
    if (_participantsId is EqualUnmodifiableListView) return _participantsId;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantsId);
  }

  /// Create a copy of ParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ParticipantModelCopyWith<_ParticipantModel> get copyWith =>
      __$ParticipantModelCopyWithImpl<_ParticipantModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ParticipantModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ParticipantModel &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            const DeepCollectionEquality()
                .equals(other._participantsId, _participantsId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bookingId,
      const DeepCollectionEquality().hash(_participantsId));

  @override
  String toString() {
    return 'ParticipantModel(bookingId: $bookingId, participantsId: $participantsId)';
  }
}

/// @nodoc
abstract mixin class _$ParticipantModelCopyWith<$Res>
    implements $ParticipantModelCopyWith<$Res> {
  factory _$ParticipantModelCopyWith(
          _ParticipantModel value, $Res Function(_ParticipantModel) _then) =
      __$ParticipantModelCopyWithImpl;
  @override
  @useResult
  $Res call({String bookingId, List<String> participantsId});
}

/// @nodoc
class __$ParticipantModelCopyWithImpl<$Res>
    implements _$ParticipantModelCopyWith<$Res> {
  __$ParticipantModelCopyWithImpl(this._self, this._then);

  final _ParticipantModel _self;
  final $Res Function(_ParticipantModel) _then;

  /// Create a copy of ParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? bookingId = null,
    Object? participantsId = null,
  }) {
    return _then(_ParticipantModel(
      bookingId: null == bookingId
          ? _self.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      participantsId: null == participantsId
          ? _self._participantsId
          : participantsId // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
