import 'package:flutter/material.dart';

import '../../colors.dart';
import '../Info/body.dart';

class InfoScreen extends StatelessWidget{
  static const String routeName= "/Info";

  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
     body: Body(),
    );
  }
}
