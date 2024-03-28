import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../models/User.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart'; // Import the User model

class ProfileController extends GetxController {
  User? user; // Change userResponse to User

  final count = 0.obs;
  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getMyDetails();
  }

  void getMyDetails() async {
    try {
      Uri url = Uri.http(ipAddress, 'donor_blood_api/getMyDetails.php');

      var response = await http.post(url, body: {"token": Memory.getToken()});

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        var result = userFromJson(response.body); // Parse the JSON response

        if (result.success ?? false) {
          user = result; // Assign user details
          update(); // Update the UI
        } else {
          showCustomSnackBar(
            message: result.message ?? '',
          );
        }
      } else {
        showCustomSnackBar(
          message: 'Failed to fetch user details',
        );
      }
    } catch (e) {
      showCustomSnackBar(
        message: e.toString(),
      );
    }
  }

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
