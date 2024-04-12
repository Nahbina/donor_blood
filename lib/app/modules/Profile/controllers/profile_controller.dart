import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../models/User.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart'; // Import the User model

class ProfileController extends GetxController {
  User? user; // Change userResponse to User
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> feedbackFormKey = GlobalKey<FormState>();
  final count = 0.obs;
  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var rating = 0.obs;
  @override
  void onInit() {
    super.onInit();
    getMyDetails();
  }

  Future<void> getMyDetails() async {
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

  void editProfile(String fullName, String email) async {
    try {
      Uri url = Uri.http(ipAddress, 'donor_blood_api/editProfile.php');

      var response = await http.post(url, body: {
        "token": Memory.getToken(),
        "full_name": fullName,
        "email": email,
      });

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body); // Parse the JSON response

        if (result['success'] ?? false) {
          // Update the user details locally
          user?.full_name = fullName;
          user?.email = email;

          update(); // Update the UI
          showCustomSnackBar(
            message: result['message'] ?? 'Profile updated successfully',
            isSuccess: true,
          );
        } else {
          showCustomSnackBar(
            message: result['message'] ?? 'Failed to update profile',
          );
        }
      } else {
        showCustomSnackBar(
          message: 'Failed to update user profile',
        );
      }
    } catch (e) {
      showCustomSnackBar(
        message: e.toString(),
      );
    }
  }

  void changePassword(
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
      oldPasswordController.clear();
      newPasswordController.clear();
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

  Future<void> addRatings(String rating, String comment) async {
    try {
      Uri url = Uri.http(ipAddress, 'donor_blood_api/giveRatings.php');

      var response = await http.post(url, body: {
        "token": Memory.getToken(),
        "rating": rating,
        "comment": comment,
      });

      if (response.statusCode == 200) {
        // Parse the response body as JSON
        var jsonResponse = jsonDecode(response.body);

        // Check if the response contains a 'success' field
        if (jsonResponse.containsKey('success')) {
          if (jsonResponse['success']) {
            // If 'success' is true, show success message
            showCustomSnackBar(
              message: jsonResponse['message'] ?? 'Rating added successfully',
              isSuccess: true,
            );
          } else {
            // If 'success' is false, show error message
            showCustomSnackBar(
              message: jsonResponse['message'] ?? 'Failed to add rating',
            );
          }
        } else {
          // If 'success' field is missing, show error message
          showCustomSnackBar(
            message: 'Unexpected response format',
          );
        }
      } else {
        // If response status code is not 200, show error message
        showCustomSnackBar(
          message: 'Failed to add rating: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      // Catch any exceptions and show error message
      showCustomSnackBar(
        message: 'Error: $e',
      );
    }
  }

  void increment() => count.value++;
}
