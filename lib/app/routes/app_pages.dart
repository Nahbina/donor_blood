import 'package:get/get_navigation/src/routes/get_route.dart';

import '../modules/AdminDashboard/bindings/admin_dashboard_binding.dart';
import '../modules/AdminDashboard/views/admin_dashboard_view.dart';
import '../modules/AdminDonor/bindings/admin_donor_binding.dart';
import '../modules/AdminDonor/views/admin_donor_view.dart';
import '../modules/AdminRequest/bindings/admin_request_binding.dart';
import '../modules/AdminRequest/views/admin_request_view.dart';
import '../modules/Donors/bindings/donors_binding.dart';
import '../modules/Donors/views/donors_view.dart';
import '../modules/Donors_detail/bindings/donors_detail_binding.dart';
import '../modules/Donors_detail/views/donors_detail_view.dart';
import '../modules/Event/bindings/event_binding.dart';
import '../modules/Event/views/event_view.dart';
import '../modules/Main/bindings/main_binding.dart';
import '../modules/Main/views/main_view.dart';
import '../modules/Notifications/bindings/notifications_binding.dart';
import '../modules/Notifications/views/notifications_view.dart';
import '../modules/Profile/bindings/profile_binding.dart';
import '../modules/Profile/views/profile_view.dart';
import '../modules/Request/bindings/request_binding.dart';
import '../modules/Request/views/request_view.dart';
import '../modules/ViewEvent/bindings/view_event_binding.dart';
import '../modules/ViewEvent/views/view_event_view.dart';
import '../modules/admin/bindings/admin_binding.dart';
import '../modules/admin/views/admin_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN,
      page: () => AdminView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.DONORS,
      page: () => const DonorFormView(),
      binding: DonorsBinding(),
    ),
    GetPage(
      name: _Paths.REQUEST,
      page: () => RequestFormView(),
      binding: RequestBinding(),
    ),
    GetPage(
      name: _Paths.DONORS_DETAIL,
      page: () => const DonorsDetailView(),
      binding: DonorsDetailBinding(),
    ),
    GetPage(
      name: _Paths.EVENT,
      page: () => EventView(),
      binding: EventBinding(),
    ),
    GetPage(
      name: _Paths.VIEW_EVENT,
      page: () => ViewEventView(),
      binding: ViewEventBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => PaymentView(userId: ""),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_DASHBOARD,
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_DONOR,
      page: () => const AdminDonorView(),
      binding: AdminDonorBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_REQUEST,
      page: () => const AdminRequestView(),
      binding: AdminRequestBinding(),
    ),
  ];
}
