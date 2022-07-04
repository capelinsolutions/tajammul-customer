import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
    this.productName,
    this.description,
    this.quantity,
    this.status,
    this.price,
    this.discount,
    this.discountedPrice,
    this.likedCount,
    this.purchasedCount,
    this.imagePaths,
    this.listImagePath
  });

  String? productName;
  String? description;
  int? quantity;
  String? status;
  int? price;
  int? discountedPrice;
  int? discount;
  int? likedCount;
  int? purchasedCount;
  List<dynamic>? imagePaths;
  List<dynamic>? listImagePath;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productName: json["productName"],
    description: json["description"],
    quantity: json["quantity"],
    status: json["status"],
    price: json["price"],
    discountedPrice: json["discountedPrice"],
    discount: json["discount"],
    likedCount: json["likedCount"],
    purchasedCount: json["purchasedCount"],
    imagePaths: List<dynamic>.from(json["imagePaths"]?.map((x) => x) ?? []),
    listImagePath: json["listImagePath"] == null ? null : List<String>.from(json["listImagePath"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "productName": productName,
    "description": description,
    "quantity": quantity,
    "status": status,
    "price": price,
    "discountedPrice": discountedPrice,
    "discount": discount,
    "likedCount": likedCount,
    "purchasedCount": purchasedCount,
    "imagePaths": List<dynamic>.from(imagePaths?.map((x) => x) ?? []),
    "listImagePath": listImagePath == null ? null : List<dynamic>.from(listImagePath!.map((x) => x)),
  };
  factory Product.clone(Product product) {
    return Product(
        productName:product.productName,
        description:product.description,
        quantity:product.quantity,
        status:product.status,
        price:product.price,
        discount:product.discount,
        discountedPrice:product.discountedPrice,
        likedCount:product.likedCount,
        purchasedCount:product.purchasedCount,
        imagePaths:product.imagePaths,
    listImagePath: product.listImagePath);
  }
}