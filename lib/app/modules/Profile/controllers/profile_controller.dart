import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../utils/constants.dart';

class ProfileController extends GetxController {
  final count = 0.obs;
  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();

  Future<void> changePassword(
      String oldPassword, String newPassword, String token) async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/changePassword.php');

      var response = await http.post(
        url,
        body: {
          'old_password': oldPassword,
          'new_password': newPassword,
          'token': token,
        },
      );

      if (response.statusCode == 200) {
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
      } else {
        showCustomSnackBar(
          message: 'Something went wrong',
        );
      }
    } catch (e) {
      showCustomSnackBar(
        message: 'Something went wrong',
      );
    }
  }

  void increment() => count.value++;
}
