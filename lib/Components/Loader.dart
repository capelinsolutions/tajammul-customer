
import 'package:flutter/material.dart';



class Loader extends StatelessWidget{
  const Loader({Key? key, required this.color,  }) : super(key: key);

  final Color color;


  @override
  Widget build(BuildContext context) {
    return Center(
            child:Image.asset("assets/Images/loader.gif",width: 120.0, )
            // CircularProgressIndicator(
            //   backgroundColor: Colors.transparent,
            //   strokeWidth: 2.0,
            //   valueColor: AlwaysStoppedAnimation<Color>(color),
            // )
    );
  }

}