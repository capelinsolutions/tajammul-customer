// To parse this JSON data, do
//
//     final businessDetails = businessDetailsFromJson(jsonString);

import 'dart:convert';


import 'package:tajammul_customer_app/Models/Category.dart';
import 'package:tajammul_customer_app/Models/Service.dart';

import 'Product.dart';

class BusinessDetails {
  BusinessDetails({
    this.inventoryList,
    this.servicesList,
  });

  List<Inventory>? inventoryList;

  List<Service>? servicesList;

  factory BusinessDetails.fromJson(Map<String, dynamic> json) => BusinessDetails(
    inventoryList: List<Inventory>.from(json["inventoryList"]?.map((x) => Inventory.fromJson(x)) ?? []),
    servicesList: List<Service>.from(json["servicesList"]?.map((x) => Service.fromJson(x)) ?? []),
  );

  Map<String, dynamic> toJson() => {
    "inventoryList": List<dynamic>.from(inventoryList?.map((x) => x) ?? []),
    "servicesList": List<dynamic>.from(servicesList?.map((x) => x) ?? []),
  };
}


Inventory inventoryFromJson(String str) => Inventory.fromJson(json.decode(str));

String inventoryToJson(Inventory data) => json.encode(data.toJson());
class Inventory{

 Inventory({
   this.category,
   this.products
}) ;

 Category? category;
 List<Product>? products;

 factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
   category: Category.fromJson(json["category"] ?? {}),
   products: List<Product>.from(json["products"]?.map((x) => Product.fromJson(x)) ?? []),
 );

 Map<String, dynamic> toJson() => {
   "category": category?.toJson(),
   "products": List<dynamic>.from(products?.map((x) => x.toJson()) ?? []),
 };
}
