import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/notifications_controller.dart';

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
          if (controller.notificationResponse == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.notificationResponse!.notifications!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('No notifications', style: TextStyle(fontSize: 20)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.notificationResponse!.notifications!.length,
            itemBuilder: (context, index) {
              final notification =
                  controller.notificationResponse!.notifications![index];
              final formattedDate = notification.createdAt != null
                  ? DateFormat("yyyy-MM-dd hh:mm aa")
                      .format(notification.createdAt!)
                  : 'Unknown Date';

              return ListTile(
                isThreeLine: true,
                title: Text(
                  notification.message ??
                      'Message', // Adjust as per your Notification class
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
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
