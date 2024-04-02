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
                        'Total Blood Requests: ${controller.statsResponse!.stats!.totalBloodRequest}',
                      ),
                      _buildDataContainer(
                        'Total Donors: ${controller.statsResponse!.stats!.totalDonors}',
                      ),
                      _buildDataContainer(
                        'Total Users: ${controller.statsResponse!.stats!.totalUsers}',
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

  // Method to build a container for data display
  Widget _buildDataContainer(String data) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        data,
        style: TextStyle(fontSize: 20),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, $fullName', // Display the greeting and full name
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
