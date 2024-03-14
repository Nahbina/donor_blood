import 'package:get/get.dart';

import '../controllers/donors_detail_controller.dart';

class DonorsDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DonorsDetailController>(
      () => DonorsDetailController(),
    );
  }
}
