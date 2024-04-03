import 'dart:convert';
import 'package:get/get.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../routes/app_pages.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class AdminPaymentController extends GetxController {
  //TODO: Implement AdminPaymentController

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

  void makePayment(String userId, int amount, String details) {
    try {
      PaymentConfig config = PaymentConfig(
        productName: "Donation",
        amount: 100 * 100, // Convert amount to paisa
        productIdentity: userId,
      );
      KhaltiScope.of(Get.context!).pay(
        config: config,
        preferences: [PaymentPreference.khalti],
        onSuccess: (v) async {
          Uri url = Uri.http(ipAddress, 'donor_blood_api/makePayment.php');
          var response = await http.post(url, body: {
            'token': Memory.getToken() ?? '',
            'user_id': userId,
            'amount': amount.toString(),
            'details': details,
          });

          var result = jsonDecode(response.body);

          if (result['success']) {
            showCustomSnackBar(message: 'Payment Successful', isSuccess: true);
            Get.offAllNamed(Routes.MAIN);
          } else {
            showCustomSnackBar(message: result['message']);
          }
        },
        onFailure: (v) {
          showCustomSnackBar(
              message:
                  'Payment Failed: ${v.message}'); // Display the error message
        },
      );
    } catch (e) {
      showCustomSnackBar(message: e.toString());
    }
  }
}
