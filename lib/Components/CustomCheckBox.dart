
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tajammul_customer_app/SizeConfig.dart';

import '../../colors.dart';



class CustomCheckBox extends StatelessWidget{
  const CustomCheckBox({Key? key, required this.value, this.checkColor, this.activeColor, required this.onChanged, required this.label, }) : super(key: key);

  final bool value;
  final Color? checkColor;
  final Color? activeColor;
  final ValueChanged onChanged;
  final String label;



  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
      Checkbox(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3.0))
        ),
      checkColor: checkColor,
      activeColor: activeColor,
      value: value,
      visualDensity: VisualDensity.compact,
      onChanged: onChanged,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        fillColor:MaterialStateProperty.all<Color>(activeColor!),
    ),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize:getProportionateScreenWidth(13.0),
              fontWeight: FontWeight.w500,
              color: blueGrey,
            ),
          ),
        ),
        ]
    );
  }

}