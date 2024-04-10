import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:khalti_flutter/khalti_flutter.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class PaymentController extends GetxController {
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

  void makePayment() async {
    try {
      final token = Memory.getToken() ?? '';
      if (token.isEmpty) {
        showCustomSnackBar(message: 'Token not found');
        return;
      }

      final config = PaymentConfig(
        productName: "Donation",
        amount: 100 * 100, // Example amount, replace with actual amount
        productIdentity: 'for money',
      );

      KhaltiScope.of(Get.context!).pay(
        config: config,
        preferences: [PaymentPreference.khalti],
        onSuccess: (response) async {
          final details = response.toString();
          final url = Uri.http(ipAddress, 'donor_blood_api/makePayment.php');
          final http.Response httpResponse = await http.post(
            url,
            body: {
              'token': token,
              'amount': config.amount.toString(), // Include the amount
              'details': details,
            },
          );

          final result = jsonDecode(httpResponse.body);

          if (result['success']) {
            showCustomSnackBar(message: 'Payment Successful', isSuccess: true);
            Get.offAllNamed(Routes.MAIN);
          } else {
            showCustomSnackBar(message: result['message']);
          }
        },
        onFailure: (error) {
          showCustomSnackBar(message: error.message);
        },
      );
    } catch (e) {
      showCustomSnackBar(message: 'An error occurred: $e');
    }
  }
}
