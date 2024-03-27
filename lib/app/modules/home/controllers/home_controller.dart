import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/donorModel.dart'; // Ensure this import path is correct
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class HomeController extends GetxController {
  Donor? donors; // Changed from Donors? to Donor? to match the model class

  @override
  void onInit() {
    super.onInit();
    getDonors();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getDonors() async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/getDonor.php');

      var response = await http.post(url, body: {"token": Memory.getToken()});
      if (response.statusCode == 200) {
        donors = donorFromJson(
            response.body); // Use donorFromJson to parse the JSON response
        update();

        if (!(donors?.success ?? false)) {
          showCustomSnackBar(
            message: donors?.message ?? '',
          );
        }
      } else {
        showCustomSnackBar(
          message: 'Failed to fetch donors',
        );
      }
    } catch (e) {
      showCustomSnackBar(
        message: 'Something went wrong',
      );
    }
  }
}
