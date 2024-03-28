import 'dart:convert';
import 'package:get/get.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../routes/app_pages.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class PaymentController extends GetxController {
  //TODO: Implement PaymentController

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

  void makePayment(String userId) {
    try {
      PaymentConfig config = PaymentConfig(
        productName: "Donation",
        amount: 100 * 100,
        productIdentity: userId,
      );
      KhaltiScope.of(Get.context!).pay(
          config: config,
          preferences: [PaymentPreference.khalti],
          onSuccess: (v) async {
            Uri url = Uri.http(ipAddress, 'donor_blood_api/makePayment.php');
            var response = await http.post(url, body: {
              'token': Memory.getToken() ?? '',
              'userId': userId,
              'amount': 100,
              'details': v.toString()
            });

            var result = jsonDecode(response.body);

            if (result['success']) {
              showCustomSnackBar(
                  message: 'Payment Successful', isSuccess: true);
              Get.offAllNamed(Routes.MAIN);
            } else {
              showCustomSnackBar(message: result['message']);
            }
          },
          onFailure: (v) {
            showCustomSnackBar(message: v.message);
          });
    } catch (e) {
      showCustomSnackBar(message: e.toString());
    }
  }
}
