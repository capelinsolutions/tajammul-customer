import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors.dart';



class CustomTextField extends StatelessWidget{
  const CustomTextField({Key? key,required this.controller, required this.label, this.color, this.passwordVisible,this.keyboardType,this.formFieldValidator, this.onTap, this.onFieldSubmitted, this.enabled, this.isOptional,  this.maxLength, this.suffixIcon, this.onChanged, this.focusNode, this.isReadOnly, this.fontSize,this.textInputAction, this.inputFormatter}) : super(key: key);

  final TextEditingController controller;
  final String label;
  final Color? color;
  final bool? passwordVisible;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final VoidCallback? onTap;
  final ValueChanged? onChanged;
  final ValueChanged? onFieldSubmitted;
  final FormFieldValidator? formFieldValidator;
  final bool? enabled;
  final bool? isReadOnly;
  final bool? isOptional;
  final FocusNode? focusNode;
  final int? maxLength;
  final IconButton? suffixIcon;
  final double? fontSize;
  final List<TextInputFormatter>? inputFormatter;

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
      textInputAction: textInputAction,
      readOnly: isReadOnly ?? false,
      controller: controller,
      obscureText: passwordVisible!=null ? !passwordVisible! : false,
      validator:formFieldValidator,
      maxLength: maxLength,
      focusNode: focusNode,
      enabled: enabled,
      inputFormatters: inputFormatter,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: enabled == true ? GoogleFonts.poppins(color: blueGrey,fontSize: fontSize ?? 15) : GoogleFonts.poppins(color: grey,fontSize: fontSize ?? 15),
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
                  style:GoogleFonts.poppins(color:blueGrey.withOpacity(0.45),fontWeight: FontWeight.normal,fontSize: fontSize ?? 15),
                ),
                isOptional ?? false
                    ? TextSpan(
                    text: ""
                )
                :TextSpan(
                    text: " *",
                    style:GoogleFonts.poppins(
                      color: Colors.red,fontWeight: FontWeight.normal,fontSize: fontSize ?? 15,),
                    )
                  ],
            ),
        ),
        floatingLabelStyle: GoogleFonts.poppins(color: color,fontSize: fontSize ?? 15,),
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
        suffixIcon:suffixIcon

      ),
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      onChanged: onChanged,
      keyboardType: keyboardType ?? TextInputType.text,
    );
  }

}