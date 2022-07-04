
import 'package:flutter/material.dart';
import 'package:tajammul_customer_app/Screens/AddAddress/Components/SavedAddresses.dart';
import 'package:tajammul_customer_app/Screens/AddAddress/add_address_main.dart';
import 'package:tajammul_customer_app/Screens/Checkout/checkout_main.dart';
import 'package:tajammul_customer_app/Screens/Dashboard/dashboard_main.dart';
import 'package:tajammul_customer_app/Screens/Favourites/favourites_screen.dart';
import 'package:tajammul_customer_app/Screens/History/history_main.dart';
import 'package:tajammul_customer_app/Screens/Info/info_main.dart';
import 'package:tajammul_customer_app/Screens/InternetConnectivity/no_internet.dart';
import 'package:tajammul_customer_app/Screens/Notifications/notifications_main.dart';
import 'package:tajammul_customer_app/Screens/Profile/profile_main.dart';
import 'package:tajammul_customer_app/Screens/Service/dashboard_service_main.dart';
import 'package:tajammul_customer_app/Screens/Settings/components/ChangePassword/change_password.dart';
import 'package:tajammul_customer_app/Screens/Settings/settings_screen.dart';
import 'package:tajammul_customer_app/Screens/SignIn/sign_in_main.dart';
import 'package:tajammul_customer_app/Screens/Signup/signup_main.dart';
import 'Screens/AddAddress/Components/PrivacyPolicy.dart';
import 'Screens/Shop/dashboard_screen_main.dart';
import 'Screens/Shop/screens/product_details.dart';
import 'Services/CustomPageRoute.dart';
import 'Tabs/Screens/ServiceScreen/services_screen.dart';
import 'Tabs/Screens/ShopScreen/shop_screen.dart';
import 'Tabs/tabs_main.dart';

/*
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  InfoScreen.routeName: (context) => InfoScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  TabsScreen.routeName: (context) => TabsScreen(),
  DashboardScreen.routeName: (context) => DashboardScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  HistoryScreen.routeName: (context) => HistoryScreen(),
  NotificationsScreen.routeName: (context) => NotificationsScreen(),
  ShopScreen.routeName: (context) => ShopScreen(),
  ServiceScreen.routeName: (context) => ServiceScreen(),
  ShopDashboardScreen.routeName: (context) => ShopDashboardScreen(),
  ProductDetails.routeName: (context) => ProductDetails(),
  CheckoutScreen.routeName: (context) => CheckoutScreen(),
  AddAddressScreen.routeName: (context) => AddAddressScreen(),
  ServiceDashboardScreen.routeName: (context) => ServiceDashboardScreen(),
  SettingsScreen.routeName: (context) => SettingsScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  ChangePassword.routeName: (context) => ChangePassword(),
  PrivacyPolicy.routeName: (context) => PrivacyPolicy(),
  SavedAddresses.routeName: (context) => SavedAddresses(),
  FavouritesScreen.routeName: (context) => FavouritesScreen()
};*/

class Routes{
  static Route? onGenerateRoute(RouteSettings settings){
    switch (settings.name){
      case InfoScreen.routeName:
        return CustomPageRoute(child:InfoScreen(),
            settings: settings);
      case SignInScreen.routeName:
        return CustomPageRoute(child:SignInScreen(),
            settings: settings);
      case TabsScreen.routeName:
        return CustomPageRoute(child:TabsScreen(),
            settings: settings);
      case DashboardScreen.routeName:
        return CustomPageRoute(child:DashboardScreen(),
            settings: settings);
      case ProfileScreen.routeName:
        return CustomPageRoute(child:ProfileScreen(),
            settings: settings);
      case HistoryScreen.routeName:
        return CustomPageRoute(child:HistoryScreen(),
            settings: settings);
      case NotificationsScreen.routeName:
        return CustomPageRoute(child:NotificationsScreen(),
            settings: settings);
      case ShopScreen.routeName:
        return CustomPageRoute(child:ShopScreen(),
            settings: settings);
      case ServiceScreen.routeName:
        return CustomPageRoute(child:ServiceScreen(),
            settings: settings);
      case ShopDashboardScreen.routeName:
        return CustomPageRoute(child:ShopDashboardScreen(),
            settings: settings);
      case ProductDetails.routeName:
        return CustomPageRoute(child:ProductDetails(),
            settings: settings);
      case CheckoutScreen.routeName:
        return CustomPageRoute(child:CheckoutScreen(),
            settings: settings);
      case AddAddressScreen.routeName:
        return CustomPageRoute(child:AddAddressScreen(),
            settings: settings);
      case ServiceDashboardScreen.routeName:
        return CustomPageRoute(child:ServiceDashboardScreen(),
            settings: settings);
      case SettingsScreen.routeName:
        return CustomPageRoute(child:SettingsScreen(),
            settings: settings);
      case SignUpScreen.routeName:
        return CustomPageRoute(child:SignUpScreen(),
            settings: settings);
      case ChangePassword.routeName:
        return CustomPageRoute(child:ChangePassword(),
            settings: settings);
      case PrivacyPolicy.routeName:
        return CustomPageRoute(child:PrivacyPolicy(),
            settings: settings);
      case SavedAddresses.routeName:
        return CustomPageRoute(child:SavedAddresses(),
            settings: settings);
      case FavouritesScreen.routeName:
        return CustomPageRoute(child:FavouritesScreen(),
            settings: settings);
      case NoInternet.routeName:
        return CustomPageRoute(child:NoInternet(),
            settings: settings);
      default:
        return null;
    }
  }
}

