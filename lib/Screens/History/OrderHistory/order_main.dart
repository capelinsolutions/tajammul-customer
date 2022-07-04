import 'package:flutter/material.dart';
import 'package:tajammul_customer_app/colors.dart';
import '../OrderHistory/body.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Body(),
    );
  }
}
