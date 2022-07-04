// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

import 'package:tajammul_customer_app/Models/AddressData.dart';
import 'package:tajammul_customer_app/Models/Business.dart';
import 'package:tajammul_customer_app/Models/users.dart';

List<Order> orderListFromJson(String str) => List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderListToJson(List<Order> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    this.orderId,
    this.orderType,
    this.orderDetails,
    this.customerName,
    this.email,
    this.phoneNumber,
    this.status,
    this.customer,
    this.business,
    this.address
  });

  String? orderId;
  String? orderType;
  OrderDetails? orderDetails;
  String? customerName;
  String? email;
  String? phoneNumber;
  String? status;
  Users? customer;
  Business? business;
  AddressData? address;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    orderId: json["orderId"],
    orderType: json["orderType"],
    orderDetails: OrderDetails.fromJson(json["orderDetails"]),
    customerName: json["customerName"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    status: json["status"],
    customer: Users.fromJson(json["customer"] ?? {} ),
    business: Business.fromJson(json["business"] ?? {} ),
    address: AddressData.fromJson(json["address"] ?? {} ),

  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "orderType": orderType,
    "orderDetails": orderDetails?.toJson(),
    "customerName": customerName,
    "email": email,
    "phoneNumber": phoneNumber,
    "status": status,
    "customer": customer?.toJson(),
    "business": business?.toJson(),
    "address":address?.toJson()
  };
}

class OrderDetails {
  OrderDetails({
    this.productCartItems,
    this.totalAmount,
    this.instructions,
    this.rating,
  });

  List<ProductCartItem>? productCartItems;
  double? totalAmount;
  String? instructions;
  int? rating;

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
    productCartItems: List<ProductCartItem>.from(json["productCartItems"].map((x) => ProductCartItem.fromJson(x)) ?? []),
    totalAmount: json["totalAmount"],
    instructions: json["instructions"],
    rating: json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "productCartItems": List<dynamic>.from(productCartItems?.map((x) => x.toJson()) ?? []),
    "totalAmount": totalAmount,
    "instructions": instructions,
    "rating": rating,
  };
}

class ProductCartItem {
  ProductCartItem({
    this.productName,
    this.quantity,
    this.price,
    this.discount,
    this.discountedPrice,
  });

  String? productName;
  int? quantity;
  int? price;
  int? discount;
  int? discountedPrice;

  factory ProductCartItem.fromJson(Map<String, dynamic> json) => ProductCartItem(
    productName: json["productName"],
    quantity: json["quantity"],
    price: json["price"],
    discount: json["discount"],
    discountedPrice: json["discountedPrice"],
  );

  Map<String, dynamic> toJson() => {
    "productName": productName,
    "quantity": quantity,
    "price": price,
    "discount": discount,
    "discountedPrice": discountedPrice,
  };
}