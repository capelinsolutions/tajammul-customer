import 'dart:convert';

import 'Business.dart';
import 'Product.dart';

List<FavouriteProducts> favouriteProductFromJson(String str) => List<FavouriteProducts>.from(json.decode(str).map((x) => FavouriteProducts.fromJson(x)));

String favouriteProductToJson(List<FavouriteProducts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FavouriteProducts {
  FavouriteProducts({
    this.product,
    this.business,
  });

  Product? product;
  Business? business;

  factory FavouriteProducts.fromJson(Map<String, dynamic> json) => FavouriteProducts(
    product: Product.fromJson(json["product"]),
    business: Business.fromJson(json["business"]),
  );

  Map<String, dynamic> toJson() => {
    "product": product?.toJson(),
    "business": business?.toJson(),
  };
}