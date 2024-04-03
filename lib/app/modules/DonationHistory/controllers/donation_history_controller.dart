import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/donationHistory.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class DonationHistoryController extends GetxController {
  final RxList<DonationHistoryElement> donationHistoryList =
      <DonationHistoryElement>[].obs;

  @override
  void onInit() {
    super.onInit();
    getDonationHistory();
  }

  Future<void> getDonationHistory() async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/getDonation_history.php');
      var token = await Memory.getToken();

      if (token == null) {
        showCustomSnackBar(
          message: 'User not authenticated.',
          isSuccess: false,
        );
        return;
      }

      var response = await http.post(
        url,
        body: {'token': token},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var donationHistory = DonationHistory.fromJson(data);

        if (donationHistory.success ?? false) {
          donationHistoryList.assignAll(donationHistory.donationHistory ?? []);
          Get.snackbar('Success', 'Donation history fetched successfully',
              backgroundColor: Colors.green);
        } else {
          Get.snackbar('Error',
              donationHistory.message ?? 'Failed to fetch donation history');
        }
      } else {
        Get.snackbar(
            'Error', 'Failed to load donation history: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching donation history: $e');
      Get.snackbar('Error', 'Something went wrong');
    }
  }
}
