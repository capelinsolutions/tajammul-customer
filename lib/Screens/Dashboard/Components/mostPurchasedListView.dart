import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Models/Product.dart';
import '../../../SizeConfig.dart';
import '../../../colors.dart';

class MostPurchasedListView extends StatelessWidget {
  final Product product;

  const MostPurchasedListView({Key? key, required this.product,}) : super(key: key);



  @override
  build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(3.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: getProportionateScreenWidth(100.0),
            child: Text(
              "${product.productName}",
              textAlign: TextAlign.start,
              style: GoogleFonts.poppins(
                  fontSize:  getProportionateScreenWidth(13.0),
                  color: blueGrey,
                  fontWeight: FontWeight.normal),
            ),
          ),

           SizedBox(
             width: getProportionateScreenWidth(150.0),
             child: Text(
                "${product.price}",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize:   getProportionateScreenWidth(13.0),
                    color: blueGrey,
                    fontWeight: FontWeight.normal),
              ),
           ),
        ],
      ),
    );
  }
}
