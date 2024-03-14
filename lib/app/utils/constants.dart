import 'package:get/get.dart';
import 'package:flutter/material.dart';

const ipAddress = '192.168.18.9';
// const ipAddress = '172.16.16.95';
// const ipAddress = '172.16.17.156';
// const ipAddress = '172.25.5.160';
// const ipAddress = '192.168.1.73';
// const ipAddress = ' 172.25.6.84';

MaterialColor primaryColor = Colors.red;
var getImageUrl = (imageUrl) {
  return 'http://$ipAddress/donor_blood_api/$imageUrl';
};

var showCustomSnackBar = ({
  required String message,
  bool isSuccess = false,
}) =>
    Get.showSnackbar(
      GetSnackBar(
        messageText: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        duration: const Duration(milliseconds: 1500),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        // borderRadius: 10.w,
        snackPosition: SnackPosition.TOP,
      ),
    );
