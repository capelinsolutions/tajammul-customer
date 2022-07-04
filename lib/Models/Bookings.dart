import 'dart:convert';

import 'BookingDetails.dart';
import 'Business.dart';

List<Bookings> bookingsFromJson(String str) => List<Bookings>.from(json.decode(str).map((x) => Bookings.fromJson(x)));

String bookingsToJson(List<Bookings> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bookings {
  Bookings({
    this.bookingId,
    this.business,
    this.bookingDetails,
  });

  String? bookingId;
  Business? business;
  BookingDetails? bookingDetails;

  factory Bookings.fromJson(Map<String, dynamic> json) => Bookings(
    bookingId: json["bookingId"],
    business: Business.fromJson(json["business"]),
    bookingDetails: BookingDetails.fromJson(json["bookingDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "bookingId": bookingId,
    "business": business?.toJson(),
    "bookingDetails": bookingDetails?.toJson(),
  };
}