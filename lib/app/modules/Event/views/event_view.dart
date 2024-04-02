import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';

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
                  DataColumn(label: Text('Id')),
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
                            DataCell(Text(event.id ?? '')),
                            DataCell(Text(event.eventName ?? '')),
                            DataCell(Text(event.eventDate?.toString() ?? '')),
                            DataCell(Text(event.eventLocation ?? '')),
                            DataCell(Text(event.eventTime ?? '')),
                            DataCell(Text(event.eventDescription ?? '')),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _eventController.editEvent(event.id!);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Delete Event'),
                                            content: const Text(
                                                'Are you sure you want to delete this event?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  _eventController
                                                      .deleteEvent(event.id!);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
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
          _showAddEventDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Event"),
          content: const SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Id'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Event Name'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Event Date'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Event Location'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Event Time'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Event Description'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () {
                // Add logic to save the event
                // For example, call a method in your controller
                // _eventController.saveEvent(event);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
