import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventHybridComponent extends ConsumerStatefulWidget {
  const EventHybridComponent({
    super.key,
  });

  @override
  ConsumerState<EventHybridComponent> createState() =>
      _EventHybridComponentState();
}

class _EventHybridComponentState extends ConsumerState<EventHybridComponent> {
  @override
  Widget build(BuildContext context) {
    return const Text('Hybrid');
  }
}
