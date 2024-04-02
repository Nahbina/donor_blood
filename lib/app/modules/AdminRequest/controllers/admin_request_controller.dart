import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/requestModel.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class AdminRequestController extends GetxController {
  final RxList<Request> requests = <Request>[].obs; // Specify type as Request

  @override
  void onInit() {
    super.onInit();
    fetchRequests(); // Call the fetchRequests method on initialization
  }

  Future<void> fetchRequests() async {
    try {
      var url = Uri.http(ipAddress,
          'donor_blood_api/getBloodRequest.php'); // Update the API endpoint
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
        var requestList = BloodRequest.fromJson(
            data); // Parse JSON response using the BloodRequest model

        if (requestList.success ?? false) {
          requests.assignAll(requestList.requests ?? []);
          update();
          showCustomSnackBar(
            message: 'Requests fetched successfully',
            isSuccess: true,
          );
        } else {
          showCustomSnackBar(
            message: requestList.message ?? 'Failed to fetch requests',
            isSuccess: false,
          );
        }
      } else {
        showCustomSnackBar(
          message: 'Failed to load requests: ${response.statusCode}',
          isSuccess: false,
        );
      }
    } catch (e) {
      print('Error fetching requests: $e');
      showCustomSnackBar(
        message: 'Failed to fetch requests: $e',
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
