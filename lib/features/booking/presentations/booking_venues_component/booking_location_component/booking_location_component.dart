import 'package:el_shaddai/core/constants/constants.dart';
import 'package:el_shaddai/core/customs/custom_google_auto_complete.dart';
import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_location_component.g.dart';

@riverpod
class TargetNotifier extends _$TargetNotifier {
  @override
  LatLng? build() {
    return null; // Initial state: no target selected
  }

  void setTarget(LatLng target) {
    state = target;
  }
}

class BookingLocationComponent extends ConsumerStatefulWidget {
  const BookingLocationComponent(
    this.googleController,
    this.context, {
    super.key,
  });

  final TextEditingController googleController;
  final BuildContext context;

  @override
  ConsumerState<BookingLocationComponent> createState() =>
      _BookingLocationComponentState();
}

class _BookingLocationComponentState
    extends ConsumerState<BookingLocationComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GoogleMapComponent(widget.googleController),
      ],
    );
  }
}

class GoogleMapComponent extends ConsumerStatefulWidget {
  const GoogleMapComponent(this.googleController, {super.key});
  final TextEditingController googleController;
  @override
  ConsumerState createState() => _GoogleMapComponentState();
}

class _GoogleMapComponentState extends ConsumerState<GoogleMapComponent> {
  final FocusNode _autoCompleteFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: CustomGooglePlaceAutoCompleteTextField(
            context: context,
            focusNode: _autoCompleteFocusNode,
            countries: const ['my'],
            isCrossBtnShown: true,
            showError: false,
            containerHorizontalPadding: 5,
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (l) {
              setState(() {
                ref.read(targetNotifierProvider.notifier).setTarget(
                    LatLng(double.parse(l.lat!), double.parse(l.lng!)));
                ref
                    .read(bookingControllerProvider.notifier)
                    .setAddress(widget.googleController.text);
                // print(LatLng(double.parse(l.lat!), double.parse(l.lng!)));
                ref.read(bookingControllerProvider.notifier).setChords(
                    LatLng(double.parse(l.lat!), double.parse(l.lng!)));
              });
            },
            itemClick: (Prediction prediction) {
              widget.googleController.text = prediction.description ?? "";
              widget.googleController.selection = TextSelection.fromPosition(
                  TextPosition(offset: prediction.description?.length ?? 0));
            },
            itemBuilder: (context, index, Prediction prediction) {
              if (index >= 3) return Container();
              return Container(
                decoration: BoxDecoration(color: context.colors.outline),
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    const Icon(Icons.location_on),
                    const SizedBox(
                      width: 7,
                    ),
                    Expanded(
                        child: Text(
                      prediction.description ?? "",
                      style: TextStyle(fontSize: 12),
                    ))
                  ],
                ),
              );
            },
            inputDecoration: const InputDecoration(
                hintText: 'Enter Address',
                focusedBorder: InputBorder.none,
                border: InputBorder.none),
            googleAPIKey: googleAPI,
            textEditingController: widget.googleController,
          ),
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
                    color: context.colors.tertiaryContainer,
                  ),
                  width: 300,
                  height: 250,
                ),
        )
      ],
    );
  }
}
