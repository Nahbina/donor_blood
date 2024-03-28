// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final bool? success;
  final String? message;
  final UserClass? user;

  User({
    this.success,
    this.message,
    this.user,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        success: json["success"],
        message: json["message"],
        user: json["user"] == null ? null : UserClass.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "user": user?.toJson(),
      };
}

class UserClass {
  final String? userId;
  final String? fullName;
  final String? email;
  final String? role;

  UserClass({
    this.userId,
    this.fullName,
    this.email,
    this.role,
  });

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        userId: json["user_id"],
        fullName: json["full_name"],
        email: json["email"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "full_name": fullName,
        "email": email,
        "role": role,
      };
}
