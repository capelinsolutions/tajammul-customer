import 'package:flutter/material.dart';

import '../../colors.dart';
import '../Dashboard/body.dart';

class DashboardScreen extends StatelessWidget {

  static const String routeName= "/Dashboard";

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,

        body: Body() 
    );
  }
}