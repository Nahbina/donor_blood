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

  void getNotification() async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/getNotifications.php');

      var response = await http.post(url, body: {"token": Memory.getToken()});
      notificationResponse = notificationsFromJson(response.body);
      update();

      if (notificationResponse?.success ?? false) {
        // showCustomSnackBar(
        //   message: specializationResponse?.message ?? '',
        //   isSuccess: true,
        // );
      } else {
        showCustomSnackBar(
          message: notificationResponse?.message ?? '',
        );
      }
    } catch (e) {
      print(e);
      showCustomSnackBar(
        message: 'Something went wrong',
      );
    }
  }

  void increment() => count.value++;
}
