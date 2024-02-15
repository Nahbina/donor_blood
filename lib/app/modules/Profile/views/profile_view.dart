import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/memory.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // Update UI based on the selected item
              },
            ),
            ListTile(
              title: const Text('Change Password'),
              onTap: () {
                // Update UI based on the selected item
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                // Fix logout functionality
                await Memory.clear();
                Get.offAllNamed(Routes.LOGIN);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/images/logo.png'), // Replace with actual user's profile picture
            ),
            const SizedBox(height: 10),
            const Text(
              'User Name', // Replace with actual user's name
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'user@example.com', // Replace with actual user's email
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'Blood Type: O+', // Replace with actual user's blood type
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                // Logic to edit profile or navigate to another page
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
