import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../models/AdminUsers.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class AdminUsersController extends GetxController {
  final RxList<User> users = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      var url = Uri.http(ipAddress, '/donor_blood_api/admin/getUsers.php');
      var token = await Memory.getToken();

      if (token == null) {
        showCustomSnackBar(
          message: 'User not authenticated.',
          isSuccess: false,
        );
        return;
      }

      var response = await http.post(
        url,
        body: {'token': token},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          // Convert JSON data to list of User objects
          List<User> userList = [];
          for (var userData in data['users']) {
            userList.add(User.fromJson(userData));
          }
          users.assignAll(userList);
          showCustomSnackBar(
            message: 'Users fetched successfully',
            isSuccess: true,
          );
        } else {
          showCustomSnackBar(
            message: data['message'] ?? 'Failed to fetch users',
            isSuccess: false,
          );
        }
      } else {
        showCustomSnackBar(
          message: 'Failed to load users: ${response.statusCode}',
          isSuccess: false,
        );
      }
    } catch (e) {
      print('Error fetching users: $e');
      showCustomSnackBar(
        message: 'Failed to fetch users: $e',
        isSuccess: false,
      );
    }
  }

  Future<void> addUser(User newUser) async {
    try {
      var url = Uri.http(ipAddress, '/donor_blood_api/admin/addUsers.php');
      var token = await Memory.getToken();

      if (token == null) {
        showCustomSnackBar(
          message: 'User not authenticated.',
          isSuccess: false,
        );
        return;
      }
      var response = await http.post(
        url,
        body: {
          'token': token,
          'user_id': newUser.userId ?? '',
          'full_name': newUser.fullName ?? '',
          'email': newUser.email ?? '',
          'role': newUser.role ?? '',
          'password': newUser.password ?? '',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          users.add(newUser);
          showCustomSnackBar(
            message: 'User added successfully',
            isSuccess: true,
          );
        } else {
          showCustomSnackBar(
            message: data['message'] ?? 'Failed to add user',
            isSuccess: false,
          );
        }
      } else {
        showCustomSnackBar(
          message: 'Failed to add user: ${response.statusCode}',
          isSuccess: false,
        );
      }
    } catch (e) {
      print('Error adding user: $e');
      showCustomSnackBar(
        message: 'Failed to add user: $e',
        isSuccess: false,
      );
    }
  }

  Future<void> editUser(User user) async {
    try {
      var url = Uri.http(ipAddress, '/donor_blood_api/admin/editUsers.php');
      var token = await Memory.getToken();

      if (token == null) {
        showCustomSnackBar(
          message: 'User not authenticated.',
          isSuccess: false,
        );
        return;
      }

      var response = await http.post(
        url,
        body: {
          'token': token,
          'user_id': user.userId ?? '',
          'full_Name': user.fullName ?? '',
          'email': user.email ?? '',
          'role': user.role ?? '',
          'password': user.password ?? '',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          // Update the user in the list
          int index = users.indexWhere((u) => u.userId == user.userId);
          if (index != -1) {
            users[index] = user;
            showCustomSnackBar(
              message: 'User updated successfully',
              isSuccess: true,
            );
          } else {
            showCustomSnackBar(
              message: 'User not found in the list',
              isSuccess: false,
            );
          }
        } else {
          showCustomSnackBar(
            message: data['message'] ?? 'Failed to edit user',
            isSuccess: false,
          );
        }
      } else {
        showCustomSnackBar(
          message: 'Failed to edit user: ${response.statusCode}',
          isSuccess: false,
        );
      }
    } catch (e) {
      print('Error editing user: $e');
      showCustomSnackBar(
        message: 'Failed to edit user: $e',
        isSuccess: false,
      );
    }
  }

  void deleteUser(String userId) async {
    try {
      var url = Uri.http(ipAddress, 'donor_blood_api/admin/deleteUsers.php');
      var response = await http.post(url, body: {
        'token': Memory.getToken(),
        'user_id': userId, // Change 'userId' to 'user_id'
      });

      print('Delete User Response: ${response.body}');

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        if (result['success']) {
          users.removeWhere((event) => event.userId == userId);
          Get.back();
          showCustomSnackBar(
            message: result['message'],
            isSuccess: true,
          );
        } else {
          showCustomSnackBar(
            message: result['message'],
          );
        }
      } else {
        // If the response status code is not 200, handle it accordingly
        showCustomSnackBar(
          message: 'Failed to delete user. Status code: ${response.statusCode}',
          isSuccess: false,
        );
      }
    } catch (e) {
      showCustomSnackBar(
        message: 'Something went wrong: $e',
      );
    }
  }
}
