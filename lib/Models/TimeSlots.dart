// To parse this JSON data, do
//
//     final timeSlots = timeSlotsFromJson(jsonString);

import 'dart:convert';

import 'Timings.dart';
List<TimeSlots> timeSlotsFromJson(String str) => List<TimeSlots>.from(json.decode(str).map((x) => TimeSlots.fromJson(x)));

String timeSlotsToJson(List<TimeSlots> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TimeSlots {
  TimeSlots({
    this.slotNumber,
    this.timeObj,
    this.totalAvailable,
    this.totalBooked,
    this.bookedByUser,
  });

  int? slotNumber;
  TimeObj? timeObj;
  int? totalAvailable;
  int? totalBooked;
  bool? bookedByUser;

  factory TimeSlots.fromJson(Map<String, dynamic> json) => TimeSlots(
    slotNumber: json["slotNumber"],
    timeObj: TimeObj.fromJson(json["timeObj"]),
    totalAvailable: json["totalAvailable"] ?? 0,
    totalBooked: json["totalBooked"] ?? 0,
    bookedByUser: json["bookedByUser"],
  );

  Map<String, dynamic> toJson() => {
    "slotNumber": slotNumber,
    "timeObj": timeObj?.toJson(),
    "totalAvailable": totalAvailable,
    "totalBooked": totalBooked,
    "bookedByUser": bookedByUser,
  };
}