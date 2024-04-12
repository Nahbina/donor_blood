import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/requestModel.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class AdminRequestController extends GetxController {
  final RxList<Request> requests = <Request>[].obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    try {
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
          List<Request> requestsList = requestsData.map((requestData) {
            return Request(
              requestId: int.tryParse(requestData['request_id'].toString()),
              userId: int.tryParse(requestData['user_id'].toString()),
              donorId: int.tryParse(requestData['donor_id'].toString()),
              status: requestData['status'],
              requestDate: requestData['request_date'] == null
                  ? null
                  : DateTime.parse(requestData['request_date']),
              requesterName: requestData['requester_name'],
              requesterEmail: requestData['requester_email'],
            );
          }).toList();

          // Update the requests list with the fetched data
          requests.assignAll(requestsList);
          // Notify GetX to rebuild the UI
          update();
          // Show success message in green color
          Get.snackbar(
            'Success',
            'Requests fetched successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
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

  void editRequest(Request request) async {
    try {
      var url =
          Uri.http(ipAddress, 'donor_blood_api/admin/editBloodRequest.php');
      var response = await http.post(url, body: {
        'token': await Memory.getToken(),
        'request_id': request.requestId.toString(),
        'user_id': request.userId.toString(),
        'donor_id': request.donorId.toString(),
        'status': request.status ?? '',
        'request_date': request.requestDate?.toString() ?? '',
        'requester_name': request.requesterName ?? '',
        'requester_email': request.requesterEmail ?? '',
      });

      print('Edit Request Response Body: ${response.body}');

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        if (result['success']) {
          int index =
              requests.indexWhere((r) => r.requestId == request.requestId);
          if (index != -1) {
            requests[index] = request;
          }
          update();
          Get.back();
          showCustomSnackBar(
            message: result['message'],
            isSuccess: true,
          );
        } else {
          showCustomSnackBar(
            message: result['message'],
          );
        }
      } else {
        showCustomSnackBar(
          message:
              'Failed to edit request. Server returned status code: ${response.statusCode}',
          isSuccess: false,
        );
      }
    } catch (e) {
      print('Error editing request: $e');
      showCustomSnackBar(
        message: 'Failed to edit request: $e',
        isSuccess: false,
      );
    }
  }

  void deleteRequest(int id) async {
    try {
      var url =
          Uri.http(ipAddress, 'donor_blood_api/admin/deleteBloodRequest.php');
      var response = await http.post(url, body: {
        'token': Memory.getToken(),
        'request_id': id.toString(),
      });

      print('Delete Request Response: ${response.body}');

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        if (result['success']) {
          requests.removeWhere((request) => request.requestId == id);
          update();
          Get.back();
          showCustomSnackBar(
            message: result['message'],
            isSuccess: true,
          );
        } else {
          showCustomSnackBar(
            message: result['message'],
          );
        }
      } else {
        showCustomSnackBar(
          message:
              'Failed to delete request. Status code: ${response.statusCode}',
          isSuccess: false,
        );
      }
    } catch (e) {
      showCustomSnackBar(
        message: 'Something went wrong: $e',
      );
    }
  }
}
