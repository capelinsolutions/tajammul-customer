import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../colors.dart';



class PhoneNumberField extends StatelessWidget{
  const PhoneNumberField({Key? key,required this.controller, required this.label, this.color,this.onChanged, this.keyboardType,this.formFieldValidator, this.isValidate, this.initialValue, this.focusNode, }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final Color? color;
  final ValueChanged? onChanged;
  final TextInputType? keyboardType;
  final ValueChanged? isValidate;
  final FormFieldValidator? formFieldValidator;
  final PhoneNumber? initialValue;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {

    OutlineInputBorder border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(0.0),
        borderSide: BorderSide.none
    );
    return InternationalPhoneNumberInput(
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      textFieldController: controller,
      onInputValidated: isValidate,
      ignoreBlank: false ,
      initialValue:initialValue,
      formatInput: false,
      validator: formFieldValidator,
      textStyle: GoogleFonts.poppins(color: color,fontWeight: FontWeight.normal,fontSize: 15,),
      inputDecoration:InputDecoration(
        counterText: "",
        filled: false,
        border: InputBorder.none,
        disabledBorder:border,
        label: RichText(
          textAlign: TextAlign.end,
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: label,
                style:GoogleFonts.poppins(color:blueGrey.withOpacity(0.45),fontWeight: FontWeight.normal,fontSize: 13),
              ),
              TextSpan(
                text: " *",
                style:GoogleFonts.poppins(
                  color: Colors.red,fontWeight: FontWeight.normal,fontSize: 13,),
              )
            ],
          ),
        ),
        focusedBorder: border,
        errorBorder: border,
        focusedErrorBorder: border,
        enabledBorder: border,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: EdgeInsets.only(left: 0.0,right: 0.0),
        errorStyle: GoogleFonts.poppins(
            color: Colors.red,
            fontSize: 11,
            fontWeight: FontWeight.w500
        ),
      ),

      spaceBetweenSelectorAndTextField: 0.0,
      selectorConfig: SelectorConfig(
        leadingPadding: 10.0,
        selectorType: PhoneInputSelectorType.DROPDOWN,
      ),
      inputBorder: InputBorder.none,
      selectorButtonOnErrorPadding: 0.0,
      selectorTextStyle: GoogleFonts.poppins(
        color: color,fontWeight: FontWeight.normal,fontSize: 15,),
      onInputChanged: onChanged,
    );
  }

}
