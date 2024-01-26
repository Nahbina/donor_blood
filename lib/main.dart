import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/memory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Memory.init();
  var token = Memory.getToken();
  var role = Memory.getRole();
  // var isHospital = role == 'hospital';
  var isAdmin = role == 'admin';
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: token == null
          ? Routes.LOGIN
          // : isHospital
          //     ? Routes.HOSPITAL_MAIN
          : isAdmin
              ? Routes.ADMIN
              : Routes.MAIN,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
    ),
  );
}
