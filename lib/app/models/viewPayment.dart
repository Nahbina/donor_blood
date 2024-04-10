// To parse this JSON data, do
//
//     final viewPayment = viewPaymentFromJson(jsonString);

import 'dart:convert';

ViewPayment viewPaymentFromJson(String str) =>
    ViewPayment.fromJson(json.decode(str));

String viewPaymentToJson(ViewPayment data) => json.encode(data.toJson());

class ViewPayment {
  final bool? success;
  final List<Payment>? payments;

  ViewPayment({
    this.success,
    this.payments,
  });

  factory ViewPayment.fromJson(Map<String, dynamic> json) => ViewPayment(
        success: json["success"],
        payments: json["payments"] == null
            ? []
            : List<Payment>.from(
                json["payments"]!.map((x) => Payment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "payments": payments == null
            ? []
            : List<dynamic>.from(payments!.map((x) => x.toJson())),
      };
}

class Payment {
  final String? paymentId;
  final String? userId;
  final String? fullName;
  final String? email;
  final String? amount;
  final String? details;
  final DateTime? paymentDate;
  final String? status;

  Payment({
    this.paymentId,
    this.userId,
    this.fullName,
    this.email,
    this.amount,
    this.details,
    this.paymentDate,
    this.status,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        paymentId: json["payment_id"],
        userId: json["user_id"],
        fullName: json["full_name"],
        email: json["email"],
        amount: json["amount"],
        details: json["details"],
        paymentDate: json["payment_date"] == null
            ? null
            : DateTime.parse(json["payment_date"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "payment_id": paymentId,
        "user_id": userId,
        "full_name": fullName,
        "email": email,
        "amount": amount,
        "details": details,
        "payment_date": paymentDate?.toIso8601String(),
        "status": status,
      };
}
