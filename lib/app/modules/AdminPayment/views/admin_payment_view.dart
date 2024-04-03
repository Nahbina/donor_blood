import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_payment_controller.dart';

class AdminPaymentView extends GetView<AdminPaymentController> {
  const AdminPaymentView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'AdminPaymentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
