import 'package:get/get.dart';

import '../controllers/admin_payment_controller.dart';

class AdminPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminPaymentController>(
      () => AdminPaymentController(),
    );
  }
}
