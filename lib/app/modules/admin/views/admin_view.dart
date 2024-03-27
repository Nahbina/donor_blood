import 'package:donor_blood/app/modules/Donors_detail/views/donors_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/memory.dart';
import '../../Event/views/event_view.dart';
import '../controllers/admin_controller.dart';

class AdminView extends StatefulWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  Widget _currentView = Center(
    child: Text(
      'AdminView is working',
      style: TextStyle(fontSize: 20),
    ),
  );

  void _openEventPage() {
    setState(() {
      _currentView = EventView();
    });
  }

  void _openDonorPage() {
    setState(() {
      _currentView = DonorsDetailView();
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
                  onTap: () {
                    // Add your logic here
                  },
                ),
                ListTile(
                  title: Text('Event'),
                  onTap: _openEventPage,
                ),
                ListTile(
                  title: Text('Donors'),
                  onTap: () {
                    // Add your logic here
                  },
                ),
                ListTile(
                  title: Text('Request'),
                  onTap: () {
                    // Add your logic here
                  },
                ),
                ListTile(
                  title: Text('Donation History'),
                  onTap: () {
                    // Add your logic here
                  },
                ),
                ListTile(
                  title: Text('Settings'),
                  onTap: () {
                    // Add your logic here
                  },
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
