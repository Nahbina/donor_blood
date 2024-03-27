import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PaymentView'),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the amount';
                }
                // You can add additional validation logic here if required
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Details',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the details';
                }
                // You can add additional validation logic here if required
                return null;
              },
            ),
            SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                elevation: 20,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
              ),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    khaltiLogo,
                    width: 30,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    'Pay with Khalti',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}

const khaltiLogo =
    "https://play-lh.googleusercontent.com/Xh_OlrdkF1UnGCnMN__4z-yXffBAEl0eUDeVDPr4UthOERV4Fll9S-TozSfnlXDFzw";
