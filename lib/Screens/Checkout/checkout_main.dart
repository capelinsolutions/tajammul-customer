import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tajammul_customer_app/Providers/userProvider.dart';
import '../../Models/AddressData.dart';
import '../Checkout/body.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../colors.dart';

class CheckoutScreen extends StatelessWidget {

  static const String routeName = "/Checkout";
  final Address? address;

  const CheckoutScreen({Key? key,this.address}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
      backgroundColor: backgroundColor,
      elevation: 1.0,
      centerTitle: true,
      iconTheme: IconThemeData(
          color: blueGrey

      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
          Provider.of<UserProvider>(context,listen: false).isOnCheckout(false);
        },
        icon: Icon(Icons.arrow_back_ios,size: 20,),
      ),
      title: Text(
        "Shopping Bag",
        style: GoogleFonts.poppins(
            fontSize: 18,
            color: blueGrey,
            fontWeight: FontWeight.w600
        ),
      ),
    ),
      body: Body(address: address,)
    );
  }
}
