import 'package:donor_blood/app/modules/Event/views/event_view.dart';
import 'package:donor_blood/app/modules/Request/views/request_view.dart';
import 'package:donor_blood/app/modules/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Profile/views/profile_view.dart';
import '../../ViewEvent/views/view_event_view.dart';

class MainController extends GetxController {
  var currentIndex = 0.obs;

  List<Widget> screens = [
    HomeView(),
    RequestFormView(),
    ViewEventView(),
    ProfileView(),
  ];

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
