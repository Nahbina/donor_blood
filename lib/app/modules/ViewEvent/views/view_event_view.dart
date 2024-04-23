import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/Event.dart'; // Import the updated Event model
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
              context, event!) // If event is provided, build event details
          : _buildEventListView(), // If event is not provided, build event list view
    );
  }

  Widget _buildEventDetails(BuildContext context, Event event) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            event.eventName ?? '',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          ),
          SizedBox(height: 20),
          _buildEventDetailRow('ID', event.id ?? ''), // Add ID to event details
          _buildEventDetailRow('Date', event.eventDate?.toString() ?? ''),
          _buildEventDetailRow('Location', event.eventLocation ?? ''),
          _buildEventDetailRow('Time', event.eventTime ?? ''),
          _buildEventDetailRow('Description', event.eventDescription ?? ''),
        ],
      ),
    );
  }

  Widget _buildEventDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label + ':',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          Text(value),
        ],
      ),
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
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text(
                    event.eventName ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEventDetailRow(
                          'Date', event.eventDate?.toString() ?? ''),
                      _buildEventDetailRow(
                          'Location', event.eventLocation ?? ''),
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
                ),
              );
            },
          );
        }
      },
    );
  }
}
