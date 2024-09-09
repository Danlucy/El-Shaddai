import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:el_shaddai/api/api_repository.dart';
import 'package:el_shaddai/api/models/access_token_model.dart';
import 'package:el_shaddai/api/models/recurrence_configuration_model.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class BookingZoomComponent extends ConsumerStatefulWidget {
  @override
  _BookingZoomComponentState createState() => _BookingZoomComponentState();
}

class _BookingZoomComponentState extends ConsumerState<BookingZoomComponent> {
  final ValueNotifier<String?> userAuthenticationToken =
      ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    _loadUserAuthenticationToken();
    _startTokenListener();
  }

  Future<void> _loadUserAuthenticationToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userAuthenticationToken.value = prefs.getString('userAuthenticationCode');
  }

  void _startTokenListener() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Periodically check for changes in the token
    while (true) {
      await Future.delayed(
          const Duration(seconds: 5)); // Adjust the interval as needed
      String? newToken = prefs.getString('userAuthenticationCode');
      if (newToken != userAuthenticationToken.value) {
        userAuthenticationToken.value = newToken; // Update the notifier
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(accessTokenNotifierProvider);
    final ApiRepository apiRepository = ApiRepository();
    return Column(
      children: [
        ValueListenableBuilder<String?>(
          valueListenable: userAuthenticationToken,
          builder: (context, token, child) {
            return Column(
              children: [
                if (token == null) // If token is null, show the button
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        const ZoomRoute(zoomLoginRoute).push(context);
                      } catch (e, s) {
                        print('Error getting authorization code: $e $s');
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Image.asset(
                        'assets/logo/zoom.png',
                        width: 150,
                        height: 30,
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    height: 100,
                    child: Row(
                      children: [
                        ToggleButtons(
                          direction: Axis.vertical,
                          isSelected: RecurrenceState.values
                              .map((e) =>
                                  e ==
                                  ref
                                      .read(bookingControllerProvider)
                                      .recurrenceState)
                              .toList(),
                          onPressed: (int index) {
                            setState(() {
                              ref
                                  .read(bookingControllerProvider.notifier)
                                  .setRecurrenceState(
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
                            margin:
                                EdgeInsets.only(left: 5, bottom: 10, top: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Color(0xFF1f9cd49f))),
                            child: Row(
                              children: [
                                // Wrap(
                                //   children: Weekday.values.map((day) {
                                //     return Padding(
                                //       padding: const EdgeInsets.symmetric(
                                //           horizontal: 5),
                                //       child: FilterChip(
                                //         label: Text(day.name.capitalize()),
                                //         selected: ref
                                //             .read(bookingControllerProvider)
                                //             .weeklyDays
                                //             .contains(day),
                                //         onSelected: (bool selected) {
                                //           setState(() {
                                //             ref
                                //                 .read(bookingControllerProvider
                                //                     .notifier)
                                //                 .toggleWeeklyDay(day);
                                //           });
                                //         },
                                //       ),
                                //     );
                                //   }).toList(),
                                // ),
                                VerticalDivider(),
                                SizedBox(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: 'How Many Times?'),
                                  ),
                                  height: 20,
                                  width: 80,
                                )
                              ],
                            ),
                          ),
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
