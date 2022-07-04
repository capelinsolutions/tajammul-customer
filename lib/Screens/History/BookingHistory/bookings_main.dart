import 'package:flutter/material.dart';
import '../../../colors.dart';
import '../BookingHistory/body.dart';

class BookingsHistory extends StatelessWidget {
  const BookingsHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: backgroundColor,
      body: Body(),
    );
  }
}
