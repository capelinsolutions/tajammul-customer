import 'package:flutter/material.dart';

import '../ShopScreen/body.dart';


class ShopScreen extends StatelessWidget {
  static const String routeName = "/ShopScreen";
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Body(),
    );
  }
}
