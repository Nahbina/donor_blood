import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/memory.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          if (controller.user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final user = controller.user!.user;

          return Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                CircleAvatar(
                  radius: 75,
                  child: Text(
                    user?.fullName?[0] ?? 'U',
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  user?.fullName ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  user?.email ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  user?.role?.toUpperCase() ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: const Text('Switch Theme'),
                  trailing: Get.isDarkMode
                      ? const Icon(Icons.light_mode)
                      : const Icon(Icons.dark_mode),
                  onTap: () {
                    Get.changeTheme(
                        Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
                  },
                ),
                ListTile(
                  title: const Text('Language'),
                  onTap: () {
                    // Add logic to change language
                  },
                ),
                ListTile(
                  title: const Text('Change Password'),
                  onTap: () {
                    Get.to(CHANGE_PASSWORD());
                  },
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: Colors.grey[300],
                    leading: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(Icons.logout),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Logout'),
                            content: const Text(
                              'Are you sure you want to logout?',
                            ),
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
                  ),
                ),
              ],
            ),
          );
        },
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
  final ProfileController profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: profileController.oldPasswordController,
              decoration: const InputDecoration(
                labelText: 'Old Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: profileController.newPasswordController,
              decoration: const InputDecoration(
                labelText: 'New Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String token = Memory.getToken() ?? 'default_token';
                profileController.changePassword(
                  profileController.oldPasswordController.text,
                  profileController.newPasswordController.text,
                  token,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
