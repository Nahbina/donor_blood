import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants.dart';
import 'package:http/http.dart' as http;

class RegisterController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var fullNameController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  var registerFormKey = GlobalKey<FormState>();

  final count = 0.obs;

  Future<void> onRegister() async {
    if (registerFormKey.currentState!.validate()) {
      try {
        var url = Uri.http(ipAddress, 'donor_blood_api/auth/register.php');

        var response = await http.post(url, body: {
          'fullname': fullNameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'confirmpassword': confirmPasswordController.text,
        });

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
  }

  void increment() => count.value++;
}
