import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mobile/api/models/access_token_model/access_token_model.dart';
import 'package:mobile/features/booking/controller/booking_controller.dart';

import 'booking_location_component/booking_location_component.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth),
              child: const ZoomDisplayComponent(),
            ),
            const Gap(8),
            GoogleMapComponent(widget.googleController),
          ],
        );
      },
    );
  }
}

class ZoomDisplayComponent extends ConsumerWidget {
  const ZoomDisplayComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isSignedIn = ref.watch(accessTokenNotifierProvider).value != null;
    print(ref.watch(accessTokenNotifierProvider).value);
    print(isSignedIn);
    return Container(
      padding: const EdgeInsets.only(right: 15, top: 2, bottom: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: context.colors.tertiaryContainer,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 20,
              backgroundImage: AssetImage('assets/zoom.png'),
            ),
          ),
          IntrinsicWidth(
            stepWidth: 50,
            child: TextFormField(
              onChanged: (x) {
                ref.read(bookingControllerProvider.notifier).setWeb(x);
              },
              maxLength: 11,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (!isSignedIn && (value == null || value.isEmpty)) {
                  return 'Zoom ID is required';
                }
                if (value != null &&
                    value.isNotEmpty &&
                    !RegExp(r'^\d{10,11}$').hasMatch(value)) {
                  return 'Zoom ID must be 10 or 11 digits';
                }
                return null;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 16, letterSpacing: 1),
                hintText: isSignedIn ? 'Auto Zoom ID' : 'Enter Zoom ID',
                counterText: '', // Hides character counter
              ),
              style: const TextStyle(
                fontSize: 16,
                letterSpacing: 4, // Add spacing between characters
              ),
            ),
          ),
        ],
      ),
    );
  }
}
