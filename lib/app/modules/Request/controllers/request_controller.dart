import 'package:get/get.dart';

import '../../../utils/constants.dart';

class RequestController extends GetxController {
  // Define a list to store donors
  final donors = <Map<String, String>>[].obs;

  // Method to add a donor
  void addRequest({
    required String fullName,
    required String phoneNumber,
    required String bloodType,
    required String birthDate,
    required String lastDonationDate,
  }) {
    // Create a map to represent the donor
    final request = {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'bloodType': bloodType,
      'birthDate': birthDate,
      'lastDonationDate': lastDonationDate,
    };

    var url = Uri.http(ipAddress, 'donor_blood_api/addDonor.php');

    donors.add(request);

    // Print the added donor for verification (you can remove this in production)
    print('Donor added: $request');
  }
}
