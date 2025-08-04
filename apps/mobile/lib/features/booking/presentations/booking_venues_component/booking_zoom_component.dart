import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/booking/widgets/zoom_display_widget.dart';

import '../../../../api/models/access_token_model/access_token_model.dart';
import 'booking_hybrid_component.dart';

class BookingZoomComponent extends ConsumerStatefulWidget {
  const BookingZoomComponent({
    this.zoomID,
    this.password,
    super.key,
  });
  final String? zoomID;
  final String? password;

  @override
  _BookingZoomComponentState createState() => _BookingZoomComponentState();
}

class _BookingZoomComponentState extends ConsumerState<BookingZoomComponent> {
  @override
  Widget build(BuildContext context) {
    ref.watch(accessTokenNotifierProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min, // Set to min to limit size
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth),
              child: Builder(
                builder: (context) {
                  return const ZoomDisplayComponent();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
