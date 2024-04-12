// To parse this JSON data, do
//
//     final ratings = ratingsFromJson(jsonString);

import 'dart:convert';

Ratings ratingsFromJson(String str) => Ratings.fromJson(json.decode(str));

String ratingsToJson(Ratings data) => json.encode(data.toJson());

class Ratings {
  final bool? success;
  final List<Rating>? ratings;

  Ratings({
    this.success,
    this.ratings,
  });

  factory Ratings.fromJson(Map<String, dynamic> json) => Ratings(
        success: json["success"],
        ratings: json["ratings"] == null
            ? []
            : List<Rating>.from(
                json["ratings"]!.map((x) => Rating.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "ratings": ratings == null
            ? []
            : List<dynamic>.from(ratings!.map((x) => x.toJson())),
      };
}

class Rating {
  final String? ratingId;
  final String? userId;
  final String? rating;
  final DateTime? createdAt;
  final String? comment;
  final String? fullName;
  final String? email;

  Rating({
    this.ratingId,
    this.userId,
    this.rating,
    this.createdAt,
    this.comment,
    this.fullName,
    this.email,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        ratingId: json["rating_Id"],
        userId: json["user_id"],
        rating: json["rating"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        comment: json["comment"],
        fullName: json["full_name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "rating_Id": ratingId,
        "user_id": userId,
        "rating": rating,
        "created_at": createdAt?.toIso8601String(),
        "comment": comment,
        "full_name": fullName,
        "email": email,
      };
}
