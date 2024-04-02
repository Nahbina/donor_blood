import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../models/Event.dart';
import '../../../utils/constants.dart'; // Import constants.dart if needed
import '../../../utils/memory.dart';

class ViewEventController extends GetxController {
  var events = <Event>[].obs; // Define the events property

  @override
  void onInit() {
    super.onInit();
    getViewEvents();
  }

  Future<void> getViewEvents() async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/getEvent.php');

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
        var data = jsonDecode(response.body);
        var eventsData =
            Events.fromJson(data); // Use Events model to parse JSON

        if (eventsData.success ?? false) {
          // Assign fetched events to the observable list
          events.assignAll(eventsData.events ?? []);
          // Manually trigger a rebuild of the GetBuilder
          update();
          // Show success snackbar
          showCustomSnackBar(
            message: 'Events fetched successfully',
            isSuccess: true,
          );
        } else {
          // Show snackbar for failed request
          showCustomSnackBar(
            message: eventsData.message ?? 'Failed to fetch events',
            isSuccess: false,
          );
        }
      } else {
        // Show snackbar for failed request
        showCustomSnackBar(
          message: 'Failed to load events: ${response.statusCode}',
          isSuccess: false,
        );
      }
    } catch (e) {
      // Handle exceptions
      print('Error fetching events: $e'); // Print error for debugging
      showCustomSnackBar(
        message: 'Failed to fetch events: $e',
        isSuccess: false,
      );
    }
  }
}
