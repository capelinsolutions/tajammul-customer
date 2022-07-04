import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateIndexProvider extends ChangeNotifier{
  int _index=0;

  void setIndex(int index){
    _index = index;
    notifyListeners();
  }


  //getter method
  int get tabIndex => _index;
}