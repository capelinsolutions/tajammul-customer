


import 'package:tajammul_customer_app/Environments/LiveConfiguration.dart';

import 'BaseConfig.dart';
import 'LanConfiguration.dart';
import 'WifiDevConfiguration.dart';

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const  String devLan = 'devLan';
  static const String devWifi = 'devWifi';
  static const String live = 'live';


  //static const String STAGING = 'STAGING';
  //static const String PROD = 'PROD';

  BaseConfig? config;

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.devLan:
        return DevLanConfiguration();
      case Environment.devWifi:
        return DevWifiConfiguration();
      case Environment.live:
        return LiveConfiguration();
      default:
        return DevWifiConfiguration();
    }
  }
}