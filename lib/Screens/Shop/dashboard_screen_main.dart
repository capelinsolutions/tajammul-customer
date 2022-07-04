import 'package:flutter/material.dart';
import 'package:tajammul_customer_app/Models/Business.dart';
import '../../../../Screens/Shop/body.dart';

class ShopDashboardScreen extends StatelessWidget {
  static const String routeName = "/ShopDashboard";

  const ShopDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Business;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Body(
        business: args,
      )
    );
  }
}
