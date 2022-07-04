import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../colors.dart';
import 'package:tajammul_customer_app/Screens/Settings/body.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = "/settings";
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
     appBar: AppBar(
       backgroundColor: backgroundColor,
         leading: IconButton(
           icon: Icon(
             Icons.arrow_back_ios,
             color: blueGrey,
             size: 30,
           ),
           onPressed: () {
            Navigator.pop(context);
           },
         ),
       elevation: 0.5,
       centerTitle: true,
       title: Text('Settings',
    style: GoogleFonts.poppins(
    fontSize: 18,
    color: blueGrey,
    fontWeight: FontWeight.w600),
     ),
    ),
     body: Body(),
    );
  }
}
