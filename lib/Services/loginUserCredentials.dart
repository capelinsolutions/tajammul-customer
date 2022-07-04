import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginUserCredentials{

  String? _userName;
  String? _password;
  String? _token;


  //get logged in user

  Future<void> getCurrentUser() async{
  SharedPreferences _preferences = await SharedPreferences.getInstance();
  String? user = _preferences.getString('userCredentials');

  if(user != null && user !=""){
    _userName =  jsonDecode(user)["username"];
    _password =  jsonDecode(user)["password"];
    _token =  jsonDecode(user)["token"];
    return jsonDecode(user);
    }
  }

  //get username

  String? getUsername(){
    return _userName;
  }

  //get password

  String? getPassword(){
    return _password;
  }

  //get token

  String? getToken(){
    return _token;
  }

}