// To parse this JSON data, do
//
//     final donors = donorsFromJson(jsonString);

import 'dart:convert';

Donors donorsFromJson(String str) => Donors.fromJson(json.decode(str));

String donorsToJson(Donors data) => json.encode(data.toJson());

class Donors {
  final bool? success;
  final String? message;
  final List<Donor>? donors;

  Donors({
    this.success,
    this.message,
    this.donors,
  });

  factory Donors.fromJson(Map<String, dynamic> json) => Donors(
        success: json["success"],
        message: json["message"],
        donors: json["donors"] == null
            ? []
            : List<Donor>.from(json["donors"]!.map((x) => Donor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "donors": donors == null
            ? []
            : List<dynamic>.from(donors!.map((x) => x.toJson())),
      };
}

class Donor {
  final int? donorId;
  final String? fullName;
  final int? userId;
  final String? bloodType;
  final DateTime? birthDate;
  final DateTime? lastDonationDate;
  final String? avatar;
  final String? phoneNumber;

  Donor({
    this.donorId,
    this.fullName,
    this.userId,
    this.bloodType,
    this.birthDate,
    this.lastDonationDate,
    this.avatar,
    this.phoneNumber,
  });

  factory Donor.fromJson(Map<String, dynamic> json) => Donor(
        donorId: json["donor_id"],
        fullName: json["full_name"],
        userId: json["user_id"],
        bloodType: json["blood_type"],
        birthDate: json["birth_date"] == null
            ? null
            : DateTime.parse(json["birth_date"]),
        lastDonationDate: json["last_donation_date"] == null
            ? null
            : DateTime.parse(json["last_donation_date"]),
        avatar: json["avatar"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "donor_id": donorId,
        "full_name": fullName,
        "user_id": userId,
        "blood_type": bloodType,
        "birth_date": birthDate?.toIso8601String(),
        "last_donation_date": lastDonationDate?.toIso8601String(),
        "avatar": avatar,
        "phoneNumber": phoneNumber,
      };
}
