import 'dart:convert';

import 'package:tajammul_customer_app/Models/Service.dart';

import 'Timings.dart';

List<BookingDetails> bookingDetailsFromJson(String str) => List<BookingDetails>.from(json.decode(str).map((x) => BookingDetails.fromJson(x)));

String bookingDetailsToJson(List<BookingDetails> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookingDetails {
  BookingDetails({
    this.serviceCartItems,
    this.slotNumber,
    this.timeObj,
    this.totalAmount,
  });

  Service? serviceCartItems;
  int? slotNumber;
  TimeObj? timeObj;
  double? totalAmount;

  factory BookingDetails.fromJson(Map<String, dynamic> json) => BookingDetails(
    serviceCartItems: Service.fromJson(json["serviceCartItems"]),
    slotNumber: json["slotNumber"],
    timeObj: TimeObj.fromJson(json["timeObj"]),
    totalAmount: json["totalAmount"],
  );

  Map<String, dynamic> toJson() => {
    "serviceCartItems": serviceCartItems?.toJson(),
    "slotNumber": slotNumber,
    "timeObj": timeObj?.toJson(),
    "totalAmount": totalAmount,
  };
}