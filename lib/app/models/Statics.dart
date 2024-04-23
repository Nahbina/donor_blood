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
  final dynamic totalIncome;
  final String? totalBloodRequests;
  final String? totalDonors;
  final String? totalUsers;
  final String? totalAGroup;
  final String? totalBGroup;
  final String? totalAbGroup;
  final String? totalOGroup;
  final String? totalANegativeGroup;
  final String? totalBNegativeGroup;
  final String? totalAbNegativeGroup;
  final String? totalONegativeGroup;
  final String? totalUniqueDonors;

  Stats({
    this.noOfEvents,
    this.totalIncome,
    this.totalBloodRequests,
    this.totalDonors,
    this.totalUsers,
    this.totalAGroup,
    this.totalBGroup,
    this.totalAbGroup,
    this.totalOGroup,
    this.totalANegativeGroup,
    this.totalBNegativeGroup,
    this.totalAbNegativeGroup,
    this.totalONegativeGroup,
    this.totalUniqueDonors,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        noOfEvents: json["no_of_events"],
        totalIncome: json["totalIncome"],
        totalBloodRequests: json["totalBloodRequests"],
        totalDonors: json["totalDonors"],
        totalUsers: json["totalUsers"],
        totalAGroup: json["totalAGroup"],
        totalBGroup: json["totalBGroup"],
        totalAbGroup: json["totalABGroup"],
        totalOGroup: json["totalOGroup"],
        totalANegativeGroup: json["totalA_Negative_Group"],
        totalBNegativeGroup: json["totalB_Negative_Group"],
        totalAbNegativeGroup: json["totalAB_Negative_Group"],
        totalONegativeGroup: json["totalO_Negative_Group"],
        totalUniqueDonors: json["totalUniqueDonors"],
      );

  Map<String, dynamic> toJson() => {
        "no_of_events": noOfEvents,
        "totalIncome": totalIncome,
        "totalBloodRequests": totalBloodRequests,
        "totalDonors": totalDonors,
        "totalUsers": totalUsers,
        "totalAGroup": totalAGroup,
        "totalBGroup": totalBGroup,
        "totalABGroup": totalAbGroup,
        "totalOGroup": totalOGroup,
        "totalA_Negative_Group": totalANegativeGroup,
        "totalB_Negative_Group": totalBNegativeGroup,
        "totalAB_Negative_Group": totalAbNegativeGroup,
        "totalO_Negative_Group": totalONegativeGroup,
        "totalUniqueDonors": totalUniqueDonors,
      };
}
