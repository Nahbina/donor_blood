import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/notifications.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class NotificationsController extends GetxController {
  Notifications? notificationResponse;
  String? requestId;
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Example of setting the requestId before calling getNotification()
    setRequestId('requestId');
  }

  void setRequestId(String id) {
    requestId = id; // Assign the parameter value to the class member variable
    getNotification(); // Call getNotification() after setting the requestId
  }

  Future<void> getNotification() async {
    try {
      // Ensure requestId is not null
      if (requestId == null) {
        print('Request ID is null');
        return;
      }

      var url = Uri.http(ipAddress, 'donor_blood_api/getNotifications.php');
      var response = await http.post(url, body: {
        "token": Memory.getToken() ?? '',
        "request_id": requestId!,
      });

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        // Check if the response contains notifications
        if (responseData['success'] == true &&
            responseData.containsKey('notifications')) {
          List<dynamic> notificationsData = responseData['notifications'];

          // Map each notification to Notifications model
          List<Notification> notifications = notificationsData
              .map((notification) => Notification.fromJson(notification))
              .toList();

          // Update notificationResponse with fetched notifications
          notificationResponse = Notifications(
            success: true,
            message: responseData['message'],
            notifications: notifications,
          );
          update();
        } else {
          // Handle case where no notifications are found
          notificationResponse = Notifications(
            success: false,
            message: 'No notifications found.',
            notifications: [],
          );
          update();
        }
      } else {
        print('Failed to fetch notifications');
      }
    } catch (e) {
      print('Something went wrong: $e');
    }
  }

  void increment() => count.value++;
}
