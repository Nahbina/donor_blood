import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.centerLeft,
        child: GetBuilder<AdminDashboardController>(
          init: AdminDashboardController(), // Initialize the controller
          builder: (controller) {
            // Check if data is being fetched
            if (controller.statsResponse != null) {
              // Display the fetched data
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Show greeting based on the current time
                  _buildGreeting(controller),

                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildDataContainer(
                        'Total Events: ${controller.statsResponse!.stats!.noOfEvents}',
                      ),
                      _buildDataContainer(
                        'Total Income: ${controller.statsResponse!.stats!.totalIncome}',
                      ),
                      _buildDataContainer(
                        'Total Blood Requests: ${controller.statsResponse!.stats!.totalBloodRequests}',
                      ),
                      _buildDataContainer(
                        'Total Donors: ${controller.statsResponse!.stats!.totalDonors}',
                      ),
                      _buildDataContainer(
                        'Total Users: ${controller.statsResponse!.stats!.totalUsers}',
                      ),
                      _buildDataContainer(
                        'Total UniqueDonors: ${controller.statsResponse!.stats!.totalUniqueDonors}',
                      ),
                    ],
                  ),
                ],
              );
            } else {
              // Display a message if no data is available
              return Text(
                'No data available',
                style: TextStyle(fontSize: 20),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDataContainer(String data) {
    return Card(
      elevation: 15,
      margin: EdgeInsets.symmetric(
          horizontal: 10, vertical: 15), // Adjust vertical margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        // Wrap the Padding with a Container
        padding: EdgeInsets.all(12.0),
        height: 80, // Set desired height
        child: Center(
          child: Text(
            data,
            style: TextStyle(fontSize: 19),
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(AdminDashboardController controller) {
    var now = DateTime.now();
    var formatter = DateFormat('HH');
    var hour = int.parse(formatter.format(now));

    String greeting = '';

    if (hour >= 5 && hour < 12) {
      greeting = 'Good morning';
    } else if (hour >= 12 && hour < 18) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    String fullName =
        controller.user?.user?.fullName ?? ''; // Get the user's full name

    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            '$greeting, $fullName', // Display the greeting and full name
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
