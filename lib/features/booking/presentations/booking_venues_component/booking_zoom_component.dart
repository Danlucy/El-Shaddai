import 'package:el_shaddai/api/api_repository.dart';
import 'package:el_shaddai/api/models/access_token_model/access_token_model.dart';
import 'package:el_shaddai/api/models/recurrence_configuration_model/recurrence_configuration_model.dart';
import 'package:el_shaddai/core/constants/constants.dart';
import 'package:el_shaddai/core/router/router.dart';
import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:el_shaddai/core/utility/failure.dart';
import 'package:el_shaddai/core/widgets/snack_bar.dart';
import 'package:el_shaddai/features/auth/presentations/zoom_screen.dart';
import 'package:el_shaddai/features/auth/widgets/loader.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:el_shaddai/features/booking/state/booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingZoomComponent extends ConsumerStatefulWidget {
  const BookingZoomComponent({super.key});

  @override
  _BookingZoomComponentState createState() => _BookingZoomComponentState();
}

class _BookingZoomComponentState extends ConsumerState<BookingZoomComponent> {
  @override
  Widget build(BuildContext context) {
    ref.watch(accessTokenNotifierProvider);
    final ApiRepository apiRepository = ApiRepository();
    final bookingFunction = ref.read(bookingControllerProvider.notifier);
    final bookingReader = ref.watch(bookingControllerProvider);
    return Column(
      children: [
        Builder(
          builder: (context) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Repeat',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        const SizedBox(width: 10),
                        ToggleButtons(
                          selectedColor:
                              Theme.of(context).colorScheme.secondary,
                          textStyle: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          direction: Axis.vertical,
                          isSelected: RecurrenceState.values
                              .map((e) => e == bookingReader.recurrenceState)
                              .toList(),
                          onPressed: (int index) {
                            setState(() {
                              bookingFunction.setRecurrenceState(
                                  RecurrenceState.values[index]);
                            });
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          constraints: const BoxConstraints(
                              minHeight: 25,
                              maxHeight: 35,
                              minWidth: 80,
                              maxWidth: 120),
                          children: RecurrenceState.values
                              .map((key) => Text(
                                    key.name.capitalize(),
                                  ))
                              .toList(),
                        ),
                        Expanded(
                          child: Container(
                            height: 100,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: const Color(0xFF1f9cd49f))),
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
                                  print(value);
                                  bookingFunction.setRecurrenceFrequency(value);
                                },
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Times',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
