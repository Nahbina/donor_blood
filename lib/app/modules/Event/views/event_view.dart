import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/Event.dart';
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
      body: Obx(() {
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditEventPage(event: event),
                                      ),
                                    );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) async {
    TextEditingController idController = TextEditingController();
    TextEditingController eventNameController = TextEditingController();
    TextEditingController eventDateController = TextEditingController();
    TextEditingController eventLocationController = TextEditingController();
    TextEditingController eventTimeController = TextEditingController();
    TextEditingController eventDescriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Event"),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: idController,
                  decoration: InputDecoration(labelText: 'Id'),
                ),
                TextField(
                  controller: eventNameController,
                  decoration: InputDecoration(labelText: 'Event Name'),
                ),
                TextFormField(
                  controller: eventDateController,
                  decoration: InputDecoration(labelText: 'Event Date'),
                  keyboardType: TextInputType.datetime,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      // Format the picked date as 'yyyy-MM-dd' before setting it to the text field
                      eventDateController.text =
                          pickedDate.toString().substring(0, 10);
                    }
                  },
                ),
                TextFormField(
                  controller: eventTimeController,
                  decoration: InputDecoration(labelText: 'Event Time'),
                  keyboardType: TextInputType.datetime,
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      // Format the picked time as 'HH:mm' before setting it to the text field
                      eventTimeController.text = pickedTime.format(context);
                    }
                  },
                ),
                TextField(
                  controller: eventLocationController,
                  decoration: InputDecoration(labelText: 'Event Location'),
                ),
                TextField(
                  controller: eventDescriptionController,
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
              onPressed: () async {
                Event newEvent = Event(
                  id: idController.text,
                  eventName: eventNameController.text,
                  eventDate: DateTime.parse(eventDateController.text),
                  eventLocation: eventLocationController.text,
                  eventTime: eventTimeController.text,
                  eventDescription: eventDescriptionController.text,
                );
                // Call the addEvent function to store the new event
                await _eventController.addEvent(newEvent);
                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class EditEventPage extends StatefulWidget {
  final Event event;

  EditEventPage({Key? key, required this.event}) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  late EventController _eventController;
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventDateController = TextEditingController();
  TextEditingController eventLocationController = TextEditingController();
  TextEditingController eventTimeController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _eventController = Get.find<EventController>();
    eventNameController.text = widget.event.eventName ?? '';
    eventDateController.text = widget.event.eventDate?.toString() ?? '';
    eventLocationController.text = widget.event.eventLocation ?? '';
    eventTimeController.text = widget.event.eventTime ?? '';
    eventDescriptionController.text = widget.event.eventDescription ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: eventNameController,
                decoration: InputDecoration(labelText: 'Event Name'),
              ),
              TextFormField(
                controller: eventDateController,
                decoration: InputDecoration(labelText: 'Event Date'),
                keyboardType: TextInputType.datetime,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: widget.event.eventDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      eventDateController.text = pickedDate.toString();
                    });
                  }
                },
              ),
              TextFormField(
                controller: eventTimeController,
                decoration: InputDecoration(labelText: 'Event Time'),
                keyboardType: TextInputType.datetime,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      eventTimeController.text = pickedTime.format(context);
                    });
                  }
                },
              ),
              TextField(
                controller: eventLocationController,
                decoration: InputDecoration(labelText: 'Event Location'),
              ),
              TextField(
                controller: eventDescriptionController,
                decoration: InputDecoration(labelText: 'Event Description'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Update the event with the edited data
          Event updatedEvent = Event(
            id: widget.event.id,
            eventName: eventNameController.text,
            eventDate: DateTime.parse(eventDateController.text),
            eventLocation: eventLocationController.text,
            eventTime: eventTimeController.text,
            eventDescription: eventDescriptionController.text,
          );
          // Call the editEvent method of the EventController to trigger the update
          _eventController.editEvent(updatedEvent);
          Navigator.of(context).pop();
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
