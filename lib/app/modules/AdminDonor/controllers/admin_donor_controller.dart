import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../models/donorModel.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class AdminDonorController extends GetxController {
  final RxList<DonorElement> donors =
      <DonorElement>[].obs; // Specify type as DonorElement

  @override
  void onInit() {
    super.onInit();
    fetchDonors(); // Call the fetchDonors method on initialization
  }

  Future<void> fetchDonors() async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/getDonor.php');
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
        var donorList =
            Donor.fromJson(data); // Parse JSON response using the Donor model

        if (donorList.success ?? false) {
          donors.assignAll(donorList.donors ?? []);
          update();
          showCustomSnackBar(
            message: 'Donors fetched successfully',
            isSuccess: true,
          );
        } else {
          showCustomSnackBar(
            message: donorList.message ?? 'Failed to fetch donors',
            isSuccess: false,
          );
        }
      } else {
        showCustomSnackBar(
          message: 'Failed to load donors: ${response.statusCode}',
          isSuccess: false,
        );
      }
    } catch (e) {
      print('Error fetching donors: $e');
      showCustomSnackBar(
        message: 'Failed to fetch donors: $e',
        isSuccess: false,
      );
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
