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
  final String? totalBloodRequest;
  final String? totalDonors;
  final String? totalUsers;

  Stats({
    this.noOfEvents,
    this.totalIncome,
    this.totalBloodRequest,
    this.totalDonors,
    this.totalUsers,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        noOfEvents: json["no_of_events"],
        totalIncome: json["totalIncome"],
        totalBloodRequest: json["totalBloodRequest"],
        totalDonors: json["totalDonors"],
        totalUsers: json["totalUsers"],
      );

  Map<String, dynamic> toJson() => {
        "no_of_events": noOfEvents,
        "totalIncome": totalIncome,
        "totalBloodRequest": totalBloodRequest,
        "totalDonors": totalDonors,
        "totalUsers": totalUsers,
      };
}
