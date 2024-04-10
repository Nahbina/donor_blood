import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../../models/requestModel.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class RequestController extends GetxController {
  var bloodRequests = List<Request>.empty(growable: true).obs;
  var isLoading = true.obs; // Track loading state

  @override
  void onInit() {
    super.onInit();
    getBloodRequests();
  }

  Future<void> getBloodRequests() async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/getBloodRequest.php');

      // Fetch token
      var token = await Memory.getToken();
      if (token == null) {
        // Handle null token
        showCustomSnackBar(
          message: 'User not authenticated.',
          isSuccess: false,
        );
        return;
      }

      // Make POST request with token in body
      var response = await http.post(
        url,
        body: {'token': token},
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var bloodRequest = BloodRequest.fromJson(responseData);

        if (bloodRequest.success ?? false) {
          // Update bloodRequests list
          bloodRequests.value = bloodRequest.requests ?? [];
          // Set isLoading to false to indicate data is loaded
          isLoading.value = false;
          // Show success snackbar
          showCustomSnackBar(
            message: 'Blood requests fetched successfully',
            isSuccess: true,
          );
        } else {
          // Show snackbar for failed request
          // showCustomSnackBar(
          //   message: bloodRequest.message ?? 'Failed to fetch blood requests',
          //   isSuccess: false,
          // );
        }
      } else {
        // Show snackbar for failed request
        showCustomSnackBar(
          message: 'Failed to load blood requests: ${response.statusCode}',
          isSuccess: false,
        );
      }
    } catch (e) {
      // Handle exceptions
      print('Error fetching blood requests: $e'); // Print error for debugging
      showCustomSnackBar(
        message: 'Failed to fetch blood requests: $e',
        isSuccess: false,
      );
    }
  }

  void acceptRequest(String requestId) async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/acceptRequest.php');

      var response = await http.post(
        url,
        body: {
          'token': await Memory.getToken(),
          'request_id': requestId,
        },
      );

      var result = jsonDecode(response.body);

      if (result['success']) {
        Get.back();
        showCustomSnackBar(
          message: result['message'],
          isSuccess: true,
        );
        await getBloodRequests(); // Assuming getBloodRequests refreshes the requests list
      } else {
        showCustomSnackBar(
          message: result['message'],
        );
      }
    } catch (e) {
      showCustomSnackBar(
        message: 'Something went wrong',
      );
    }
  }

  void cancelRequest(String requestId) async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/cancelRequest.php');

      var response = await http.post(
        url,
        body: {
          'token': await Memory.getToken(),
          'request_id': requestId,
        },
      );

      var result = jsonDecode(response.body);

      if (result['success']) {
        // Remove the canceled request from the list
        bloodRequests.removeWhere(
            (request) => request.requestId.toString() == requestId);

        // Notify UI about the change
        update();

        Get.back();

        showCustomSnackBar(
          message: result['message'],
          isSuccess: true,
        );

        await getBloodRequests(); // Assuming getBloodRequests refreshes the requests list
      } else {
        showCustomSnackBar(
          message: result['message'],
        );
      }
    } catch (e) {
      showCustomSnackBar(
        message: 'Something went wrong',
      );
    }
  }
}
