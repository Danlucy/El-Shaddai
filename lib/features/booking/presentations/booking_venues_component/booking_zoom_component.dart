import 'package:el_shaddai/api/api_repository.dart';
import 'package:el_shaddai/api/models/access_token_model/access_token_model.dart';
import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:el_shaddai/features/booking/widgets/recurrence_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                CircleAvatar(
                  backgroundColor: context.colors.primary,
                  radius: 25,
                  backgroundImage: const AssetImage('assets/zoom.png'),
                ),
                const RecurrenceComponent()
              ],
            );
          },
        ),
      ],
    );
  }
}
