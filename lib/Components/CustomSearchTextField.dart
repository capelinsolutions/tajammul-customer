import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../SizeConfig.dart';
import '../colors.dart';

class CustomSearchTextField extends StatelessWidget{
  const CustomSearchTextField({Key? key,required this.controller, required this.label, this.color,  this.onPressed, this.onTap, this.onFieldSubmitted, this.onChanged, }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final Color? color;
  final VoidCallback? onPressed;
  final VoidCallback? onTap;
  final ValueChanged? onFieldSubmitted;
  final ValueChanged? onChanged;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
        borderRadius: BorderRadius.only(topLeft:Radius.circular(6.0),bottomLeft: Radius.circular(6.0)),
      borderSide: BorderSide(
        width: 0.0,
        style: BorderStyle.none
      )
    );
    return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TextFormField(
            controller: controller,
            cursorColor: dark_grey,
            style: GoogleFonts.poppins(color: dark_grey,fontSize: 12,fontWeight: FontWeight.normal),
            decoration: InputDecoration(
              fillColor: white,
              filled: true,
              border: InputBorder.none,
              labelText: label,
              focusedBorder: border,
              enabledBorder: border,
              labelStyle:GoogleFonts.poppins(color: dark_grey.withOpacity(0.4),fontSize: 12,fontWeight: FontWeight.normal),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              contentPadding: EdgeInsets.only(left: 10.0),
             ),
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
              keyboardType: TextInputType.text,
        ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight:Radius.circular(6.0),bottomRight: Radius.circular(6.0)),
                color: orange,
              ),
                width: getProportionateScreenWidth(40.0),
                child:Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SvgPicture.asset("assets/Icons/search_icon.svg",color: Colors.white
                      ),
                )
            ),
          )
      ]
    );
  }

}