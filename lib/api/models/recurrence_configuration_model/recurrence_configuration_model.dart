import 'package:el_shaddai/features/booking/state/booking_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recurrence_configuration_model.freezed.dart';
part 'recurrence_configuration_model.g.dart';

@freezed
class RecurrenceConfigurationModel with _$RecurrenceConfigurationModel {
  const RecurrenceConfigurationModel._();
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  factory RecurrenceConfigurationModel(
          {@JsonKey(name: 'end_times') required int recurrenceFrequency,
          int? weeklyDays,
          required int type,
          @JsonKey(name: 'repeat_interval') required int recurrenceInterval}) =
      _RecurrenceConfigurationModel;
  //if none then type 2, else 8

  factory RecurrenceConfigurationModel.fromJson(Map<String, dynamic> json) =>
      _$RecurrenceConfigurationModelFromJson(json);
}

enum Weekday {
  sun(1),
  mon(2),
  tue(3),
  wed(4),
  thu(5),
  fri(6),
  sat(7);

  final int value;
  const Weekday(this.value);

  // Optional: A method to get the enum from an integer
  static Weekday fromValue(int value) {
    return Weekday.values.firstWhere((day) => day.value == value,
        orElse: () => throw ArgumentError('Invalid weekday value: $value'));
  }

  static int toValue(Weekday day) => day.value;
  static Weekday fromDateTime(DateTime date) {
    switch (date.weekday) {
      case DateTime.sunday:
        return Weekday.sun;
      case DateTime.monday:
        return Weekday.mon;
      case DateTime.tuesday:
        return Weekday.tue;
      case DateTime.wednesday:
        return Weekday.wed;
      case DateTime.thursday:
        return Weekday.thu;
      case DateTime.friday:
        return Weekday.fri;
      case DateTime.saturday:
        return Weekday.sat;
      default:
        throw ArgumentError('Invalid DateTime: ${date.toIso8601String()}');
    }
  }
}
