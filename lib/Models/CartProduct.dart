// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'CartProduct.g.dart';


List<CartProduct> cartProductFromJson(String str) => List<CartProduct>.from(json.decode(str).map((x) => CartProduct.fromJson(x)));

String cartProductToJson(List<CartProduct> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 2)
class CartProduct extends HiveObject{
  CartProduct({
    this.productName,
    this.quantity,
    this.price,
    this.discount,
    this.discountedPrice,
    this.imagePaths,
    this.errorType,
    this.updatedStock,
    this.previousQuantity,
    this.listImagePath
  });

  @HiveField(0)
  String? productName;
  @HiveField(1)
  int? quantity;
  @HiveField(2)
  int? price;
  @HiveField(3)
  int? discountedPrice;
  @HiveField(4)
  int? discount;
  @HiveField(5)
  String? errorType;
  @HiveField(6)
  int? updatedStock;
  @HiveField(7)
  int? previousQuantity;
  @HiveField(8)
  List<dynamic>? imagePaths;
  @HiveField(9)
  List<dynamic>? listImagePath;

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
    productName: json["productName"],
    quantity: json["quantity"],
    price: json["price"],
    discountedPrice: json["discountedPrice"],
    discount: json["discount"],
    errorType: json["errorType"],
    updatedStock: json["updatedStock"],
    imagePaths: List<dynamic>.from(json["imagePaths"]?.map((x) => x) ?? []),
    listImagePath: List<dynamic>.from(json["listImagePath"]?.map((x) => x) ?? []),
  );

  Map<String, dynamic> toJson() => {
    "productName": productName,
    "quantity": quantity,
    "price": price,
    "discountedPrice": discountedPrice,
    "discount": discount,
    "errorType":errorType,
    "updatedStock":updatedStock,
    "previousQuantity" : previousQuantity,
    "imagePaths": List<dynamic>.from(imagePaths?.map((x) => x) ?? []),
    "listImagePath": List<dynamic>.from(listImagePath?.map((x) => x) ?? []),
  };
  factory CartProduct.clone(CartProduct product) {
    return CartProduct(
        productName:product.productName,
        quantity:product.quantity,
        price:product.price,
        discount:product.discount,
        discountedPrice:product.discountedPrice,
        errorType: product.errorType,
        updatedStock: product.updatedStock,
        previousQuantity: product.previousQuantity,
        imagePaths:product.imagePaths,
    listImagePath: product.listImagePath);
  }
}