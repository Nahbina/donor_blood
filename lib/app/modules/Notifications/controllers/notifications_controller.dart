import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/notifications.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class NotificationsController extends GetxController {
  Notifications? notificationResponse;

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getNotification();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getNotification() async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/getNotifications.php');
      var response = await http.post(url, body: {
        "token": Memory.getToken(),
        "request_id": 'requestId',
      });

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        notificationResponse =
            Notifications.fromJson(jsonDecode(response.body));

        print('Parsed Notification Response: $notificationResponse');

        if (notificationResponse!.success ?? false) {
          // Handle successful response here
          update();
        } else {
          // Handle unsuccessful response here
          showCustomSnackBar(
            message: notificationResponse!.message ?? '',
          );
        }
      } else {
        // Handle HTTP error response here
        showCustomSnackBar(
          message: 'Failed to fetch notifications',
        );
      }
    } catch (e) {
      // Handle other errors here
      print(e);
      showCustomSnackBar(
        message: 'Something went wrong',
      );
    }
  }

  void increment() => count.value++;
}
