import 'dart:async';

import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shimmer/shimmer.dart';
import 'package:util/util.dart';

import '../controller/booking_controller.dart';

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

class GoogleMapComponent extends ConsumerStatefulWidget {
  const GoogleMapComponent({super.key});

  @override
  ConsumerState createState() => _GoogleMapComponentState();
}

class _GoogleMapComponentState extends ConsumerState<GoogleMapComponent> {
  final FocusNode _autoCompleteFocusNode = FocusNode();
  final Completer<GoogleMapController> _mapController = Completer();
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();

    // Use addPostFrameCallback to ensure the widget has been built and we can safely
    // access the ref to get the initial booking state.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initController();
      _setupListeners();
    });
  }

  void _initController() {
    final currentLocation =
        ref.read(bookingControllerProvider).location?.address ?? '';
    _textController.text = currentLocation;

    final chords = ref.read(bookingControllerProvider).location?.chords;
    if (chords != null) {
      if (mounted) {
        ref.read(targetNotifierProvider.notifier).setTarget(chords);
      }
    }
  }

  void _setupListeners() {
    // We only set up the listener AFTER the controller has been initialized with the current state.
    // This prevents the bug where the listener fires on the very first frame with an empty string.
    _textController.addListener(() {
      final newAddress = _textController.text.trim();
      final currentAddressInState = ref
          .read(bookingControllerProvider)
          .location
          ?.address;

      // Only update the state if the new address is different from the current state
      // This prevents redundant updates and the "revert to zoom" bug on initial focus.
      if (newAddress != currentAddressInState) {
        if (mounted) {
          ref.read(bookingControllerProvider.notifier).setAddress(newAddress);
        }
      }
    });
  }

  @override
  void dispose() {
    _autoCompleteFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Your existing build method...
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
              final newTarget = LatLng(
                double.parse(l.lat!),
                double.parse(l.lng!),
              );
              ref.read(targetNotifierProvider.notifier).setTarget(newTarget);

              // This is the correct place to update the address when a valid place is selected.
              ref
                  .read(bookingControllerProvider.notifier)
                  .setAddress(_textController.text);

              ref.read(bookingControllerProvider.notifier).setChords(newTarget);
              _updateCameraPosition(newTarget);
            },
            itemClick: (Prediction prediction) {
              _textController.text = prediction.description ?? "";
              _textController.selection = TextSelection.fromPosition(
                TextPosition(offset: prediction.description?.length ?? 0),
              );
            },
            itemBuilder: (context, index, Prediction prediction) {
              if (index >= 3) return Container();
              return Container(
                decoration: BoxDecoration(color: context.colors.outline),
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    const Icon(Icons.location_on),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        prediction.description ?? "",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
            inputDecoration: const InputDecoration(
              hintText: 'Enter Address',
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
            ),
            googleAPIKey: placesRestKey,
            textEditingController: _textController,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 500,
          height: 400,
          child: Builder(
            builder: (context) {
              final target = ref.watch(targetNotifierProvider);
              if (target != null) {
                return ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _mapController.complete(controller);
                      _updateCameraPosition(target);
                    },
                    initialCameraPosition: CameraPosition(
                      target: target,
                      zoom: 13,
                    ),
                    markers: {
                      Marker(markerId: const MarkerId("1"), position: target),
                    },
                  ),
                );
              } else {
                // WRAPPED WITH SHIMMER
                return Shimmer.fromColors(
                  baseColor: context.colors.tertiaryContainer.withOpac(0.6),
                  highlightColor: context.colors.tertiaryContainer.withOpac(
                    0.3,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: context.colors.tertiaryContainer.withOpac(0.6),
                    ),
                    width: 300,
                    height: 250,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> _updateCameraPosition(LatLng target) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newPosition = CameraPosition(target: target, zoom: 13);
    controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }
}
