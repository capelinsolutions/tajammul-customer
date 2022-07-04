import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tajammul_customer_app/Models/HiveProduct.dart';
import 'package:tajammul_customer_app/Models/Product.dart';
import '../../../Models/Business.dart';
import '../../Checkout/checkout_main.dart';
import '/Screens/Shop/screens/body.dart';
import '../../../../../SizeConfig.dart';
import '../../../../../colors.dart';

class ProductDetails extends StatefulWidget {
  static const String routeName = "/ProductDetails";
  final Product? product;
  final Business? business;
  const ProductDetails({Key? key,this.product,this.business}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Box<HiveProduct>? dataBox;

  @override
  void initState(){
    dataBox = Hive.box<HiveProduct>('cart');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: dataBox!.listenable(),
        builder: (context, Box<HiveProduct> items, _){
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: backgroundColor,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: blueGrey,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  );
                },
              ),
              elevation: 1,
              centerTitle: true,
              title: Text(
                'Product Details',
                style: GoogleFonts.poppins(
                    fontSize: 18, color: blueGrey, fontWeight: FontWeight.w600),
              ),
              actions: [
                items.getAt(0)!.cartData!.isNotEmpty ?  InkWell(
              onTap: (){
                Navigator.pushNamed(context, CheckoutScreen.routeName);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 20.0),
                padding: const EdgeInsets.all(2.0),
                width: getProportionateScreenWidth(40.98),
                height: getProportionateScreenHeight(31.7),
                child: Stack(clipBehavior: Clip.none, children: [
                  SvgPicture.asset(
                    "assets/Images/cartImage.svg",
                    width: 150.0,
                  ),
                  Positioned(
                      left: getProportionateScreenWidth(30.0),
                      top: getProportionateScreenHeight(20.0),
                      child: Container(
                        width: getProportionateScreenWidth(12.0),
                        height: getProportionateScreenWidth(12.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: darkRed),
                        child: Center(
                          child: Text(
                            '${items.getAt(0)!.cartData!.length}',
                            style: GoogleFonts.poppins(
                                fontSize: 8,
                                color: white,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ))
                ]),
              ),
            ) : InkWell(
              onTap: (){
                Navigator.pushNamed(context, CheckoutScreen.routeName);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 20.0),
                padding: const EdgeInsets.all(2.0),
                width: getProportionateScreenWidth(40.98),

                height: getProportionateScreenHeight(31.7),
                child: Stack(clipBehavior: Clip.none, children: [
                  SvgPicture.asset(
                    "assets/Images/cartImage.svg",
                    width: 150.0,
                  ),
                  Positioned(
                      left: getProportionateScreenWidth(30.0),
                      top: getProportionateScreenHeight(20.0),
                      child: Container(
                        width: getProportionateScreenWidth(12.0),
                        height: getProportionateScreenWidth(12.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: darkRed),
                        child: Center(
                          child: Text(
                            '0',
                            style: GoogleFonts.poppins(
                                fontSize: 8,
                                color: white,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ))
                ]),
              ),
            )
              ],
            ),
            body: Body(
                product: widget.product,
                business: widget.business
            ),
          );
        });
  }
}
