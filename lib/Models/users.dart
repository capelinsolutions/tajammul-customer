

import 'dart:convert';

import 'package:tajammul_customer_app/Models/AddressData.dart';

import 'Business.dart';


Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  Users({
    this.userId,
    this.phoneNumber,
    this.status,
    this.imagePath,
    this.addresses,
    this.email,
    this.name,
    this.userName,
    this.businesses
  });

  String? userId;
  String? phoneNumber;
  String? status;
  String? imagePath;
  List<AddressData>? addresses;
  String? email;
  Name? name;
  String? userName;
  List<Business>? businesses;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    userId: json["userId"],
    phoneNumber: json["phoneNumber"],
    status: json["status"],
    imagePath: json["imagePath"],
    addresses: List<AddressData>.from(json["addresses"]?.map((x) => AddressData.fromJson(x)) ?? []),
    email: json["email"],
    name: Name.fromJson(json["name"]),
    userName: json["userName"],
    businesses: List<Business>.from(json["businesses"]?.map((x) => Business.fromJson(x)) ?? [])
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "phoneNumber": phoneNumber,
    "status": status,
    "imagePath": imagePath,
    "addresses": List<AddressData>.from(addresses?.map((x) => x.toJson()) ?? []),
    "email": email,
    "name": name?.toJson(),
    "userName" : userName,
    "businesses": List<Business>.from(businesses?.map((x) => x.toJson()) ?? [])
  };
}

class Name {
  Name({
    this.firstName,
    this.lastName,
  });

  String? firstName;
  String? lastName;

  factory Name.fromJson(Map<String, dynamic> json) => Name(
    firstName: json["firstName"],
    lastName: json["lastName"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
  };
}
