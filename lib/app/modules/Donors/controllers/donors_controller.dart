import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';
import '../../home/controllers/home_controller.dart';

class DonorsController extends GetxController {
  var donorBloodType = TextEditingController();
  var donorbirthDate = TextEditingController();
  var donorlastDonationDate = TextEditingController();
  var donorPhoneNumber = TextEditingController();
  var donorAddress = TextEditingController();
  String? selectedBloodType;
  XFile? image;
  Uint8List? imageBytes;
  String? specializationId;
  GlobalKey<FormState> donorformKey = GlobalKey<FormState>();

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

  void addDonor() async {
    try {
      if (donorformKey.currentState!.validate()) {
        if (imageBytes == null) {
          showCustomSnackBar(
            message: 'Please select image',
          );
          return;
        }

        var url = Uri.http(ipAddress, 'donor_blood_api/addDonor.php');

        var request = http.MultipartRequest('POST', url);

        request.fields['token'] = Memory.getToken() ?? '';
        request.fields['blood_type'] =
            selectedBloodType!; // Use selectedBloodType
        request.fields['birth_date'] = donorbirthDate.text;
        request.fields['last_donation_date'] = donorlastDonationDate.text;
        request.fields['phoneNumber'] = donorPhoneNumber.text;
        request.fields['Address'] = donorAddress.text;
        request.files.add(http.MultipartFile.fromBytes(
          'avatar',
          imageBytes!,
          filename: image!.name,
        ));

        var response = await request.send();
        var data = await response.stream.bytesToString();
        var result = jsonDecode(data);

        if (result['success']) {
          // Clear form fields and update UI
          donorBloodType.clear();
          donorbirthDate.clear();
          donorlastDonationDate.clear();
          donorPhoneNumber.clear();
          donorAddress.clear();
          imageBytes = null;
          image = null;
          update();

          // Show success message
          Get.back();
          showCustomSnackBar(
            message: result['message'],
            isSuccess: true,
          );

          // Update donors list
          Get.find<HomeController>().getDonors();
        } else {
          showCustomSnackBar(
            message: result['message'],
          );
        }
      }
    } catch (e) {
      showCustomSnackBar(
        message: 'Something went wrong',
      );
    }
  }

  void pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        return;
      }
      image = pickedFile;
      imageBytes = await pickedFile.readAsBytes();
      update();
    } catch (e) {
      print('Error picking image: $e');
    }
  }
}
