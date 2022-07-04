import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors.dart';

class CustomSnackbar extends StatelessWidget {
  Color? color;
  String? message;
  CustomSnackbar({
    Key? key,
    required this.color,
    required this.message
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        height: 90,
        width: 200,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20)
        ),
        child: Center(child: Text('$message',style: GoogleFonts.poppins(color: Colors.white,fontSize: 16),)));
  }
}