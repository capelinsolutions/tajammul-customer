import 'package:flutter/material.dart';
import 'package:tajammul_customer_app/Screens/SignIn/body.dart';

class SignInScreen extends StatelessWidget {

  static const String routeName= "/SignIn";

  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Body()
    );
  }
}
