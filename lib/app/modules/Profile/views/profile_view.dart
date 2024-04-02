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
        backgroundColor: Colors.red,
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

          return SingleChildScrollView(
            // Wrap your Column with SingleChildScrollView
            child: Center(
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
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit Profile'),
                    onTap: () {
                      Get.to(() => EditProfileForm());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.light),
                    title: const Text('Switch Theme'),
                    trailing: Get.isDarkMode
                        ? const Icon(Icons.light_mode)
                        : const Icon(Icons.dark_mode),
                    onTap: () {
                      Get.changeTheme(Get.isDarkMode
                          ? ThemeData.light()
                          : ThemeData.dark());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Language'),
                    onTap: () {
                      // Add logic to change language
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Change Password'),
                    onTap: () {
                      Get.to(() => CHANGE_PASSWORD());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Logout'),
                            content: Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Memory.clear();
                                  Get.offAllNamed(Routes.LOGIN);
                                },
                                child: Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text('No'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class EditProfileForm extends StatelessWidget {
  final ProfileController profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: profileController.fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: profileController.emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  profileController.editProfile(
                    profileController.fullNameController.text,
                    profileController.emailController.text,
                  );
                  Get.back();
                },
                child: Text('Save'),
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
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.red),
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
