import 'package:el_shaddai/core/constants/constants.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:el_shaddai/features/booking/presentations/booking_venues_component/booking_location_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class BookingHyrbidComponent extends ConsumerStatefulWidget {
  const BookingHyrbidComponent({
    super.key,
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  @override
  ConsumerState<BookingHyrbidComponent> createState() =>
      _BookingHybridComponentState();
}

class _BookingHybridComponentState
    extends ConsumerState<BookingHyrbidComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GooglePlaceAutoCompleteTextField(
          boxDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          countries: ['my'],
          isCrossBtnShown: true,
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (l) {
            setState(() {
              ref.read(targetNotifierProvider.notifier).setTarget(
                  LatLng(double.parse(l.lat!), double.parse(l.lng!)));
              ref
                  .read(bookingControllerProvider.notifier)
                  .setAddress(widget._controller.text);
              print(LatLng(double.parse(l.lat!), double.parse(l.lng!)));
              ref.read(bookingControllerProvider.notifier).setChords(
                  LatLng(double.parse(l.lat!), double.parse(l.lng!)));
            });
          },
          itemClick: (Prediction prediction) {
            widget._controller.text = prediction.description ?? "";
            widget._controller.selection = TextSelection.fromPosition(
                TextPosition(offset: prediction.description?.length ?? 0));
          },
          itemBuilder: (context, index, Prediction prediction) {
            if (widget._controller.text.isEmpty) return Container();
            if (index >= 3) return Container();
            return Container(
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.outline),
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(
                    width: 7,
                  ),
                  Expanded(child: Text("${prediction.description ?? ""}"))
                ],
              ),
            );
          },
          inputDecoration:
              const InputDecoration(focusedBorder: InputBorder.none),
          googleAPIKey: googleAPI,
          textEditingController: widget._controller,
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 300,
          height: 250,
          child: ref.watch(targetNotifierProvider) != null
              ? ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: ref.watch(targetNotifierProvider)!,
                      zoom: 13,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("1"),
                        position: ref.watch(targetNotifierProvider)!,
                      )
                    },
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  width: 300,
                  height: 250,
                ),
        )
      ],
    );
  }
}
