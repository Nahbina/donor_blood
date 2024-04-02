import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../models/Statics.dart';
import '../../../models/User.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class AdminDashboardController extends GetxController {
  Statics? statsResponse;
  User? user;
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getStats();
    getMyDetails();
  }

  void getStats() async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/admin/getStatics.php');
      var response = await http.post(url, body: {"token": Memory.getToken()});

      if (response.statusCode == 200) {
        statsResponse = staticsFromJson(response.body);
        update();

        if (statsResponse?.success ?? false) {
          // Data successfully fetched
        } else {
          // Handle error message from the server
          showCustomSnackBar(
            message: statsResponse?.message ?? '',
          );
        }
      } else {
        // Handle non-200 status code
        showCustomSnackBar(
          message:
              'Failed to get statistics. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print(e);
      // Handle other errors, such as network issues
      showCustomSnackBar(
        message: 'Something went wrong: $e',
      );
    }
  }

  Future<void> getMyDetails() async {
    try {
      Uri url = Uri.http(ipAddress, 'donor_blood_api/getMyDetails.php');

      var response = await http.post(url, body: {"token": Memory.getToken()});

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        var result = userFromJson(response.body); // Parse the JSON response

        if (result.success ?? false) {
          user = result; // Assign user details
          update(); // Update the UI
        } else {
          showCustomSnackBar(
            message: result.message ?? '',
          );
        }
      } else {
        showCustomSnackBar(
          message: 'Failed to fetch user details',
        );
      }
    } catch (e) {
      showCustomSnackBar(
        message: e.toString(),
      );
    }
  }

  void increment() => count.value++;
}
