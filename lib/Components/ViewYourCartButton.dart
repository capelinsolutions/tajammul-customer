import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tajammul_customer_app/Models/HiveProduct.dart';
import 'package:tajammul_customer_app/SizeConfig.dart';

import '../Models/CartProduct.dart';
import '../Screens/Checkout/checkout_main.dart';
import '../colors.dart';

class ViewYourCartButton extends StatefulWidget {
  const ViewYourCartButton({Key? key}) : super(key: key);

  @override
  State<ViewYourCartButton> createState() => _ViewYourCartButtonState();
}

class _ViewYourCartButtonState extends State<ViewYourCartButton> {

  Box<HiveProduct>? dataBox;

  @override
  void initState(){
    dataBox = Hive.box<HiveProduct>('cart');
    super.initState();
  }

  int calTotal(List<CartProduct> productList) {
    int discountedPrice = 0;
    int price = 0;
    for (var i in productList) {
      discountedPrice += (i.discountedPrice ?? i.price!) * i.quantity!;
      price += i.price! * i.quantity!;
    }
    return price - (price - discountedPrice);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dataBox!.listenable(),
        builder: (context, Box<HiveProduct> items, _){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: InkWell(
          onTap: (){
            Navigator.pushNamed(context, CheckoutScreen.routeName);
          },
          child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Container(
                decoration: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: orange.withOpacity(0.5),
                          blurRadius: 5,
                          offset: Offset(0, 3))
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        height: getProportionateScreenHeight(30),
                        width: getProportionateScreenWidth(30),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: white,width: 1.5)
                        ),
                        child: Center(child: Text('${items.getAt(0)!.cartData!.length}',style: GoogleFonts.poppins(fontSize: 14,color: white,fontWeight: FontWeight.w600),))),
                    Text('View your cart',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: white)),
                    Text("Rs. ${calTotal(items.getAt(0)!.cartData!).toString()}",style: GoogleFonts.poppins(fontSize: 14,color: white,fontWeight: FontWeight.w600),),
                  ],
                ),
              )),
        ),
      );
    });
  }
}
