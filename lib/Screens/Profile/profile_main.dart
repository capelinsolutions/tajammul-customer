import 'package:flutter/material.dart';

import '../../colors.dart';
import '../Settings/body.dart';

class ProfileScreen extends StatelessWidget {

  static const String routeName= "/Profile";

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Body()
    );
  }
}