import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class EventController extends GetxController {
  //TODO: Implement EventController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void deleteEvent(String doctorId) async {
    try {
      var url = Uri.http(ipAddress, 'donor_api/deleteEvent');

      var response = await http.post(url, body: {
        'token': Memory.getToken(),
        'doctor_id': doctorId,
      });

      var result = jsonDecode(response.body);

      if (result['success']) {
        Get.back();
        showCustomSnackBar(
          message: result['message'],
          isSuccess: true,
        );
      } else {
        showCustomSnackBar(
          message: result['message'],
        );
      }
    } catch (e) {
      showCustomSnackBar(
        message: 'Something went wrong',
      );
    }
  }
}
