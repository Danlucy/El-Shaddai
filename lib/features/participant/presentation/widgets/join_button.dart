import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:el_shaddai/features/participant/participant_controller/participant_controller.dart';
import 'package:el_shaddai/features/participant/participant_repository/participant_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinButton extends ConsumerStatefulWidget {
  const JoinButton({
    super.key,
    required this.bookingId,
  });
  final String bookingId;
  @override
  ConsumerState createState() => _JoinButtonState();
}

class _JoinButtonState extends ConsumerState<JoinButton> {
  @override
  Widget build(BuildContext context) {
    final participantController =
        ref.watch(participantControllerProvider(widget.bookingId).notifier);
    final user = ref.watch(userProvider);
    return Align(
        alignment: Alignment.center,
        child: FutureBuilder(
          builder: (context, snapshot) {
            return ElevatedButton(
                onPressed: () {
                  try {
                    if (user != null) {
                      participantController.addParticipant();
                    } else {
                      throw "User unavailable, check Internet connection";
                    }
                  } catch (e) {
                    throw e.toString();
                  }
                },
                child: const Text('Join'));
          },
          future: null,
        ));
  }
}
