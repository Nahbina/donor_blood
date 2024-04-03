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
      var url = Uri.http(ipAddress, 'donor_blood_api/getBloodRequest.php');
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
        if (data['success']) {
          List<dynamic> requestsData = data['requests'];
          List<Request> requestsList = requestsData
              .map((requestData) => Request.fromJson(requestData))
              .toList();

          requests.assignAll(requestsList);
          update(); // Update the state to trigger a rebuild
          showCustomSnackBar(
            message: 'Requests fetched successfully',
            isSuccess: true,
          );
        } else {
          showCustomSnackBar(
            message: data['message'] ?? 'Failed to fetch requests',
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
}
