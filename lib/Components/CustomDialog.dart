
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tajammul_customer_app/Components/CustomButton.dart';

import '../SizeConfig.dart';
import '../colors.dart';



class CustomDialog extends StatelessWidget{

  final String message;
  final String firstLabelButton;
  final String? secondButtonLabel;
  final String imagePath;
  final VoidCallback? onFirstPressed;
  final VoidCallback? onSecondPressed;

  const CustomDialog({Key? key, required this.message, required this.firstLabelButton,  this.secondButtonLabel,  this.onFirstPressed,this.onSecondPressed, required this.imagePath,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
        elevation: 20.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      insetPadding: const EdgeInsets.all(5.0),
      child:  Container(
          width: double.infinity,
          decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
          Radius.circular(12.0),
          ),
          gradient:RadialGradient(
            radius: 10.0,
            center: Alignment(-0.5,1.0),
          colors:[
          Color(0xFFEFEFEF),
          Color(0xFFFFFFFF),
    ],
    )
    ),
    child:Padding(
    padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(20.0)),
    child:Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(imagePath),
          SizedBox(height: getProportionateScreenHeight(10.0),),
          SizedBox(
            width: getProportionateScreenWidth(250.0),
            child: Text(message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: blueGrey,
                    fontWeight: FontWeight.w500),
              ),
          ),
          SizedBox(height: getProportionateScreenHeight(20.0),),

          secondButtonLabel!=null
          ?Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            Expanded(
              child: ListTile(
                title: SizedBox(
                  height: getProportionateScreenHeight(45.0),
                  width: double.infinity,
                  child: CustomButton(
                      label: firstLabelButton,
                      color: orange,
                      onPressed: onFirstPressed!
                  ),
                ),
              ),
            ),
              Expanded(
                child: ListTile(
                  title: SizedBox(
                    height: getProportionateScreenHeight(45.0),
                    width: double.infinity,
                    child: CustomButton(
                        label: secondButtonLabel!,
                        color: green,
                        onPressed: onSecondPressed!
                    ),
                  ),
                ),
              ),
            ]
          )
              :ListTile(
            title: SizedBox(
              height: getProportionateScreenHeight(45.0),
              width: double.infinity,
              child: CustomButton(
                  label: firstLabelButton,
                  color: orange,
                  onPressed: onFirstPressed!
              ),
            ),
          ),


        ],
      ),
          )
    )

    );
  }

}