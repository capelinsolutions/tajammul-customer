// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';


List<Service> serviceFromJson(String str) => List<Service>.from(json.decode(str).map((x) => Service.fromJson(x)));

String serviceToJson(List<Service> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Service {
  Service({
    this.serviceName,
    this.description,
    this.status,
    this.price,
    this.availableSlots,
    this.discount,
    this.discountedPrice,
    this.likedCount,
    this.purchasedCount,
    this.imagePaths,
    this.listImagePath,
  });

  String? serviceName;
  String? description;
  String? status;
  int? price;
  int? availableSlots;
  int? discountedPrice;
  int? discount;
  String? likedCount;
  int? purchasedCount;
  List<dynamic>? imagePaths;
  List<String>? listImagePath;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    serviceName: json["serviceName"],
    description: json["description"],
    status: json["status"],
    price: json["price"],
    availableSlots: json['availableSlots'],
    discountedPrice: json["discountedPrice"] ,
    discount: json["discount"],
    likedCount: json["likedCount"],
    purchasedCount: json["purchasedCount"],
    imagePaths: List<dynamic>.from(json["imagePaths"]?.map((x) => x) ?? []),
    listImagePath: List<String>.from(json["listImagePath"]?.map((x) => x) ?? [])
  );

  Map<String, dynamic> toJson() => {
    "serviceName": serviceName,
    "description": description,
    "status": status,
    "price": price,
    "availableSlots" : availableSlots,
    "discountedPrice" : discountedPrice,
    "discount": discount,
    "likedCount": likedCount,
    "purchasedCount": purchasedCount,
    "imagePaths": List<dynamic>.from(imagePaths?.map((x) => x) ?? []),
    "listImagePath": List<String>.from(listImagePath?.map((x) => x) ?? [])
  };
}
