import 'package:flutter/material.dart';
import 'package:tajammul_customer_app/Screens/Service/body.dart';

import '../../Models/Business.dart';
class ServiceDashboardScreen extends StatelessWidget {
  static const String routeName = "/ServiceDashboard";

  const ServiceDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Business;
    return Scaffold(
        body: Body(
          business: args,
        )
    );
  }
}
