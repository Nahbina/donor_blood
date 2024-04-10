// To parse this JSON data, do
//
//     final statics = staticsFromJson(jsonString);

import 'dart:convert';

Statics staticsFromJson(String str) => Statics.fromJson(json.decode(str));

String staticsToJson(Statics data) => json.encode(data.toJson());

class Statics {
  final bool? success;
  final String? message;
  final Stats? stats;

  Statics({
    this.success,
    this.message,
    this.stats,
  });

  factory Statics.fromJson(Map<String, dynamic> json) => Statics(
        success: json["success"],
        message: json["message"],
        stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "stats": stats?.toJson(),
      };
}

class Stats {
  final String? noOfEvents;
  final String? totalIncome;
  final String? totalBloodRequests;
  final String? totalDonors;
  final String? totalUsers;
  final String? totalUniqueDonors;

  Stats({
    this.noOfEvents,
    this.totalIncome,
    this.totalBloodRequests,
    this.totalDonors,
    this.totalUsers,
    this.totalUniqueDonors,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        noOfEvents: json["no_of_events"],
        totalIncome: json["totalIncome"],
        totalBloodRequests: json["totalBloodRequests"],
        totalDonors: json["totalDonors"],
        totalUsers: json["totalUsers"],
        totalUniqueDonors: json["totalUniqueDonors"],
      );

  Map<String, dynamic> toJson() => {
        "no_of_events": noOfEvents,
        "totalIncome": totalIncome,
        "totalBloodRequests": totalBloodRequests,
        "totalDonors": totalDonors,
        "totalUsers": totalUsers,
        "totalUniqueDonors": totalUniqueDonors,
      };
}
