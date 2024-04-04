import 'package:donor_blood/app/modules/AdminDonor/views/admin_donor_view.dart';
import 'package:donor_blood/app/modules/AdminRequest/views/admin_request_view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/memory.dart';
import '../../AdminDashboard/views/admin_dashboard_view.dart';
import '../../AdminPayment/views/admin_payment_view.dart';
import '../../Event/views/event_view.dart';

class AdminView extends StatefulWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  late Widget _currentView;

  @override
  void initState() {
    super.initState();
    _currentView = AdminDashboardView(); // Initialize with dashboard view
  }

  void _openDashboard() {
    setState(() {
      _currentView =
          AdminDashboardView(); // Set the current view to the dashboard
    });
  }

  void _openEventPage() {
    setState(() {
      _currentView = EventView();
    });
  }

  void _openDonorPage() {
    setState(() {
      _currentView = AdminDonorView();
    });
  }

  void _openRequestPage() {
    setState(() {
      _currentView = AdminRequestView();
    });
  }

  void _openAdminPaymentPage() {
    setState(() {
      _currentView = AdminPaymentView();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Drawer(
            child: ListView(
              padding: EdgeInsets.all(8),
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo1.png'),
                    ),
                  ),
                  child: null, // No need for child when using backgroundImage
                ),
                ListTile(
                  title: Text('Dashboard'),
                  onTap: _openDashboard,
                ),
                ListTile(
                  title: Text('Event'),
                  onTap: _openEventPage,
                ),
                ListTile(
                  title: Text('Donors'),
                  onTap: _openDonorPage,
                ),
                ListTile(
                  title: Text('Request'),
                  onTap: _openRequestPage,
                ),
                // ListTile(
                //   title: Text('Donation History'),
                //   // onTap: _openRequestPage,
                // ),
                ListTile(
                  title: Text('Profile'),
                  onTap: () {
                    Get.toNamed('/profile');
                  },
                ),
                ListTile(
                  title: Text('Payment'),
                  onTap: _openAdminPaymentPage,
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content:
                              const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Memory.clear();
                                Get.offAllNamed(Routes.LOGIN);
                              },
                              child: const Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('No'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: ListTile(
                    leading: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _currentView,
          ),
        ],
      ),
    );
  }
}
