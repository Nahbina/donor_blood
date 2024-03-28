import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import '../../../models/Event.dart';

class EventView extends StatefulWidget {
  const EventView({Key? key}) : super(key: key);

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  final EventController _eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          if (_eventController.events.isEmpty) {
            return const CircularProgressIndicator();
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Event Name')),
                  DataColumn(label: Text('Event Date')),
                  DataColumn(label: Text('Event Location')),
                  DataColumn(label: Text('Event Time')),
                  DataColumn(label: Text('Event Description')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _eventController.events
                    .map((event) => DataRow(
                          cells: [
                            DataCell(Text(event.eventName ?? '')),
                            DataCell(Text(event.eventDate?.toString() ?? '')),
                            DataCell(Text(event.eventLocation ?? '')),
                            DataCell(Text(event.eventTime ?? '')),
                            DataCell(Text(event.eventDescription ?? '')),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      _eventController
                                          .editEvent(event.eventId!);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _eventController
                                          .deleteEvent(event.eventId!);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add event screen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
