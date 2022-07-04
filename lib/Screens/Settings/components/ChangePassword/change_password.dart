import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tajammul_customer_app/Screens/Settings/components/ChangePassword/body.dart';

import '../../../../colors.dart';

class ChangePassword extends StatelessWidget {
  static const String routeName = "/changePassword";
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text('Change Password',
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
