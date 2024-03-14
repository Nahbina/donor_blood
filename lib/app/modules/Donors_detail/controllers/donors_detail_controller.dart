import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../../models/donorModel.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class DonorsDetailController extends GetxController {
  var donorDetails = List<DonorElement>.empty(growable: true).obs;

  @override
  void onInit() {
    super.onInit();
    getDonorDetails();
  }

  void addBloodRequest(String donorId) async {
    try {
      var token = await Memory.getToken();
      if (token == null) {
        // Handle null token (e.g., prompt user to log in)
        Get.snackbar('Error', 'User not authenticated. Please log in.');
        return;
      }

      Uri url = Uri.http(ipAddress, 'donor_blood_api/addBloodRequest.php');
      var response = await http.post(
        url,
        body: {
          'token': token,
          'donor_id': donorId,
        },
      );

      var result = jsonDecode(response.body);
      if (result['success']) {
        // Handle success
        Get.snackbar('Success', 'Blood donation request sent successfully!');
      } else {
        // Handle failure
        Get.snackbar('Error',
            'Failed to send blood donation request: ${result['message']}');
      }
    } catch (e) {
      // Handle exceptions
      Get.snackbar(
          'Error', 'Error occurred while sending blood donation request: $e');
    }
  }

  Future<void> getDonorDetails() async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/getDonor.php');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var donor = Donor.fromJson(data);

        donorDetails.value = donor.donors ?? []; // Ensure donors is not null
        Get.snackbar(
            'Success', donor.message ?? 'Donor details fetched successfully',
            backgroundColor: Colors.green);
      } else {
        Get.snackbar('Error', 'Failed to load donor details');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    }
  }
}
