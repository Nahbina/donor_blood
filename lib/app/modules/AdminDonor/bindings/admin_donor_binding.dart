import 'package:get/get.dart';

import '../controllers/admin_donor_controller.dart';

class AdminDonorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminDonorController>(
      () => AdminDonorController(),
    );
  }
}
