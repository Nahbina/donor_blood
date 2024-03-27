// To parse this JSON data, do
//
//     final notifications = notificationsFromJson(jsonString);

import 'dart:convert';

Notifications notificationsFromJson(String str) =>
    Notifications.fromJson(json.decode(str));

String notificationsToJson(Notifications data) => json.encode(data.toJson());

class Notifications {
  final bool? success;
  final String? message;
  final List<Notification>? notifications;

  Notifications({
    this.success,
    this.message,
    this.notifications,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        success: json["success"],
        message: json["message"],
        notifications: json["notifications"] == null
            ? []
            : List<Notification>.from(
                json["notifications"]!.map((x) => Notification.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "notifications": notifications == null
            ? []
            : List<dynamic>.from(notifications!.map((x) => x.toJson())),
      };
}

class Notification {
  final String? notificationId;
  final String? userId;
  final String? requestId;
  final String? message;
  final DateTime? createdAt;

  Notification({
    this.notificationId,
    this.userId,
    this.requestId,
    this.message,
    this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        notificationId: json["Notification_Id"],
        userId: json["user_id"],
        requestId: json["request_id"],
        message: json["message"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "Notification_Id": notificationId,
        "user_id": userId,
        "request_id": requestId,
        "message": message,
        "created_at": createdAt?.toIso8601String(),
      };
}
