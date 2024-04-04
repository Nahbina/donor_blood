import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends StatelessWidget {
  // final String userId = Get.arguments;
  // // Define userId variable
  // final TextEditingController amountController = TextEditingController();
  // final TextEditingController detailsController = TextEditingController();

  // PaymentView({
  //   Key? key,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize PaymentController when the view is built
    Get.put(PaymentController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.stretch,
      //     children: [
      //       TextFormField(
      //         controller: amountController, // Add controller
      //         decoration: InputDecoration(
      //           labelText: 'Amount',
      //           border: OutlineInputBorder(),
      //         ),
      //         keyboardType: TextInputType.number,
      //         validator: (value) {
      //           if (value == null || value.isEmpty) {
      //             return 'Please enter the amount';
      //           }
      //           return null;
      //         },
      //       ),
      //       SizedBox(height: 16),
      //       TextFormField(
      //         controller: detailsController, // Add controller
      //         decoration: InputDecoration(
      //           labelText: 'Details',
      //           border: OutlineInputBorder(),
      //         ),
      //         keyboardType: TextInputType.text,
      //         validator: (value) {
      //           if (value == null || value.isEmpty) {
      //             return 'Please enter the details';
      //           }
      //           return null;
      //         },
      //       ),
      //       SizedBox(height: 32),
      //       ElevatedButton(
      //         style: ElevatedButton.styleFrom(
      //           backgroundColor: Colors.purple,
      //           elevation: 20,
      //           padding: const EdgeInsets.symmetric(
      //             vertical: 20,
      //           ),
      //         ),
      //         onPressed: () {
      //           // Retrieve amount and details from the text fields
      //           String amount = amountController.text;
      //           String details = detailsController.text;

      //           // Call makePayment from the initialized PaymentController
      //           Get.find<PaymentController>().makePayment(userId,
      //               int.parse(amount), details); // Pass amount and details
      //         },
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Image.network(
      //               khaltiLogo,
      //               width: 30,
      //             ),
      //             const SizedBox(
      //               width: 20,
      //             ),
      //             const Text(
      //               'Donate with Khalti',
      //               style: TextStyle(
      //                 fontSize: 16,
      //                 color: Colors.white,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

const khaltiLogo =
    "https://play-lh.googleusercontent.com/Xh_OlrdkF1UnGCnMN__4z-yXffBAEl0eUDeVDPr4UthOERV4Fll9S-TozSfnlXDFzw";
