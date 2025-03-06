import 'package:el_shaddai/api/models/access_token_model/access_token_model.dart';
import 'package:el_shaddai/features/booking/presentations/booking_venues_component/booking_hybrid_component.dart';
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
    return Column(
      children: [
        Builder(
          builder: (context) {
            return const Column(
              children: [
                ZoomDisplayComponent(),
              ],
            );
          },
        ),
      ],
    );
  }
}
