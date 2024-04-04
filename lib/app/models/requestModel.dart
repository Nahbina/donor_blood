// To parse this JSON data, do
//
//     final bloodRequest = bloodRequestFromJson(jsonString);

import 'dart:convert';

BloodRequest bloodRequestFromJson(String str) =>
    BloodRequest.fromJson(json.decode(str));

String bloodRequestToJson(BloodRequest data) => json.encode(data.toJson());

class BloodRequest {
  final bool? success;
  final String? message;
  final List<Request>? requests;

  BloodRequest({
    this.success,
    this.message,
    this.requests,
  });

  factory BloodRequest.fromJson(Map<String, dynamic> json) => BloodRequest(
        success: json["success"],
        message: json["message"],
        requests: json["requests"] == null
            ? []
            : List<Request>.from(
                json["requests"]!.map((x) => Request.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "requests": requests == null
            ? []
            : List<dynamic>.from(requests!.map((x) => x.toJson())),
      };
}

class Request {
  final int? requestId;
  final int? userId;
  final int? donorId;
  final String? status;
  final DateTime? requestDate;

  Request({
    this.requestId,
    this.userId,
    this.donorId,
    this.status,
    this.requestDate,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        requestId: json["request_id"] is int
            ? json["request_id"]
            : int.tryParse(json["request_id"]),
        userId: json["user_id"] is int
            ? json["user_id"]
            : int.tryParse(json["user_id"]),
        donorId: json["donor_id"] is int
            ? json["donor_id"]
            : int.tryParse(json["donor_id"]),
        status: json["status"],
        requestDate: json["request_date"] == null
            ? null
            : DateTime.parse(json["request_date"]),
      );

  Map<String, dynamic> toJson() => {
        "request_id": requestId,
        "user_id": userId,
        "donor_id": donorId,
        "status": status,
        "request_date":
            "${requestDate!.year.toString().padLeft(4, '0')}-${requestDate!.month.toString().padLeft(2, '0')}-${requestDate!.day.toString().padLeft(2, '0')}",
      };
}
