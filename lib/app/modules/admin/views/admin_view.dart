import 'package:donor_blood/app/modules/AdminDonor/views/admin_donor_view.dart';
import 'package:donor_blood/app/modules/AdminRatings/views/admin_ratings_view.dart';
import 'package:donor_blood/app/modules/AdminRequest/views/admin_request_view.dart';
import 'package:donor_blood/app/modules/AdminUsers/views/admin_users_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  int _selectedIndex = 0; // Track the selected index

  @override
  void initState() {
    super.initState();
    _currentView = AdminDashboardView(); // Initialize with dashboard view
  }

  // Function to set the selected index and update the current view
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _currentView = AdminDashboardView();
          break;
        case 1:
          _currentView = EventView();
          break;
        case 2:
          _currentView = AdminUsersView();
          break;
        case 3:
          _currentView = AdminDonorView();
          break;
        case 4:
          _currentView = AdminRequestView();
          break;
        case 5:
          _currentView = AdminRatingsView();
          break;
        case 6:
          _currentView = AdminPaymentView();
          break;
        default:
          _currentView = AdminDashboardView();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Drawer(
            child: Container(
              color: Color.fromRGBO(233, 233, 233, 1),
              child: ListView(
                padding: EdgeInsets.all(8),
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/logo1.png'),
                      ),
                    ),
                    child: null,
                  ),
                  // Use the selected index to set the color of the ListTile
                  ListTile(
                    title: Text(
                      'Dashboard',
                      style: TextStyle(
                        color: _selectedIndex == 0 ? Colors.red : null,
                      ),
                    ),
                    onTap: () => _onItemTapped(0),
                    tileColor: _selectedIndex == 0 ? Colors.blue : null,
                  ),
                  ListTile(
                    title: Text(
                      'Event',
                      style: TextStyle(
                        color: _selectedIndex == 1 ? Colors.red : null,
                      ),
                    ),
                    onTap: () => _onItemTapped(1),
                    tileColor: _selectedIndex == 1 ? Colors.blue : null,
                  ),
                  ListTile(
                    title: Text(
                      'Users',
                      style: TextStyle(
                        color: _selectedIndex == 2 ? Colors.red : null,
                      ),
                    ),
                    onTap: () => _onItemTapped(2),
                    tileColor: _selectedIndex == 2 ? Colors.blue : null,
                  ),
                  ListTile(
                    title: Text(
                      'Donors',
                      style: TextStyle(
                        color: _selectedIndex == 3 ? Colors.red : null,
                      ),
                    ),
                    onTap: () => _onItemTapped(3),
                    tileColor: _selectedIndex == 3 ? Colors.blue : null,
                  ),
                  ListTile(
                    title: Text(
                      'Request',
                      style: TextStyle(
                        color: _selectedIndex == 4 ? Colors.red : null,
                      ),
                    ),
                    onTap: () => _onItemTapped(4),
                    tileColor: _selectedIndex == 4 ? Colors.blue : null,
                  ),
                  ListTile(
                    title: Text(
                      'Ratings',
                      style: TextStyle(
                        color: _selectedIndex == 5 ? Colors.red : null,
                      ),
                    ),
                    onTap: () => _onItemTapped(5),
                    tileColor: _selectedIndex == 5 ? Colors.blue : null,
                  ),
                  ListTile(
                    title: Text(
                      'Payment',
                      style: TextStyle(
                        color: _selectedIndex == 6 ? Colors.red : null,
                      ),
                    ),
                    onTap: () => _onItemTapped(6),
                    tileColor: _selectedIndex == 6 ? Colors.blue : null,
                  ),
                  ListTile(
                    title: Text(
                      'Profile',
                      style: TextStyle(
                        color: _selectedIndex == -1 ? Colors.red : null,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedIndex = -1; // Set to -1 to clear selection
                      });
                      Get.toNamed('/profile');
                    },
                  ),
                ],
              ),
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
