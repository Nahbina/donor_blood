import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/Event.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class EventController extends GetxController {
  final RxList<Event> events = <Event>[].obs; // Specify type as Event
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/getEvent.php');
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
        var eventList = Events.fromJson(data);

        if (eventList.success ?? false) {
          events.assignAll(eventList.events ?? []);
          update();
          showCustomSnackBar(
            message: 'Events fetched successfully',
            isSuccess: true,
          );
        } else {
          showCustomSnackBar(
            message: eventList.message ?? 'Failed to fetch events',
            isSuccess: false,
          );
        }
      } else {
        showCustomSnackBar(
          message: 'Failed to load events: ${response.statusCode}',
          isSuccess: false,
        );
      }
    } catch (e) {
      print('Error fetching events: $e');
      showCustomSnackBar(
        message: 'Failed to fetch events: $e',
        isSuccess: false,
      );
    }
  }

  void addEvent(String id) async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/admin/addEvent.php');
      var response = await http.post(url, body: {
        'token': Memory.getToken(),
        'id': id,
      });

      if (response.statusCode == 200) {
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
      } else {
        showCustomSnackBar(
          message:
              'Failed to add event. Server returned status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      showCustomSnackBar(
        message: 'Something went wrong',
      );
    }
  }

  void editEvent(String id) async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/admin/editEvent.php');
      var response = await http.post(url, body: {
        'token': Memory.getToken(),
        'id': id,
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

  void deleteEvent(String id) async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/admin/deleteEvent.php');
      var response = await http.post(url, body: {
        'token': Memory.getToken(),
        'id': id,
      });

      print('Delete Event Response: ${response.body}');

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        if (result['success']) {
          events.removeWhere((event) => event.id == id);
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
        // If the response status code is not 200, handle it accordingly
        showCustomSnackBar(
          message:
              'Failed to delete event. Status code: ${response.statusCode}',
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
