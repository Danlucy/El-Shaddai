import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class BookingTimePickerComponent extends ConsumerStatefulWidget {
  const BookingTimePickerComponent({super.key});

  @override
  ConsumerState<BookingTimePickerComponent> createState() =>
      _BookingTimePickerComponentState();
}

class _BookingTimePickerComponentState
    extends ConsumerState<BookingTimePickerComponent> {
  @override
  Widget build(BuildContext context) {
    final eventReader = ref.watch(bookingControllerProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _TimePickerLabel(
            time: eventReader.timeRange?.start,
            defaultLabel: 'Start Time',
            onTap: () => _showTimePickerDialog(
              context,
              onTimeSelected: (selectedTime) {
                ref
                    .read(bookingControllerProvider.notifier)
                    .setStartTime(selectedTime, context);
              },
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: Icon(Icons.access_time),
        ),
        const Icon(Icons.arrow_right_alt_outlined),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: Icon(Icons.access_time_filled),
        ),
        Expanded(
          child: _TimePickerLabel(
            time: eventReader.timeRange?.end,
            defaultLabel: 'End Time',
            onTap: () => _showTimePickerDialog(
              context,
              onTimeSelected: (selectedTime) {
                ref
                    .read(bookingControllerProvider.notifier)
                    .setEndTime(selectedTime, context);
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showTimePickerDialog(
    BuildContext context, {
    required Function(DateTime) onTimeSelected,
  }) {
    showDialog(
      barrierColor: Colors.black.withOpac(0.5),
      context: context,
      builder: (context) => TimePickerDialog(onTimeSelected: onTimeSelected),
    );
  }
}

/// ✅ **Abstracted Time Picker Label Widget**
class _TimePickerLabel extends StatelessWidget {
  const _TimePickerLabel({
    required this.time,
    required this.defaultLabel,
    required this.onTap,
  });

  final DateTime? time;
  final String defaultLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade600, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: AutoSizeText(
          time != null ? DateFormat.jm().format(time!) : defaultLabel,
          textAlign: TextAlign.center,
          minFontSize: 10,
          maxFontSize: 20,
          maxLines: 1,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

/// ✅ **Refactored Time Picker Dialog**
class TimePickerDialog extends StatefulWidget {
  const TimePickerDialog({required this.onTimeSelected, super.key});

  final Function(DateTime) onTimeSelected;

  @override
  _TimePickerDialogState createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<TimePickerDialog> {
  DateTime? selectedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TimePickerSpinner(
            time: selectedTime,
            is24HourMode: true,
            normalTextStyle: TextStyle(
                fontSize: 30, color: context.colors.tertiaryContainer),
            highlightedTextStyle:
                TextStyle(fontSize: 34, color: context.colors.tertiary),
            spacing: 50,
            itemHeight: 50,
            itemWidth: 60,
            alignment: Alignment.center,
            isForce2Digits: true,
            minutesInterval: 5,
            onTimeChange: (x) {
              setState(() {
                selectedTime = x;
              });
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const SizedBox(
                    width: 60, child: Center(child: Text('Cancel'))),
              ),
              const Gap(10),
              OutlinedButton(
                onPressed: () {
                  if (selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a time before setting."),
                      ),
                    );
                    return;
                  }
                  widget.onTimeSelected(selectedTime!);
                  Navigator.pop(context);
                },
                child: const SizedBox(
                    width: 60, child: Center(child: Text('Set'))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
