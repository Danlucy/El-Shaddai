// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurrence_configuration_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecurrenceConfigurationModel {
  @JsonKey(name: 'end_times')
  int get recurrenceFrequency => throw _privateConstructorUsedError;
  int? get weeklyDays => throw _privateConstructorUsedError;
  int get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'repeat_interval')
  int get recurrenceInterval => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecurrenceConfigurationModelCopyWith<RecurrenceConfigurationModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurrenceConfigurationModelCopyWith<$Res> {
  factory $RecurrenceConfigurationModelCopyWith(
          RecurrenceConfigurationModel value,
          $Res Function(RecurrenceConfigurationModel) then) =
      _$RecurrenceConfigurationModelCopyWithImpl<$Res,
          RecurrenceConfigurationModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'end_times') int recurrenceFrequency,
      int? weeklyDays,
      int type,
      @JsonKey(name: 'repeat_interval') int recurrenceInterval});
}

/// @nodoc
class _$RecurrenceConfigurationModelCopyWithImpl<$Res,
        $Val extends RecurrenceConfigurationModel>
    implements $RecurrenceConfigurationModelCopyWith<$Res> {
  _$RecurrenceConfigurationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recurrenceFrequency = null,
    Object? weeklyDays = freezed,
    Object? type = null,
    Object? recurrenceInterval = null,
  }) {
    return _then(_value.copyWith(
      recurrenceFrequency: null == recurrenceFrequency
          ? _value.recurrenceFrequency
          : recurrenceFrequency // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyDays: freezed == weeklyDays
          ? _value.weeklyDays
          : weeklyDays // ignore: cast_nullable_to_non_nullable
              as int?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      recurrenceInterval: null == recurrenceInterval
          ? _value.recurrenceInterval
          : recurrenceInterval // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecurrenceConfigurationModelImplCopyWith<$Res>
    implements $RecurrenceConfigurationModelCopyWith<$Res> {
  factory _$$RecurrenceConfigurationModelImplCopyWith(
          _$RecurrenceConfigurationModelImpl value,
          $Res Function(_$RecurrenceConfigurationModelImpl) then) =
      __$$RecurrenceConfigurationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'end_times') int recurrenceFrequency,
      int? weeklyDays,
      int type,
      @JsonKey(name: 'repeat_interval') int recurrenceInterval});
}

/// @nodoc
class __$$RecurrenceConfigurationModelImplCopyWithImpl<$Res>
    extends _$RecurrenceConfigurationModelCopyWithImpl<$Res,
        _$RecurrenceConfigurationModelImpl>
    implements _$$RecurrenceConfigurationModelImplCopyWith<$Res> {
  __$$RecurrenceConfigurationModelImplCopyWithImpl(
      _$RecurrenceConfigurationModelImpl _value,
      $Res Function(_$RecurrenceConfigurationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recurrenceFrequency = null,
    Object? weeklyDays = freezed,
    Object? type = null,
    Object? recurrenceInterval = null,
  }) {
    return _then(_$RecurrenceConfigurationModelImpl(
      recurrenceFrequency: null == recurrenceFrequency
          ? _value.recurrenceFrequency
          : recurrenceFrequency // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyDays: freezed == weeklyDays
          ? _value.weeklyDays
          : weeklyDays // ignore: cast_nullable_to_non_nullable
              as int?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      recurrenceInterval: null == recurrenceInterval
          ? _value.recurrenceInterval
          : recurrenceInterval // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable(createFactory: false)
class _$RecurrenceConfigurationModelImpl extends _RecurrenceConfigurationModel {
  _$RecurrenceConfigurationModelImpl(
      {@JsonKey(name: 'end_times') required this.recurrenceFrequency,
      this.weeklyDays,
      required this.type,
      @JsonKey(name: 'repeat_interval') required this.recurrenceInterval})
      : super._();

  @override
  @JsonKey(name: 'end_times')
  final int recurrenceFrequency;
  @override
  final int? weeklyDays;
  @override
  final int type;
  @override
  @JsonKey(name: 'repeat_interval')
  final int recurrenceInterval;

  @override
  String toString() {
    return 'RecurrenceConfigurationModel(recurrenceFrequency: $recurrenceFrequency, weeklyDays: $weeklyDays, type: $type, recurrenceInterval: $recurrenceInterval)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurrenceConfigurationModelImpl &&
            (identical(other.recurrenceFrequency, recurrenceFrequency) ||
                other.recurrenceFrequency == recurrenceFrequency) &&
            (identical(other.weeklyDays, weeklyDays) ||
                other.weeklyDays == weeklyDays) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.recurrenceInterval, recurrenceInterval) ||
                other.recurrenceInterval == recurrenceInterval));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, recurrenceFrequency, weeklyDays, type, recurrenceInterval);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurrenceConfigurationModelImplCopyWith<
          _$RecurrenceConfigurationModelImpl>
      get copyWith => __$$RecurrenceConfigurationModelImplCopyWithImpl<
          _$RecurrenceConfigurationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurrenceConfigurationModelImplToJson(
      this,
    );
  }
}

abstract class _RecurrenceConfigurationModel
    extends RecurrenceConfigurationModel {
  factory _RecurrenceConfigurationModel(
          {@JsonKey(name: 'end_times') required final int recurrenceFrequency,
          final int? weeklyDays,
          required final int type,
          @JsonKey(name: 'repeat_interval')
          required final int recurrenceInterval}) =
      _$RecurrenceConfigurationModelImpl;
  _RecurrenceConfigurationModel._() : super._();

  @override
  @JsonKey(name: 'end_times')
  int get recurrenceFrequency;
  @override
  int? get weeklyDays;
  @override
  int get type;
  @override
  @JsonKey(name: 'repeat_interval')
  int get recurrenceInterval;
  @override
  @JsonKey(ignore: true)
  _$$RecurrenceConfigurationModelImplCopyWith<
          _$RecurrenceConfigurationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
