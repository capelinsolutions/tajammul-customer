
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../SizeConfig.dart';



class CustomButton extends StatelessWidget{
  const CustomButton({Key? key, required this.label, this.color, required this.onPressed, this.enabled, this.fontSize }) : super(key: key);

  final String label;
  final Color? color;
  final bool? enabled;
  final VoidCallback onPressed;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Padding(
          padding: EdgeInsets.only(
              right: 0.0, left: 0.0, top: 10.0, bottom: 12.0),
          child: Text(
              label,
              style: GoogleFonts.poppins(
                  fontSize: fontSize ?? getProportionateScreenHeight(16.0),fontWeight: FontWeight.w500)
          ),
        ),
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(8.0),
            shadowColor: MaterialStateProperty.all(color?.withOpacity(0.5) ?? Colors.black),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>((enabled ?? true ? color : color?.withOpacity(0.5) ) ?? Colors.black),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.white,width: 0.5))
            )),
        onPressed: enabled ?? true ? onPressed : null
    );
  }

}