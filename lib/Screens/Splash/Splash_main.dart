import 'package:flutter/material.dart';
import 'package:tajammul_customer_app/Screens/Splash/body.dart';
import '../../SizeConfig.dart';
import '../../colors.dart';

class SplashScreen extends StatelessWidget{
  static const String routeName="/Splash";

  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //set mediaQuery
    SizeConfig().init(context);
    return  Scaffold(
        backgroundColor: backGroundBlue,
        body: Body(),
    );
  }
}