import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/features/booking/presentations/booking_venues_component/booking_location_component/booking_location_component.dart';
import 'package:el_shaddai/features/booking/widgets/recurrence_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

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
        const ZoomDisplayComponent(),
        const Gap(8),
        GoogleMapComponent(widget.googleController),
      ],
    );
  }
}

class ZoomDisplayComponent extends StatelessWidget {
  const ZoomDisplayComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: context.colors.tertiaryContainer,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: context.colors.primary,
            radius: 15,
            backgroundImage: const AssetImage('assets/zoom.png'),
          ),
          const Text(
            ' Zoom Meeting',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
