// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

UserResponse userResponseFromJson(String str) =>
    UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  final bool? success;
  final String? message;
  final User? user;

  UserResponse({
    this.success,
    this.message,
    this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        success: json["success"],
        message: json["message"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "user": user?.toJson(),
      };
}

class User {
  final String? userId;
  final String? email;
  final String? fullName;
  final String? role;
  final String? address;

  User({
    this.userId,
    this.email,
    this.fullName,
    this.role,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        email: json["email"],
        fullName: json["full_name"],
        role: json["role"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "email": email,
        "full_name": fullName,
        "role": role,
        "address": address,
      };
}
