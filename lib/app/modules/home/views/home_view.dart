import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DONOR BLOOD'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Bar Container
            Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color.fromRGBO(218, 218, 218, 1),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: 8),
                  Expanded(child: Container()),
                  Icon(Icons.search),
                  SizedBox(width: 8),
                ],
              ),
            ),
            SizedBox(
                height: 16), // Adjust spacing between search bar and containers

            // Main Container for functionalities
            Container(
              height: 120,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Adjust as needed
                children: [
                  _buildFunctionalityContainer(
                      context, 'Add Donor', Icons.person_add, () {
                    // Navigate to Add Donor Screen
                  }),
                  _buildFunctionalityContainer(
                      context, 'Request Donor', Icons.request_page, () {
                    // Navigate to Request Donor Screen
                  }),
                  _buildFunctionalityContainer(
                      context, 'Donation', Icons.favorite, () {
                    // Navigate to Donation Screen
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFunctionalityContainer(BuildContext context, String title,
      IconData iconData, Function() onPressed) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Color.fromRGBO(218, 218, 218, 1),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 40,
                color: Colors.red,
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
