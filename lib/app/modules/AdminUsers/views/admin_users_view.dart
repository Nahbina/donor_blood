import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/AdminUsers.dart';
import '../../../utils/constants.dart';
import '../controllers/admin_users_controller.dart';

class AdminUsersView extends GetView<AdminUsersController> {
  const AdminUsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize AdminUsersController here
    final controller = Get.put(AdminUsersController());

    return Scaffold(
      body: Obx(() {
        if (controller.users.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            children: [
              DataTable(
                columns: [
                  DataColumn(label: Text('User ID')),
                  DataColumn(label: Text('Full Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Role')),
                  // DataColumn(label: Text('Password')),
                  DataColumn(label: Text('Actions')), // Add actions column
                ],
                rows: controller.users.map((User user) {
                  // Change the map type to User
                  return DataRow(cells: [
                    DataCell(Text(user.userId ??
                        '')), // Access properties using model getters
                    DataCell(Text(user.fullName ?? '')),
                    DataCell(Text(user.email ?? '')),
                    DataCell(Text(user.role ?? '')),
                    // DataCell(Text(user.password ?? '')),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Navigate to the edit user page
                            showDialog(
                              context: context,
                              builder: (context) => EditUserDialog(user: user),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete User'),
                                  content: const Text(
                                      'Are you sure you want to delete this user?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        final userId = user.userId;
                                        if (userId != null) {
                                          controller.deleteUser(userId);
                                        } else {
                                          showCustomSnackBar(
                                            message: 'User ID is required.',
                                            isSuccess: false,
                                          );
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ],
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUserDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    TextEditingController idController = TextEditingController();
    TextEditingController fullNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController roleController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add User"),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: idController,
                  decoration: InputDecoration(labelText: 'User ID'),
                ),
                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: roleController,
                  decoration: InputDecoration(labelText: 'Role'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () {
                User newUser = User(
                  userId: idController.text,
                  fullName: fullNameController.text,
                  email: emailController.text,
                  role: roleController.text,
                  password: passwordController.text,
                );
                // Call the method to add the new user
                Get.find<AdminUsersController>().addUser(newUser);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class EditUserDialog extends StatelessWidget {
  final User user;

  const EditUserDialog({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController idController =
        TextEditingController(text: user.userId);
    TextEditingController fullNameController =
        TextEditingController(text: user.fullName);
    TextEditingController emailController =
        TextEditingController(text: user.email);
    TextEditingController roleController =
        TextEditingController(text: user.role);
    TextEditingController passwordController =
        TextEditingController(text: user.password);

    return AlertDialog(
      title: const Text("Edit User"),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: 'User ID'),
            ),
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: roleController,
              decoration: InputDecoration(labelText: 'Role'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("Save"),
          onPressed: () {
            User editedUser = User(
              userId:
                  user.userId, // Keep the userId from the original user object
              fullName: fullNameController.text,
              email: emailController.text,
              role: roleController.text,
              password: passwordController.text,
            );
            Get.find<AdminUsersController>().editUser(editedUser);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
