import 'package:get/get.dart';

import '../controllers/admin_ratings_controller.dart';

class AdminRatingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminRatingsController>(
      () => AdminRatingsController(),
    );
  }
}
