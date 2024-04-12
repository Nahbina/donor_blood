// To parse this JSON data, do
//
//     final adminUsers = adminUsersFromJson(jsonString);

import 'dart:convert';

AdminUsers adminUsersFromJson(String str) =>
    AdminUsers.fromJson(json.decode(str));

String adminUsersToJson(AdminUsers data) => json.encode(data.toJson());

class AdminUsers {
  final bool? success;
  final List<User>? users;

  AdminUsers({
    this.success,
    this.users,
  });

  factory AdminUsers.fromJson(Map<String, dynamic> json) => AdminUsers(
        success: json["success"],
        users: json["users"] == null
            ? []
            : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
      };
}

class User {
  final String? userId;
  final String? fullName;
  final String? password;
  final String? email;
  final String? role;

  User({
    this.userId,
    this.fullName,
    this.password,
    this.email,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        fullName: json["full_name"],
        password: json["password"],
        email: json["email"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "full_name": fullName,
        "password": password,
        "email": email,
        "role": role,
      };
}
