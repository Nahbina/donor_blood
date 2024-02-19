import 'package:get/get.dart';

import '../controllers/donors_controller.dart';

class DonorsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DonorsController>(
      () => DonorsController(),
    );
  }
}
