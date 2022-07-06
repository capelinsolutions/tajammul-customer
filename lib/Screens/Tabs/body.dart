import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tajammul_customer_app/Providers/UpdateIndexProvider.dart';
import 'package:tajammul_customer_app/Screens/Dashboard/dashboard_main.dart';
import 'package:tajammul_customer_app/Screens/History/history_main.dart';
import 'package:tajammul_customer_app/Screens/Notifications/notifications_main.dart';
import 'package:tajammul_customer_app/Screens/Profile/profile_main.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final List<Widget> _selectedWidget = [
    DashboardScreen(),
    ProfileScreen(),
    HistoryScreen(),
    NotificationsScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<UpdateIndexProvider>(
      builder: (context, value, child) {
        return _selectedWidget.elementAt(value.tabIndex);
      }
    );
  }
}
