import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/features/booking/presentations/booking_venues_component/booking_location_component/booking_location_component.dart';
import 'package:el_shaddai/features/booking/widgets/recurrence_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingHyrbidComponent extends ConsumerStatefulWidget {
  const BookingHyrbidComponent({super.key, required this.googleController});

  @override
  ConsumerState<BookingHyrbidComponent> createState() =>
      _BookingHybridComponentState();
  final TextEditingController googleController;
}

class _BookingHybridComponentState
    extends ConsumerState<BookingHyrbidComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: context.colors.primary,
          radius: 25,
          backgroundImage: const AssetImage('assets/zoom.png'),
        ),
        const RecurrenceComponent(),
        GoogleMapComponent(widget.googleController)
      ],
    );
  }
}
