import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tajammul_customer_app/Screens/History/OrderHistory/order_main.dart';
import 'package:tajammul_customer_app/Screens/History/BookingHistory/bookings_main.dart';

import '../../colors.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {

  final List<Widget> _screens = <Widget>[
    OrderHistory(),
    BookingsHistory()
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.0),
              border: Border(bottom: BorderSide(color: grey, width: 0.8)),
            ),
            child: TabBar(
              indicatorColor: orange,
              indicatorWeight: 1.5,
              labelColor: orange,
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 12),
              unselectedLabelColor: grey,
              tabs: const [
                Tab(text: "Orders"),
                Tab(text: "Bookings")
              ],
            ),
          ),
          Expanded(child: TabBarView(children: _screens)),
        ],
      ),
    );
  }
}
