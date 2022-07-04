import 'package:flutter/material.dart';

import '../../colors.dart';
import '../Notifications/body.dart';

class NotificationsScreen extends StatelessWidget {

  static const String routeName= "/Notifications";

  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Body()
    );
  }
}