import 'package:get/get.dart';

import '../../../models/Event.dart';
import '../../../utils/constants.dart'; // Import constants.dart if needed
import 'dart:convert';
import 'package:http/http.dart' as http;

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
        var eventList = Events.fromJson(data); // Use Events model to parse JSON

        if (eventList.success ?? false) {
          // Assign fetched events to the observable list
          events.assignAll(eventList.events ?? []);
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
            message: eventList.message ?? 'Failed to fetch events',
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
