import 'package:get/get.dart';

class AdminController extends GetxController {
  //TODO: Implement AdminController
  var selectedIndex = 0.obs; // Observable to track selected index

  // Method to update the selected index
  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
    final count = 0.obs;
    @override
    void onInit() {
      super.onInit();
    }

    @override
    void onReady() {
      super.onReady();
    }

    @override
    void onClose() {
      super.onClose();
    }

    void increment() => count.value++;
  }
}
