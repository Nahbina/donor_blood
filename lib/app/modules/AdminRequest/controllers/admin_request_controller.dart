import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/requestModel.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class AdminRequestController extends GetxController {
  final RxList<Request> requests = <Request>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    try {
      isLoading.value = true;
      error.value = '';

      var url = Uri.http(ipAddress, 'donor_blood_api/getBloodRequest.php');
      var token = await Memory.getToken();

      if (token == null) {
        error.value = 'User not authenticated.';
        return;
      }

      var response = await http.post(url, body: {'token': token});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success']) {
          List<dynamic> requestsData = data['requests'];
          List<Request> requestsList = requestsData
              .map((requestData) => Request.fromJson(requestData))
              .toList();

          requests.assignAll(requestsList);
          isLoading.value = false;
        } else {
          error.value = data['message'] ?? 'Failed to fetch requests';
        }
      } else {
        error.value = 'Failed to load requests: ${response.statusCode}';
      }
    } catch (e) {
      error.value = 'Failed to fetch requests: $e';
      print('Error fetching requests: $e');
    }
  }
}
