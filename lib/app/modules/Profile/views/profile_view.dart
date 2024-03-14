import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/memory.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late ProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _profileController = Get.put(ProfileController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: SingleChildScrollView(
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
              ListTile(
                title: const Text(
                  'Edit profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Add logic for updating status
                },
              ),
              ListTile(
                title: const Text(
                  'Donation history',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Add logic for updating status
                },
              ),
              ListTile(
                title: const Text(
                  'My Status',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Add logic for updating status
                },
              ),
              ListTile(
                title: const Text(
                  'Change Password',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to the change password page
                  Get.to(CHANGE_PASSWORD());
                },
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
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
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CHANGE_PASSWORD extends StatefulWidget {
  const CHANGE_PASSWORD({Key? key}) : super(key: key);

  @override
  State<CHANGE_PASSWORD> createState() => _CHANGE_PASSWORDState();
}

class _CHANGE_PASSWORDState extends State<CHANGE_PASSWORD> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              // Add text form fields for old and new password
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Colors.green), //<-- SEE HERE
                  ),
                  labelText: 'Old Password'),
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
