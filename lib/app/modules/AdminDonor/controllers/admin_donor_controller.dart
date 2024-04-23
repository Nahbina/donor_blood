import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../models/donorModel.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class AdminDonorController extends GetxController {
  final RxList<DonorElement> donors = <DonorElement>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDonors();
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
        var donorList = Donor.fromJson(data);

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

  Future<void> editDonor(DonorElement donor) async {
    try {
      var url = Uri.http(ipAddress, '/donor_blood_api/admin/editDonor.php');
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
        body: {
          'token': token,
          'donor_id': donor.donorId.toString(),
          'blood_type': donor.bloodType ?? '',
          'birth_date': donor.birthDate?.toString() ?? '',
          'last_donation_date': donor.lastDonationDate ?? '',
          'phoneNumber': donor.phoneNumber ?? '',
          'Address': donor.Address ?? '',
          // Assuming 'address' is the correct field name in PHP
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          int index = donors.indexWhere((d) => d.donorId == donor.donorId);
          if (index != -1) {
            donors[index] = donor;
            showCustomSnackBar(
              message: 'Donor updated successfully',
              isSuccess: true,
            );
          } else {
            showCustomSnackBar(
              message: 'Donor not found in the list',
              isSuccess: false,
            );
          }
        } else {
          showCustomSnackBar(
            message: data['message'] ?? 'Failed to edit donor',
            isSuccess: false,
          );
        }
      } else {
        showCustomSnackBar(
          message: 'Failed to edit donor: ${response.statusCode}',
          isSuccess: false,
        );
      }
    } catch (e) {
      print('Error editing donor: $e');
      showCustomSnackBar(
        message: 'Failed to edit donor: $e',
        isSuccess: false,
      );
    }
  }

  Future<void> deleteDonor(int donorId) async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/admin/deleteDonor.php');
      var response = await http.post(url, body: {
        'token': Memory.getToken(),
        'donor_id': donorId.toString(),
      });

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['success']) {
          donors.removeWhere((d) => d.donorId == donorId);
          Get.back();
          showCustomSnackBar(
            message: result['message'],
            isSuccess: true,
          );
        } else {
          showCustomSnackBar(
            message: result['message'],
            isSuccess: false,
          );
        }
      } else {
        showCustomSnackBar(
          message:
              'Failed to delete donor. Status code: ${response.statusCode}',
          isSuccess: false,
        );
      }
    } catch (e) {
      showCustomSnackBar(
        message: 'Something went wrong: $e',
        isSuccess: false,
      );
    }
  }
}
