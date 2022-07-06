import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tajammul_customer_app/Screens/Info/info_main.dart';
import 'package:tajammul_customer_app/Screens/SignIn/sign_in_main.dart';
import 'package:tajammul_customer_app/Screens/Tabs/tabs_main.dart';
import '../../Services/loginUserCredentials.dart';
import '../../colors.dart';
import '../../main.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final LoginUserCredentials _credentials = LoginUserCredentials();
  AnimationController? _controller;
  Animation<double>? _animation;
  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _animation = Tween(begin: 0.0, end: 280.0).animate(_controller!)
      ..addListener(() {
        setState(() {});
      });
    _controller?.forward();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    Future.delayed(Duration(seconds: 4), () {
      initialAppFlow();
    });
    super.initState();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log("Couldn't check connectivity status" + e.toString());
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    connectionStatus = result;

    if (result.index == 4) {
      Fluttertoast.showToast(
          msg: "You are not connected to any network, Please connect to network",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: orange,
          textColor: Colors.white,
          fontSize: 15.0);
    }
  }

  //check app is Open first time or not
  void initialAppFlow() async {
    await _credentials.getCurrentUser();
    if (_credentials.getToken() != "" && _credentials.getToken() != null) {
      Navigator.pushReplacementNamed(
        context,
        TabsScreen.routeName,
      );
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      if (preferences.getString("Info") != "Already Run") {
        Navigator.pushReplacementNamed(context, InfoScreen.routeName);
      } else {
        Navigator.pushReplacementNamed(
          context,
          SignInScreen.routeName,
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SvgPicture.asset(
          "assets/Images/SplashBackground.svg",
          fit: BoxFit.fill,
          width: double.infinity,
        ),
        Center(
          child: SvgPicture.asset(
            'assets/Images/SplashLogo.svg',
            width: _animation?.value,
          ),
        ),
      ],
    );
  }
}
