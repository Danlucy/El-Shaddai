import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:el_shaddai/features/booking/state/booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';

class RecurrenceComponent extends ConsumerStatefulWidget {
  const RecurrenceComponent({super.key});

  @override
  ConsumerState createState() => _RecurrenceComponentState();
}

class _RecurrenceComponentState extends ConsumerState<RecurrenceComponent> {
  @override
  Widget build(BuildContext context) {
    final bookingFunction = ref.read(bookingControllerProvider.notifier);
    final bookingReader = ref.watch(bookingControllerProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Repeat',
              style: TextStyle(color: context.colors.secondary),
            ),
            const SizedBox(width: 10),
            ToggleButtons(
              selectedColor: context.colors.secondary,
              textStyle: TextStyle(
                fontSize: 16,
                color: context.colors.secondary,
              ),
              direction: Axis.vertical,
              isSelected: RecurrenceState.values
                  .map((e) => e == bookingReader.recurrenceState)
                  .toList(),
              onPressed: (int index) {
                setState(() {
                  bookingFunction
                      .setRecurrenceState(RecurrenceState.values[index]);
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              constraints: const BoxConstraints(
                  minHeight: 25, maxHeight: 35, minWidth: 80, maxWidth: 120),
              children: RecurrenceState.values
                  .map((key) => Text(
                        key.name.capitalize(),
                      ))
                  .toList(),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 80, maxWidth: 120),
              child: Container(
                height: 100,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF1f9cd49f))),
                child: SizedBox(
                  width: 50,
                  height: 60,
                  child: NumberPicker(
                    value: bookingReader.recurrenceFrequency,
                    minValue: 1,
                    maxValue: 60,
                    itemHeight: 30,
                    haptics: true,
                    onChanged: (value) {
                      bookingFunction.setRecurrenceFrequency(value);
                    },
                  ),
                ),
              ),
            ),
            Text(
              'Times',
              style: TextStyle(color: context.colors.secondary),
            )
          ],
        ),
      ),
    );
  }
}
