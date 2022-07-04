
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tajammul_customer_app/Components/CustomButton.dart';

import '../../../SizeConfig.dart';
import '../../../colors.dart';
class PrivacyPolicy extends StatelessWidget{
  static const String routeName= "privacy";
  const PrivacyPolicy({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 1.0,
        centerTitle: true,
        iconTheme: IconThemeData(
            color: blueGrey

        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,size: 20,),
        ),
        title: Text(
          "Privacy Policy",
          style: GoogleFonts.poppins(
              fontSize: 18,
              color: blueGrey,
              fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: SafeArea(
          child:Theme(
            data: Theme.of(context).copyWith(
              scrollbarTheme: ScrollbarThemeData(
                thumbColor: MaterialStateProperty.all(blueGrey),
                crossAxisMargin: -2,
                  mainAxisMargin: 5,
                trackVisibility: MaterialStateProperty.all(true),
                trackColor: MaterialStateProperty.all(grey),
                radius: Radius.circular(10)
              )
            ),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10.0),vertical: getProportionateScreenHeight(10.0)),
                child:Card(
                  elevation: 20.0,
                  shadowColor: Color(0xFF93A7BE).withOpacity(0.3),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child:Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                        color: Color(0xFFFFFFFF),
                      ),
                      child: Padding(
                          padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(20.0),horizontal: getProportionateScreenWidth(20.0)),
                          child: Scrollbar(
                            thumbVisibility:true,
                            thickness: 3,
                            trackVisibility: true,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: getProportionateScreenHeight(550),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Text(
                                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\n\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum.",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.poppins(
                                            color: dark_grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(child: Container()),
                                SizedBox(
                                    width: double.infinity,
                                    child: CustomButton(label: 'Go Back',color: orange, onPressed: ()=>Navigator.pop(context))),
                              ],
                            ),
                          )
                      ),
                    ),

            )
            )
            ),
          ),
      ),
    );
  }


}