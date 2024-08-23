import 'package:el_shaddai/features/event/controller/event_controller.dart';
import 'package:el_shaddai/features/event/presentations/event_dialog.dart';
import 'package:el_shaddai/features/home/widgets/general_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(eventControllerProvider.notifier).clearState();
          showDialog(
              context: context,
              builder: (context) => EventsDialog(width: width, height: height));
        },
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      appBar: AppBar(title: const Text('Prayer Events')),
      drawer: GeneralDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [],
      ),
    );
  }
}
