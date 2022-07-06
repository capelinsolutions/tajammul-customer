import 'package:flutter/material.dart';

import '../ServiceScreen/body.dart';


class ServiceScreen extends StatelessWidget {
  static const String routeName = "/ServiceScreen";
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body should be called
      body: Body(),
    );
  }
}
