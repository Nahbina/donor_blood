import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/Event.dart';
import '../controllers/view_event_controller.dart';

class ViewEventView extends StatelessWidget {
  final Event? event; // Define the event property

  const ViewEventView({Key? key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Bind the controller to the view
    Get.put(ViewEventController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Event View'),
      ),
      body: event != null // Check if event is provided
          ? _buildEventDetails(
              event!) // If event is provided, build event details
          : _buildEventListView(), // If event is not provided, build event list view
    );
  }

  Widget _buildEventDetails(Event event) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          event.eventName ?? '',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 10),
        Text('Date: ${event.eventDate?.toString() ?? ''}'),
        Text('Location: ${event.eventLocation ?? ''}'),
        Text('Time: ${event.eventTime ?? ''}'),
      ],
    );
  }

  Widget _buildEventListView() {
    return GetBuilder<ViewEventController>(
      builder: (controller) {
        if (controller.events.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: controller.events.length,
            itemBuilder: (context, index) {
              Event event = controller.events[index];
              return ListTile(
                title: Text(event.eventName ?? ''),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: ${event.eventDate?.toString() ?? ''}'),
                    Text('Location: ${event.eventLocation ?? ''}'),
                    Text('Time: ${event.eventTime ?? ''}'),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Navigate to the same view event page with the selected event
                    Get.to(() => ViewEventView(event: event));
                  },
                  child: Text('View Event'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Set button color to red
                    onPrimary: Colors.white, // Set button text color to white
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
