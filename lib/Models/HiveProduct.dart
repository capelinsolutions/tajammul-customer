

import 'package:hive/hive.dart';

import 'Business.dart';
import 'CartProduct.dart';

part 'HiveProduct.g.dart';

@HiveType(typeId: 0)
class HiveProduct extends HiveObject{

  @HiveField(0)
  List<CartProduct>? cartData=[];

  @HiveField(1)
  List<String>? categoryList=[];

  @HiveField(2)
  Business? business;

  @HiveField(3)
  Map<String,List<String>>? categoryProduct;

  @HiveField(4)
  String? currentCategory;
}