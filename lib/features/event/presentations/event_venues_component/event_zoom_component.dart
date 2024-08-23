import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventZoomComponent extends ConsumerStatefulWidget {
  const EventZoomComponent({
    super.key,
  });

  @override
  ConsumerState<EventZoomComponent> createState() => _EventZoomComponentState();
}

class _EventZoomComponentState extends ConsumerState<EventZoomComponent> {
  @override
  Widget build(BuildContext context) {
    return const Text('Zoom');
  }
}
