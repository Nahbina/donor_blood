import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:khalti_flutter/localization/khalti_localizations.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/constants.dart';
import 'app/utils/memory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Memory.init();
  var token = Memory.getToken();
  var role = Memory.getRole();

  var isAdmin = role == 'admin';
  runApp(KhaltiScope(
    publicKey: "test_public_key_a756e8b46bbc48f39837d14e76e8433e",
    builder: (context, navigatorKey) => GetMaterialApp(
      navigatorKey: navigatorKey,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ne', 'NP'),
      ],
      localizationsDelegates: const [
        KhaltiLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: primaryColor,
      ),
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: token == null
          ? Routes.LOGIN
          : isAdmin
              ? Routes.ADMIN
              : Routes.MAIN,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
    ),
  ));
}
