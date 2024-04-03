// To parse this JSON data, do
//
//     final donationHistory = donationHistoryFromJson(jsonString);

import 'dart:convert';

DonationHistory donationHistoryFromJson(String str) =>
    DonationHistory.fromJson(json.decode(str));

String donationHistoryToJson(DonationHistory data) =>
    json.encode(data.toJson());

class DonationHistory {
  final bool? success;
  final List<DonationHistoryElement>? donationHistory;

  DonationHistory({
    this.success,
    this.donationHistory,
  });

  factory DonationHistory.fromJson(Map<String, dynamic> json) =>
      DonationHistory(
        success: json["success"],
        donationHistory: json["donation_history"] == null
            ? []
            : List<DonationHistoryElement>.from(json["donation_history"]!
                .map((x) => DonationHistoryElement.fromJson(x))),
      );

  get message => null;

  Map<String, dynamic> toJson() => {
        "success": success,
        "donation_history": donationHistory == null
            ? []
            : List<dynamic>.from(donationHistory!.map((x) => x.toJson())),
      };
}

class DonationHistoryElement {
  final int? donationHistoryId;
  final int? donorId;
  final int? requestId;
  final DateTime? donationDate;
  final DateTime? createdAt;

  DonationHistoryElement({
    this.donationHistoryId,
    this.donorId,
    this.requestId,
    this.donationDate,
    this.createdAt,
  });

  factory DonationHistoryElement.fromJson(Map<String, dynamic> json) =>
      DonationHistoryElement(
        donationHistoryId: json["donationHistory_Id"],
        donorId: json["donor_id"],
        requestId: json["request_id"],
        donationDate: json["donation_date"] == null
            ? null
            : DateTime.parse(json["donation_date"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "donationHistory_Id": donationHistoryId,
        "donor_id": donorId,
        "request_id": requestId,
        "donation_date":
            "${donationDate!.year.toString().padLeft(4, '0')}-${donationDate!.month.toString().padLeft(2, '0')}-${donationDate!.day.toString().padLeft(2, '0')}",
        "created_at": createdAt?.toIso8601String(),
      };
}
