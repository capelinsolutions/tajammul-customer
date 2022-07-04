import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class OTPExpiredProvider extends ChangeNotifier{
  bool isExpired =true;

  void setExpiry(bool value){
    isExpired =value;
    notifyListeners();
  }


}