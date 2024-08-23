import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:el_shaddai/core/widgets/snack_bar.dart';
import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/event/controller/event_controller.dart';
import 'package:el_shaddai/features/event/repository/event_repository.dart';
import 'package:el_shaddai/models/event_model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:intl/intl.dart';

import 'event_venues_component/event_location_component.dart';

class EventsDialog extends ConsumerStatefulWidget {
  const EventsDialog({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  ConsumerState<EventsDialog> createState() => _EventsDialogState();
}

class _EventsDialogState extends ConsumerState<EventsDialog> {
  static final formKey = GlobalKey<FormState>();
  void show(data) {
    showFailureSnackBar(context, data);
  }

  final TextEditingController _controller = TextEditingController();
  final List<bool> _selectedLocation = <bool>[true, false, false];
  @override
  Widget build(BuildContext context) {
    ref.watch(eventControllerProvider);
    final eventFunction = ref.read(eventControllerProvider.notifier);
    final eventReader = ref.watch(eventControllerProvider);
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      insetPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      content: Container(
        padding: EdgeInsets.zero,
        width: widget.width * 0.8,
        height: widget.height * 0.85,
        child: ListView(
          children: [
            const Text(
              'Create Your Prayer Session',
              style: TextStyle(fontSize: 20),
            ),
            SfDateRangePicker(
              initialDisplayDate: DateTime.now(),
              enablePastDates: false,
              headerStyle: DateRangePickerHeaderStyle(
                textAlign: TextAlign.start,
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
              ),
              monthCellStyle: DateRangePickerMonthCellStyle(
                blackoutDateTextStyle: TextStyle(
                  color: Colors.redAccent.withOpacity(0.4),
                ),
                cellDecoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  border: Border.all(color: Colors.white24),
                ),
              ),
              monthViewSettings: const DateRangePickerMonthViewSettings(),
              view: DateRangePickerView.month,
              onSelectionChanged: (d) {
                final value = d.value;

                if (value is PickerDateRange) {
                  if (value.endDate != null) {
                    eventFunction.setDateRange(DateTimeRange(
                        start: value.startDate!, end: value.endDate!));
                  } else {
                    eventFunction.setDateRange(DateTimeRange(
                        start: value.startDate!, end: value.startDate!));
                  }
                } else {
                  if (value is DateTimeRange) {
                    print('sigma');
                    eventFunction.setDateRange(
                        DateTimeRange(start: value.start, end: value.end));
                  }
                }
              },
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              selectionMode: DateRangePickerSelectionMode.range,
            ),
            GestureDetector(
              onTap: () {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                sleep(const Duration(milliseconds: 100));
                _controller.clear();
                showTimeRangePicker(
                  start: eventReader.timeRange?.start != null
                      ? TimeOfDay.fromDateTime(
                          ref.read(eventControllerProvider).timeRange!.start)
                      : const TimeOfDay(hour: 6, minute: 0),
                  end: eventReader.timeRange?.end != null
                      ? TimeOfDay.fromDateTime(
                          ref.read(eventControllerProvider).timeRange!.end)
                      : const TimeOfDay(hour: 18, minute: 0),
                  use24HourFormat: false,
                  context: context,
                  minDuration: const Duration(hours: 1),
                  interval: const Duration(hours: 1),
                  handlerColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  labels: [
                    '12 AM',
                    '3 AM',
                    '6 AM',
                    '9 AM',
                    '12 PM',
                    '3 PM',
                    '6 PM',
                    '9 PM'
                  ].asMap().entries.map((e) {
                    return ClockLabel.fromIndex(
                      idx: e.key,
                      length: 8,
                      text: e.value,
                    );
                  }).toList(),
                  ticks: 12,
                ).then((value) {
                  if (value != null) {
                    print(value);

                    eventFunction.setTimeRange(value);
                  }
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(10),
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    child: Text(
                      eventReader.timeRange?.start != null
                          ? DateFormat.jm().format(ref
                              .read(eventControllerProvider)
                              .timeRange!
                              .start)
                          : 'Start Time',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Icon(
                      Icons.access_time,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Icon(Icons.arrow_right_alt_outlined),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Icon(
                      Icons.access_time_filled,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(10),
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    child: Text(
                      eventReader.timeRange?.end != null
                          ? DateFormat.jm().format(
                              ref.read(eventControllerProvider).timeRange!.end)
                          : 'End Time',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    ToggleButtons(
                      isSelected: _selectedLocation,
                      onPressed: (int index) {
                        setState(() {
                          // The button that is tapped is set to true, and the others to false.
                          for (int i = 0; i < _selectedLocation.length; i++) {
                            _selectedLocation[i] = i == index;
                          }
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      constraints: const BoxConstraints(
                        minHeight: 25,
                        maxHeight: 35,
                        minWidth: 100,
                      ),
                      children: [
                        const Text('Zoom'),
                        const Text('Location'),
                        const Text('Hybrid')
                      ],
                    ),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxHeight: 600, minHeight: 300),
                      child: _selectedLocation[0]
                          ? const Text('Zoom')
                          : _selectedLocation[1]
                              ? EventLocationComponent(controller: _controller)
                              : const Text('Hybrid'),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  final raw = value ?? '';
                  if (raw.isEmpty) {
                    return 'Field cannot be empty';
                  }
                  return null;
                },
                onChanged: eventFunction.setTitle,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Title'),
              ),
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                final raw = value ?? '';
                if (raw.isEmpty) {
                  return 'Field cannot be empty';
                }
                return null;
              },
              onChanged: eventFunction.setDescription,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Description',
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  ref.read(eventRepositoryProvider).createEvent(
                      EventModel(
                          title: eventReader.title!,
                          hostId: ref.read(userProvider)!.uid,
                          timeRange: eventReader.timeRange!,
                          userId: ref.read(userProvider)!.uid,
                          id: FirebaseFirestore.instance
                              .collection('dog')
                              .doc()
                              .id,
                          location: eventReader.location!,
                          description: eventReader.description!), (data) {
                    show(data);
                  });
                },
                child: const Text('Create Event'))
          ],
        ),
      ),
    );
  }
}
