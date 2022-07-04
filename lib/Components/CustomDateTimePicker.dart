// import 'package:date_time_picker/date_time_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../colors.dart';
//
//
//
// class CustomDateTimePickerField extends StatelessWidget{
//   const CustomDateTimePickerField({Key? key, this.label, this.color,required this.onChanged}) : super(key: key);
//
//   //final TextEditingController? controller;
//   final String? label;
//   final Color? color;
//   final Function onChanged;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return DateTimePicker(
//       //controller: controller,
//       type: DateTimePickerType.date,
//       dateMask: 'd-MMMM-yyyy',
//       firstDate: DateTime(1900),
//       lastDate: DateTime(5000),
//       initialDate: DateTime.now(),
//       decoration: InputDecoration(
//         labelText: label,
//         floatingLabelStyle: TextStyle(color: CustomColors.orange,fontSize: 17),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(
//             color: color!,
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(
//             color: color!,
//             width: 1.0,
//           ),
//         ),
//       ),
//       onChanged: (newValue){
//         onChanged(newValue);
//       },
//
//     );
//   }
//
// }