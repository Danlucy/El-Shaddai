import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class EventLocationComponent extends StatelessWidget {
  const EventLocationComponent({
    super.key,
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: GooglePlaceAutoCompleteTextField(
            boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            countries: ['my'],
            isCrossBtnShown: true,
            itemClick: (Prediction prediction) {
              print('da');
              _controller.text = prediction.description ?? "";
              _controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: prediction.description?.length ?? 0));
            },
            itemBuilder: (context, index, Prediction prediction) {
              if (_controller.text.isEmpty) return Container();
              if (index >= 3) return Container();
              return Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).colorScheme.outline),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(
                      width: 7,
                    ),
                    Expanded(child: Text("${prediction.description ?? ""}"))
                  ],
                ),
              );
            },
            inputDecoration: InputDecoration(focusedBorder: InputBorder.none),
            googleAPIKey: 'AIzaSyB7yJR6X1DOKCmmHwH4wI0TXXhMAVxyV0g',
            textEditingController: _controller,
          ),
        ),
      ],
    );
  }
}
