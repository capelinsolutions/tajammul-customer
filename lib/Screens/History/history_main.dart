import 'package:flutter/material.dart';

import '../../colors.dart';
import '../History/body.dart';

class HistoryScreen extends StatelessWidget {

  static const String routeName= "/History";

  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Body()
    );
  }
}