// To parse this JSON data, do
//
//     final addressData = addressDataFromJson(jsonString);

import 'dart:convert';

List<AddressData> addressDataFromJson(String str) => List<AddressData>.from(json.decode(str).map((x) => AddressData.fromJson(x)));

String addressDataToJson(List<AddressData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddressData {
  AddressData({
    this.address,
    this.isActive
  });

    Address? address;
    bool? isActive;
  factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
      address: Address.fromJson(json["address"] ?? {}),
    isActive: json["isActive"]
  );

  Map<String, dynamic> toJson() => {
        "address": address?.toJson(),
    "isActive" : isActive
  };
}
class Address {
  Address({
    this.street,
    this.area,
    this.city,
    this.province,
    this.country,
    this.postalCode,
    this.longitude,
    this.latitude,
    this.residence,
    this.additionalAddress,
    this.formatedAddress,
    this.addressName,
    this.addressType
  });

  String? street;
  String? area;
  String? city;
  String? province;
  String? country;
  String? postalCode;
  String? longitude;
  String? latitude;
  String? residence;
  String? additionalAddress;
  String? formatedAddress;
  String? addressName;
  String? addressType;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    street: json["street"] ?? '',
    area: json["area"] ?? '',
    city: json["city"] ?? '',
    province: json["province"] ?? '',
    country: json["country"] ?? '',
    postalCode: json["postalCode"] ?? '',
    longitude: json["longitude"] ?? '',
    latitude: json["latitude"]?? '',
    residence: json["residence"]?? '',
    additionalAddress: json["additionalAddress"] ?? '',
    formatedAddress: json["formatedAddress"],
      addressName: json["addressName"],
    addressType: json["addressType"]
  );

  Map<String, dynamic> toJson() => {
    "street": street,
    "area": area,
    "city": city,
    "province": province,
    "country": country,
    "postalCode": postalCode,
    "longitude":longitude,
    "latitude":latitude,
    "residence":residence,
    "additionalAddress":additionalAddress,
    "formatedAddress":formatedAddress,
    "addressName" : addressName,
    "addressType" : addressType
  };
}
