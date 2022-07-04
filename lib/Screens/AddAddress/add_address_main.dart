import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Models/AddressData.dart';
import '../../colors.dart';
import '../AddAddress/body.dart';

class AddAddressScreen extends StatelessWidget {

  static const String routeName= "/AddAddress";
  final Address? address;
  final int? index;
  const AddAddressScreen({Key? key, this.address,this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 1.0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: blueGrey

          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context,address);
            },
            icon: Icon(Icons.arrow_back_ios,size: 20,),
          ),
          title: Text(
            "Add an Address",
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: blueGrey,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
        body: Body(address:address,index: index)
    );
  }
}
