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

          if (controller.notificationResponse?.notifications?.isEmpty ?? true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   height: 400,
                  //   child: Lottie.asset(
                  //     'assets/lottie/notification.json',
                  //     height: 200,
                  //     repeat: true,
                  //   ),
                  // ),
                  Text('No notifications', style: TextStyle(fontSize: 20)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.notificationResponse?.notifications?.length,
            itemBuilder: (context, index) {
              var formattedDate = DateFormat("yyyy-MM-dd hh:mm aa").format(
                  controller
                      .notificationResponse!.notifications![index].createdAt!);

              return ListTile(
                isThreeLine: true,
                title: Text(
                  controller.notificationResponse?.notifications?[index]
                          .message ??
                      '',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: $formattedDate'), // Display formatted date
                    // Add more information as needed
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
