import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/notifications_controller.dart'; // Adjust import path

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      body: GetBuilder<NotificationsController>(
        builder: (controller) {
          if (controller.notificationResponse == null ||
              controller.notificationResponse!.notifications == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final notifications = controller.notificationResponse!.notifications!;
          if (notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Your donation has been accepted!',
                        style: TextStyle(fontSize: 20)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Your donation has been accepted!',
                        style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final formattedDate = notification.createdAt != null
                  ? DateFormat("yyyy-MM-dd hh:mm aa")
                      .format(notification.createdAt!)
                  : 'Unknown Date';

              return ListTile(
                isThreeLine: true,
                title: Text(
                  notification.message ?? 'Message',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
