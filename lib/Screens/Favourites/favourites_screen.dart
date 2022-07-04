import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../colors.dart';
import '../Favourites/body.dart';

class FavouritesScreen extends StatelessWidget {
  static const String routeName= "/favourites";
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          elevation: 1.0,
          automaticallyImplyLeading: false,
          backgroundColor: backgroundColor,
          centerTitle: true,
          iconTheme: IconThemeData(color: blueGrey),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
          ),
          title: Text(
            'Favourites',
            style: GoogleFonts.poppins(
                fontSize: 18,
                color: blueGrey,
                fontWeight: FontWeight.w600),
          )),
      body: Body(),
    );
  }
}
