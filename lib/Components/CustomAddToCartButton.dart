
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors.dart';

class CustomAddToCartButton extends StatelessWidget{
  const CustomAddToCartButton({Key? key, required this.label, this.color, this.subtract, this.addQuantity}) : super(key: key);

  final String label;
  final Color? color;
  final VoidCallback? subtract;
  final VoidCallback? addQuantity;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          color: color,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
            BoxShadow(
              color: color?.withOpacity(0.5) ?? Colors.black,
              blurRadius: 5,
              offset: Offset(0,3)
            )
          ]
        ),
          child: Padding(
            padding: EdgeInsets.only(
                right: 10, left: 10, top: 10.0, bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: (){
                      subtract!();
                    },
                    child: SvgPicture.asset('assets/Icons/delete_Icon.svg',color: white,width: 15,)),
                Text(
                    label,
                    style: GoogleFonts.poppins(
                        fontSize: 15,fontWeight: FontWeight.w500,color: white)
                ),
                InkWell(
                    onTap: (){
                      addQuantity!();
                    },
                    child: SvgPicture.asset('assets/Icons/addIcon.svg',color: white,width: 15,)),
              ],
            ),
          ),
      ),
    );
  }
}