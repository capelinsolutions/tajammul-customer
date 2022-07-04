// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({
    this.categoryName,
  });

  String? categoryName;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    categoryName: json["categoryName"],
  );

  Map<String, dynamic> toJson() => {
    "categoryName": categoryName,
  };
}
