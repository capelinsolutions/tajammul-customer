import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';


class SideMenuListView extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback? onPressed;
  final Color primaryColor;
  final Color secondaryColor;
  final double fontSize;
  final double width;
  final double height;
  final double padding;
  const SideMenuListView({Key? key, required this.label,required this.imagePath, this.onPressed, required this.primaryColor,required this.secondaryColor, required this.fontSize, required this.width, required this.height, required this.padding}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: padding*2,vertical: padding-2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.all(padding),
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: secondaryColor,
                  border: Border.all(color: primaryColor),
                ),
                child:SvgPicture.asset(imagePath,color: primaryColor,)
            ),
            SizedBox(width: padding),
            Text(
              label,
              textAlign: TextAlign.start,
              style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  color: primaryColor,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}