import 'package:flutter/cupertino.dart';
import 'package:tajammul_customer_app/Models/Business.dart';

import '../Models/AddressData.dart';
import '../Models/users.dart';

class UserProvider extends ChangeNotifier{
  Users users = Users();
  List<Business> searchBusiness = [];
  bool isCheckout =false;

  setUser(Users? user){
    users = user!;
    notifyListeners();
  }

  setBusiness(List<Business> business){
    users.businesses = business;
    notifyListeners();
  }

  setUserSettings(Users? user){
    users.name!.firstName= user!.name!.firstName;
    users.name!.lastName = user.name!.lastName;
    users.imagePath = user.imagePath;
    setAddress(user.addresses!);

  }

  setAddress(List<AddressData> address){
    users.addresses = address;
    notifyListeners();
  }

  setSearchBusiness(List<Business> business){
    searchBusiness = business;
    notifyListeners();
  }

  //notify to widget when we get customer details
  void isOnCheckout(bool value){
    isCheckout = value;
    notifyListeners();
  }

}