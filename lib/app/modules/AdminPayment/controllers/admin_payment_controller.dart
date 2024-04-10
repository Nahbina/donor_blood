import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/viewPayment.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class AdminPaymentController extends GetxController {
  // Define an observable list to store payments
  RxList<Payment> payments = <Payment>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch payment details when the controller is initialized
    viewPayments();
  }

  // Function to fetch payment details from the server
  Future<void> viewPayments() async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/admin/viewPayment.php');
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

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the JSON response into Dart objects
        final jsonResponse = json.decode(response.body);
        final viewPayment = ViewPayment.fromJson(jsonResponse);

        // Update the payments list with the fetched data
        payments.assignAll(viewPayment.payments!);
      } else {
        // If the request failed, show an error message
        throw Exception('Failed to load payment details');
      }
    } catch (error) {
      // If an error occurs during the process, show the error message
      print(error);
    }
  }
}
