import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tajammul_customer_app/Models/Business.dart';
import 'package:tajammul_customer_app/Models/Service.dart';
import 'package:tajammul_customer_app/Screens/Service/screens/body.dart';
import '../../../../../colors.dart';

class ServiceDetails extends StatelessWidget {
  final Business? business;
  final Service? service;
  const ServiceDetails({Key? key,this.service,this.business}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: blueGrey,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            );
          },
        ),
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Service Details',
          style: GoogleFonts.poppins(
              fontSize: 18, color: blueGrey, fontWeight: FontWeight.w600),
        ),
      ),
      body: Body(
        service: service,
        business: business
      ),
    );
  }
}
