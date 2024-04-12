import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../models/Ratings.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class AdminRatingsController extends GetxController {
  final ratingsList = <Rating>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRatings();
  }

  Future<void> fetchRatings() async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/viewRatings.php');
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
        var ratingsData = ratingsFromJson(response.body);
        if (ratingsData.success == true) {
          ratingsList.assignAll(ratingsData.ratings ?? []);
          showCustomSnackBar(
            message: 'Ratings fetched successfully',
            isSuccess: true,
          );
        } else {
          // showCustomSnackBar(
          //   message: ratingsData.message ?? 'Failed to fetch ratings',
          //   isSuccess: false,
          // );
        }
      } else {
        showCustomSnackBar(
          message: 'Failed to load ratings: ${response.statusCode}',
          isSuccess: false,
        );
      }
    } catch (e) {
      print('Error fetching ratings: $e');
      showCustomSnackBar(
        message: 'Failed to fetch ratings: $e',
        isSuccess: false,
      );
    }
  }

  void deleteRatings(String ratingId, String user_id) async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/admin/deleteRatings.php');
      var response = await http.post(url, body: {
        'token': Memory.getToken(),
        'rating_Id':
            ratingId, // Change 'rating_Id' to match the backend parameter name
        'user_id': user_id,
      });

      print('Delete Rating Response: ${response.body}');

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        if (result['success']) {
          ratingsList.removeWhere((rating) => rating.ratingId == ratingId);
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
        // If the response status code is not 200, handle it accordingly
        showCustomSnackBar(
          message:
              'Failed to delete rating. Status code: ${response.statusCode}',
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
