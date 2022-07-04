// To parse this JSON data, do
//
//     final searchProducts = searchProductsFromJson(jsonString);

import 'dart:convert';


import 'package:tajammul_customer_app/Models/Category.dart';

import 'Product.dart';

List<SearchProducts> searchProductsFromJson(String str) => List<SearchProducts>.from(json.decode(str).map((x) => SearchProducts.fromJson(x)));

String searchProductsToJson(List<SearchProducts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchProducts {
  SearchProducts({
    this.category,
    this.products,
  });

  Category? category;
  List<Product>? products;

  factory SearchProducts.fromJson(Map<String, dynamic> json) => SearchProducts(
    category: Category.fromJson(json["category"] ?? {}),
    products: List<Product>.from(json["products"]?.map((x) => Product.fromJson(x)) ?? []),
  );

  Map<String, dynamic> toJson() => {
    "category": category?.toJson(),
    "products": List<dynamic>.from(products?.map((x) => x.toJson()) ?? []),
  };
}
