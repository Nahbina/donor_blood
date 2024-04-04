// To parse this JSON data, do
//
//     final donor = donorFromJson(jsonString);

import 'dart:convert';

Donor donorFromJson(String str) => Donor.fromJson(json.decode(str));

String donorToJson(Donor data) => json.encode(data.toJson());

class Donor {
  final bool? success;
  final String? message;
  final List<DonorElement>? donors;

  Donor({
    this.success,
    this.message,
    this.donors,
  });

  factory Donor.fromJson(Map<String, dynamic> json) => Donor(
        success: json["success"],
        message: json["message"],
        donors: json["donors"] == null
            ? []
            : List<DonorElement>.from(
                json["donors"]!.map((x) => DonorElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "donors": donors == null
            ? []
            : List<dynamic>.from(donors!.map((x) => x.toJson())),
      };
}

class DonorElement {
  final int? donorId;
  final int? userId;
  final String? bloodType;
  final DateTime? birthDate;
  final String? lastDonationDate;
  final String? avatar;
  final String? phoneNumber;
  final String? fullName;
  final String? Address;

  DonorElement({
    this.donorId,
    this.userId,
    this.bloodType,
    this.birthDate,
    this.lastDonationDate,
    this.avatar,
    this.phoneNumber,
    this.fullName,
    this.Address,
  });

  factory DonorElement.fromJson(Map<String, dynamic> json) => DonorElement(
        donorId: json["donor_id"],
        userId: json["user_id"],
        bloodType: json["blood_type"],
        birthDate: json["birth_date"] == null
            ? null
            : DateTime.parse(json["birth_date"]),
        lastDonationDate: json["last_donation_date"],
        avatar: json["avatar"],
        phoneNumber: json["phoneNumber"],
        fullName: json["full_name"],
        Address: json["Address"],
      );

  Map<String, dynamic> toJson() => {
        "donor_id": donorId,
        "user_id": userId,
        "blood_type": bloodType,
        "birth_date":
            "${birthDate!.year.toString().padLeft(4, '0')}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}",
        "last_donation_date": lastDonationDate,
        "avatar": avatar,
        "phoneNumber": phoneNumber,
        "full_name": fullName,
        "Address": Address,
      };
}
