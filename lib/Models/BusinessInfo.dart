
import 'dart:convert';


import 'AddressData.dart';

BusinessInfo businessInfoFromJson(String str) => BusinessInfo.fromJson(json.decode(str));

String businessInfoToJson(BusinessInfo data) => json.encode(data.toJson());

class BusinessInfo {
  BusinessInfo({
    this.name,
    this.address,
    this.imagePath,
    this.ntn,
    this.salesTax,
    this.businessTypes,
    this.listImagePath
  });

  String? name;
  String? ntn;
  String? salesTax;
  Address? address;
  List<String>? imagePath;
  List<String>? listImagePath;
  List<String>? businessTypes;

  factory BusinessInfo.fromJson(Map<String, dynamic> json) => BusinessInfo(
    name: json["name"],
    address: Address.fromJson(json["address"] ?? {}),
      imagePath: json["imagePath"] == null ? null : List<String>.from(json["imagePath"].map((x) => x)),
      listImagePath: json["listImagePath"] == null ? null : List<String>.from(json["listImagePath"].map((x) => x)),
    ntn: json["ntn"],
      salesTax: json["salesTax"],
    businessTypes: json["businessTypes"]
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "address": address?.toJson(),
    "imagePath": imagePath,
    "listImagePath" : listImagePath,
    "ntn":ntn,
    "salesTax":salesTax,
    "businessTypes":businessTypes
  };
}

