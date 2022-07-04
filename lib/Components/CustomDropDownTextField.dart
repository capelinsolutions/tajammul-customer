import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors.dart';



class CustomDropDownTextField extends StatelessWidget{
  const CustomDropDownTextField({Key? key,required this.controller, required this.label, this.color, this.isPasswordField, this.passwordVisible, this.onPressed, this.keyboardType,this.formFieldValidator, this.onTap, this.onFieldSubmitted, this.enabled, this.isOptional,  this.maxLength,}) : super(key: key);

  final TextEditingController controller;
  final String label;
  final Color? color;
  final bool? isPasswordField;
  final bool? passwordVisible;
  final VoidCallback? onPressed;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final ValueChanged? onFieldSubmitted;
  final FormFieldValidator? formFieldValidator;
  final bool? enabled;
  final bool? isOptional;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: orange,
        width: 1.0,
      ),
    );
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: color ?? Colors.transparent,
        width: 1.0,
      ),
    );
    return TextFormField(
      readOnly: enabled ?? false,
      controller: controller,
      obscureText: passwordVisible!=null ? !passwordVisible! : false,
      validator:formFieldValidator,
      maxLength: maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.poppins(color: blueGrey,fontSize: 15),
      decoration: InputDecoration(
          fillColor: Color(0xFFFFFFFF),
          counterText: "",
          filled: true,
          border: InputBorder.none,
          disabledBorder:border,
          label: RichText(
            textAlign: TextAlign.end,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: label,
                  style:GoogleFonts.poppins(color:blueGrey.withOpacity(0.45),fontWeight: FontWeight.normal,fontSize: 15),
                ),
                isOptional ?? false
                    ? TextSpan(
                    text: ""
                )
                    :TextSpan(
                  text: " *",
                  style:GoogleFonts.poppins(
                    color: Colors.red,fontWeight: FontWeight.normal,fontSize: 15,),
                )
              ],
            ),
          ),
          floatingLabelStyle: GoogleFonts.poppins(color: color,fontSize: 15,),
          focusedBorder: border,
          errorBorder: errorBorder,
          focusedErrorBorder: errorBorder,
          enabledBorder: border,
          contentPadding: EdgeInsets.only(left: 10.0),
          errorStyle: GoogleFonts.poppins(
              color: Colors.red,
              fontSize: 11,
              fontWeight: FontWeight.w500
          ),
          suffixIcon: isPasswordField ?? false
              ? IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                passwordVisible ?? false
                    ? Icons.visibility
                    : Icons.visibility_off,
                color:  Color(0xFFE8E8E8).withOpacity(0.9),
              ),
              onPressed: onPressed
          )
              :null

      ),
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      keyboardType: keyboardType ?? TextInputType.text,
    );
  }

}