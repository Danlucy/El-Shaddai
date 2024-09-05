import 'dart:io';

import 'package:el_shaddai/core/widgets/snack_bar.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:el_shaddai/features/booking/presentations/booking_venues_component/booking_hybrid_component.dart';
import 'package:el_shaddai/features/booking/presentations/booking_venues_component/booking_location_component.dart';
import 'package:el_shaddai/features/booking/presentations/booking_venues_component/booking_zoom_component.dart';
import 'package:el_shaddai/features/booking/widgets/booking_book_button.dart';
import 'package:el_shaddai/features/booking/widgets/booking_date_range_picker.dart';
import 'package:el_shaddai/features/booking/widgets/booking_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_range_picker/time_range_picker.dart';

class BookingDialog extends ConsumerStatefulWidget {
  const BookingDialog({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  ConsumerState<BookingDialog> createState() => _EventsDialogState();
}

class _EventsDialogState extends ConsumerState<BookingDialog> {
  static final formKey = GlobalKey<FormState>();
  void show(data) {
    showFailureSnackBar(context, data);
  }

  final TextEditingController _googleController = TextEditingController();
  final Map<String, bool> _selectedLocation = {
    'Zoom': true,
    'Location': false,
    'Hybrid': false
  };
  Widget _buildSelectedComponent() {
    if (_selectedLocation['Zoom']!) {
      return BookingZoomComponent();
    } else if (_selectedLocation['Location']!) {
      return BookingLocationComponent(_googleController);
    } else if (_selectedLocation['Hybrid']!) {
      return BookingHyrbidComponent(controller: _googleController);
    } else {
      return const SizedBox.shrink(); // In case none is selected
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(bookingControllerProvider);
    final eventFunction = ref.read(bookingControllerProvider.notifier);
    final eventReader = ref.watch(bookingControllerProvider);

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
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const Text(
                'Create Your Prayer Time',
                style: TextStyle(fontSize: 20),
              ),
              BookingDateRangePickerComponent(),
              BookingTimePickerComponent(
                controller: _googleController,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      ToggleButtons(
                        isSelected: _selectedLocation.values.toList(),
                        onPressed: (int index) {
                          setState(() {
                            // Reset all values to false
                            _selectedLocation.updateAll((key, value) => false);
                            // Set the selected index to true
                            _selectedLocation[
                                _selectedLocation.keys.elementAt(index)] = true;
                          });
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        constraints: const BoxConstraints(
                            minHeight: 25,
                            maxHeight: 35,
                            minWidth: 80,
                            maxWidth: 120),
                        children: _selectedLocation.keys
                            .map((key) => Text(key))
                            .toList(),
                      ),
                      _buildSelectedComponent()
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
                      return 'Enter a Title';
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
                    return 'Enter a Description';
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
              BookButton(
                  formKey: formKey,
                  errorCall: (x) {
                    show(x);
                  }),
              IconButton(
                  onPressed: () {
                    print(
                        ref.read(bookingControllerProvider).location!.address);
                    print(ref.read(bookingControllerProvider).location!.chords);
                    print(ref.read(bookingControllerProvider).location!.web);
                  },
                  icon: const Icon(Icons.close))
            ],
          ),
        ),
      ),
    );
  }
}
