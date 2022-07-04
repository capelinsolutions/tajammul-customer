import 'package:flutter/material.dart';
import 'package:tajammul_customer_app/Screens/Signup/body.dart';

class SignUpScreen extends StatelessWidget {

  static const String routeName= "/Signup";

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body()
    );
  }
}
