import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:tajammul_customer_app/Models/BusinessDetails.dart';
import 'package:tajammul_customer_app/Models/BusinessInfo.dart';
import 'package:tajammul_customer_app/Models/Timings.dart';
import 'package:tajammul_customer_app/Models/users.dart';

part 'Business.g.dart';


List<Business> businessFromJson(String str) => List<Business>.from(json.decode(str).map((x) => Business.fromJson(x)));

String businessToJson(List<Business> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 1)
class Business {
  Business({
    this.businessId,
    this.users,
    this.businessInfo,
    this.businessDetails,
    this.timings,
    this.createdAt,
    this.lastModifiedAt,
    this.isOpened
  });

  @HiveField(0)
  String? businessId;

  List<Users>? users;

  BusinessInfo? businessInfo;

  BusinessDetails? businessDetails;

  Timings? timings;

  String? createdAt;

  String? lastModifiedAt;

  bool? isOpened;

  factory Business.fromJson(Map<String, dynamic> json) => Business(
    businessId: json["businessId"],
    users:List<Users>.from(json["users"]?.map((x) => Users.fromJson(x)) ?? []),
    businessInfo: BusinessInfo.fromJson(json["businessInfo"] ?? {} ),
    businessDetails: BusinessDetails.fromJson(json["businessDetails"] ?? {}),
    timings: Timings.fromJson(json["timings"] ?? {}),
    createdAt: json["createdAt"],
    lastModifiedAt: json["lastModifiedAt"],
    isOpened: json["isOpened"]
  );

  Map<String, dynamic> toJson() => {
    "businessId": businessId,
    "users": List<Users>.from(users?.map((x) => x) ?? []),
    "businessInfo": businessInfo?.toJson(),
    "businessDetails": businessDetails?.toJson(),
    "timings": timings?.toJson(),
    "createdAt": createdAt,
    "lastModifiedAt": lastModifiedAt,
    "isOpened" : isOpened
  };
}