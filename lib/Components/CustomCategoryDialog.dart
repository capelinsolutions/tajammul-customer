import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tajammul_customer_app/Components/CustomButton.dart';

import '../SizeConfig.dart';
import '../colors.dart';
import 'CustomTextField.dart';

class CustomCategoryDialog extends StatelessWidget {
  final String labelButton;
  final String labelTextField;
  final VoidCallback onPressed;
  final List<String>? getCategoriesSearchList;
  TextEditingController addNewCategoryController;
  ScrollController? searchAddCategoryScrollController;
  final Function? onTap;
  final VoidCallback? onTextFieldTap;
  final ValueChanged? onChanged;
  bool? visibleAddCategory;
  FocusNode? addCategoryFocusNode;

  CustomCategoryDialog(
      {Key? key,
      required this.labelTextField,
      required this.labelButton,
      required this.onPressed,
      required this.addNewCategoryController,
      this.getCategoriesSearchList,
      this.onTap,
      this.searchAddCategoryScrollController,
      this.visibleAddCategory, this.onChanged, this.onTextFieldTap, this.addCategoryFocusNode, })
      : super(key: key);

  double padding = getProportionateScreenHeight(50.0);
  double avatarRadius = getProportionateScreenWidth(50.0);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      elevation: 20.0,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      insetPadding: EdgeInsets.all(10.0),
      child: Stack(children: <Widget>[
        Column(
          children:[
            Container(
            padding: EdgeInsets.only(top: padding, bottom: padding),
            margin: EdgeInsets.only(top: avatarRadius),
            width: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
                gradient: RadialGradient(
                  radius: 10.0,
                  center: Alignment(-0.5, 1.0),
                  colors: [
                    Color(0xFFEFEFEF),
                    Color(0xFFFFFFFF),
                  ],
                )),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(10.0),
                ),
                ListTile(
                  title: CustomTextField(
                    label: labelTextField,
                    controller: addNewCategoryController,
                    color: lightGrey,
                    focusNode: addCategoryFocusNode,
                    keyboardType: TextInputType.text,
                    onTap: onTextFieldTap,
                    onChanged: onChanged,
                    formFieldValidator: (value) {
                      String? result;
                      if (value.isEmpty) {
                        result = "Required Field";
                      }
                      return result;
                    },
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10.0),
                ),
                ListTile(
                  title: SizedBox(
                    height: getProportionateScreenHeight(45.0),
                    width: double.infinity,
                    child: CustomButton(
                        label: labelButton, color: orange, onPressed: onPressed),
                  ),
                ),
              ],
            ),
          ),
            Visibility(
                visible: visibleAddCategory ?? false,
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(15.0),
                        vertical: getProportionateScreenWidth(0.0)),
                    child: Card(
                      margin: const EdgeInsets.all(0.0),
                      elevation: 5.0,
                      shadowColor: const Color(0xFF93A7BE).withOpacity(0.3),
                      color: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0)),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0)),
                        ),
                        child: getCategoriesSearchList?.isNotEmpty ?? false
                            ? SizedBox(
                          height: getProportionateScreenHeight(120.0),
                          child: Scrollbar(
                            thumbVisibility: true,
                            radius: const Radius.circular(20.0),
                            controller: searchAddCategoryScrollController,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                controller: searchAddCategoryScrollController,
                                padding: const EdgeInsets.all(10.0),
                                itemCount: getCategoriesSearchList?.length,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: onTap!(index),
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        getCategoriesSearchList![index],
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: lightGrey,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        )
                            : SizedBox(
                          height: getProportionateScreenHeight(120.0),
                          child: Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/Icons/search_icon.svg",
                                    color: blueGrey,
                                    width: 20.0,
                                  ),
                                  Text(
                                    "Zero Searches",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: blueGrey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "You haven't search any thing yet",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: blueGrey.withOpacity(0.5),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ))),
    ]
        ),
        Positioned(
          top: padding - getProportionateScreenHeight(50.0),
          left: getProportionateScreenWidth(130.0),
          child: Card(
            margin: const EdgeInsets.all(0.0),
            elevation: 5.0,
            shadowColor: const Color(0xFF93A7BE).withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(avatarRadius),
            ),
            child: Container(
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(avatarRadius),
                    gradient: const RadialGradient(
                      radius: 10.0,
                      center: Alignment(-0.5, 1.0),
                      colors: [
                        Color(0xFFEFEFEF),
                        Color(0xFFFFFFFF),
                      ],
                    )),
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SvgPicture.asset(
                      "assets/Images/onlyLogo.svg",
                      width: 60.0,
                    ))),
          ),
        ),

      ]),
    );
  }
}
