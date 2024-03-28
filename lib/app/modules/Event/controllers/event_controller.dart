import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/Event.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class EventController extends GetxController {
  final RxList events = [].obs;
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchEvents() async {
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

  void addEvent(String eventId) async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/addEvent.php');

      var response = await http.post(url, body: {
        'token': Memory.getToken(),
        'event_id': eventId,
      });

      var result = jsonDecode(response.body);

      if (result['success']) {
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
    } catch (e) {
      showCustomSnackBar(
        message: 'Something went wrong',
      );
    }
  }

  void editEvent(String eventId) async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/editEvent.php');

      var response = await http.post(url, body: {
        'token': Memory.getToken(),
        'eventId': eventId,
      });

      var result = jsonDecode(response.body);

      if (result['success']) {
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
    } catch (e) {
      showCustomSnackBar(
        message: 'Something went wrong',
      );
    }
  }

  void deleteEvent(String eventId) async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/deleteEvent.php');

      var response = await http.post(url, body: {
        'token': Memory.getToken(),
        'event_id': eventId,
      });

      var result = jsonDecode(response.body);

      if (result['success']) {
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
    } catch (e) {
      showCustomSnackBar(
        message: 'Something went wrong',
      );
    }
  }
}
