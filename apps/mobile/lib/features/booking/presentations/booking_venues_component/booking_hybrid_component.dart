import 'dart:ui'; // Import for ImageFilter

import 'package:constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mobile/api/models/access_token_model/access_token_model.dart';
import 'package:mobile/features/booking/controller/booking_controller.dart'; // Your controller
import 'package:mobile/features/booking/widgets/zoom_display_widget.dart';
import 'package:mobile/models/location_data.dart'; // Import LocationData if it's separate

import '../../../../core/utility/url_launcher.dart';
import 'booking_location_component/booking_location_component.dart';

// Helper functions to parse/combine the 'web' string
class BookingHyrbidComponent extends ConsumerStatefulWidget {
  const BookingHyrbidComponent({
    this.password,
    this.zoomID,
    super.key,
    required this.googleController,
  });
  final String? zoomID;
  final String? password;
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
              child: const ZoomDisplayComponent(), // No webData prop
            ),
            const Gap(8),
            GoogleMapComponent(widget.googleController),
          ],
        );
      },
    );
  }
}
