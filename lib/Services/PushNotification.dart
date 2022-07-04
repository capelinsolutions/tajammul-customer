import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'ApiCalls.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;


  PushNotificationService(this._fcm);

  Future<bool> initialise() async {
    try {
      if (Platform.isIOS) {
        await _fcm.requestPermission(sound: true, alert: true, badge: true);
      }
      String? fcmToken = await _fcm.getToken();
      Map<String, String>? result = await ApiCalls.updateFcmToken(fcmToken!, true);
      if (result!["result"] == "") {
        print("token: $fcmToken");
        return true;
      }
      return false;
    }
    catch(e){
      return false;
    }
  }
}