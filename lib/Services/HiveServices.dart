import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:tajammul_customer_app/Models/Business.dart';
import 'package:tajammul_customer_app/Models/HiveProduct.dart';
import 'package:tajammul_customer_app/colors.dart';

import '../Models/CartProduct.dart';
import '../Models/Product.dart';

class HiveServices{

  static setBusiness(Business? business,Box<HiveProduct>? items){
    HiveProduct? hp= items?.getAt(0);
    hp?.business =business;
    items?.putAt(0, hp!);
  }


 static setCategory(String category,Box<HiveProduct>? items){
   HiveProduct? hp= items?.getAt(0);
   hp?.currentCategory=category;
   items?.putAt(0, hp!);
 }

 //add items in the list
 static addProduct(CartProduct product,String categoryName,Box<HiveProduct>? items) {
   HiveProduct? hp= items?.getAt(0);
   hp?.cartData?.add(product);
   addProductsAgainstCategory(product, categoryName,items);
   items?.putAt(0, hp!);
 }

 //add products against category list
 static addProductsAgainstCategory(CartProduct product,String categoryName,Box<HiveProduct>? items){
   HiveProduct? hp= items?.getAt(0);
   List<String>? productsNameList= hp?.categoryProduct?[categoryName] ?? [];
   if(productsNameList.isNotEmpty) {
     if (!productsNameList.contains(product.productName)) {
       productsNameList.add(product.productName!);
     }
   }
   else {
     productsNameList.add(product.productName!);
   }
   hp?.categoryProduct?[categoryName]=productsNameList;
   items?.putAt(0, hp!);
 }

  //initialize cart products
  static initializeCartList(List<CartProduct> list,Box<HiveProduct>? items){
    HiveProduct? hp= items?.getAt(0);
    hp?.cartData = list;
    items?.putAt(0, hp!);
  }

 //remove items from the list
 static removeProduct(CartProduct product,String categoryName,Box<HiveProduct>? items){
   HiveProduct? hp= items?.getAt(0);
   if((hp?.cartData?.contains(product))!) {
     hp?.cartData?.remove(product);
     removeProductsAgainstCategory(product, categoryName,items);
     items?.putAt(0, hp!);
   }
   else {
     Fluttertoast.showToast(
         msg: "Product doesn't exists",
         toastLength: Toast.LENGTH_LONG,
         gravity: ToastGravity.BOTTOM,
         timeInSecForIosWeb: 1,
         backgroundColor: orange,
         textColor: Colors.white,
         fontSize: 15.0);
   }
 }

 //subtractQuantity
 static subtractQuantity(int index,String category,Box<HiveProduct>? items){
   HiveProduct? hp= items?.getAt(0);
   if((hp?.cartData?[index].quantity)! <= 1){
     removeProduct((hp?.cartData?[index])!,category,items);
   }
   else {
     hp?.cartData?[index].quantity = (hp.cartData?[index].quantity)! - 1;
   }
   items?.putAt(0, hp!);
 }

 //addQuantity
 static addQuantity(int index,Box<HiveProduct>? items){
   HiveProduct? hp= items?.getAt(0);
   hp?.cartData?[index].quantity = (hp.cartData?[index].quantity)! + 1;
   items?.putAt(0, hp!);
 }



 //get Quantity
 static int? getQuantity(Product product,Box<HiveProduct>? items){
   int? quantity =0;
   HiveProduct? hp= items?.getAt(0);
   for(var i in hp!.cartData!){
     if(i.productName == product.productName){
       quantity = i.quantity;
       break;
     }
   }
   return quantity;
 }

 //add category
 static addCategory(String category,Box<HiveProduct>? items){
   HiveProduct? hp= items?.getAt(0);
   if(!(hp?.categoryList?.contains(category))!){
     hp?.categoryList?.add(category);
     items?.putAt(0, hp!);
   }
 }

 //remove category
 static removeCategory(String category,Box<HiveProduct>? items){
   HiveProduct? hp= items?.getAt(0);
   if((hp?.categoryList?.contains(category))!) {
     hp?.categoryList?.remove(category);
     items?.putAt(0, hp!);
   }
   else {
     Fluttertoast.showToast(
         msg: "Category doesn't exists",
         toastLength: Toast.LENGTH_LONG,
         gravity: ToastGravity.BOTTOM,
         timeInSecForIosWeb: 1,
         backgroundColor: orange,
         textColor: Colors.white,
         fontSize: 15.0);
   }

 }

//remove products against category list
  static removeProductsAgainstCategory(CartProduct product,String categoryName,Box<HiveProduct>? items) async{
    HiveProduct? hp= items?.getAt(0);
    List<String>? productsNameList = hp?.categoryProduct?[categoryName];
    if ((productsNameList?.contains(product.productName))!) {
      productsNameList?.remove(product.productName!);
      hp?.categoryProduct?[categoryName] = productsNameList!;
      items?.putAt(0, hp!);
    }
    else {
      hp?.categoryProduct?[categoryName] = productsNameList!;
      items?.putAt(0, hp!);
    }
    if ((productsNameList?.isEmpty)!) {
      removeCategory(categoryName,items);
      hp?.categoryProduct?.removeWhere((key, value) => key == categoryName);
    }
    items?.putAt(0, hp!);
  }

  //remove all products
  static removeAll(){
    Box<HiveProduct>? dataBox = Hive.box<HiveProduct>('cart');
    HiveProduct? hp= dataBox.getAt(0);
    hp!.cartData?.clear();
    hp.categoryList?.clear();
    hp.categoryProduct?.clear();
    hp.currentCategory = "";
    hp.business = Business();
    dataBox.putAt(0, hp);
  }
}