import 'package:get/get.dart';

import '../controllers/view_event_controller.dart';

class ViewEventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewEventController>(
      () => ViewEventController(),
    );
  }
}
