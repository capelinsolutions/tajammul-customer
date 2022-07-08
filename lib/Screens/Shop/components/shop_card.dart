import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tajammul_customer_app/Models/Business.dart';

import '../../../../../SizeConfig.dart';
import '../../../../../colors.dart';
import '../../../Models/Timings.dart';

class ShopCard extends StatefulWidget {
  final Business? business;
  const ShopCard({Key? key, this.business}) : super(key: key);

  @override
  State<ShopCard> createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> {

  DateTime now = DateTime.now();
  List<TimeObj> timeList = [];

  @override
  void initState() {
    super.initState();
  }

  bool isShopClosed(){
    bool isClosed = true;
    String day=DateFormat('EEEE').format(now);
    switch(day){
      case "Monday":
        isClosed=checkDateValidity(widget.business?.timings?.timings?.monday);
        setState(() {
          timeList = widget.business!.timings!.timings!.monday!;
        });
        break;
      case "Tuesday":
        isClosed=checkDateValidity(widget.business?.timings?.timings?.tuesday);
        setState(() {
          timeList = widget.business!.timings!.timings!.tuesday!;
        });
        break;
      case "Wednesday":
        isClosed=checkDateValidity(widget.business?.timings?.timings?.wednesday);
        setState(() {
          timeList = widget.business!.timings!.timings!.wednesday!;
        });
        break;
      case "Thursday":
        isClosed=checkDateValidity(widget.business?.timings?.timings?.thursday);
        setState(() {
          timeList = widget.business!.timings!.timings!.thursday!;
        });
        break;
      case "Friday":
        isClosed=checkDateValidity(widget.business?.timings?.timings?.friday);
        setState(() {
          timeList = widget.business!.timings!.timings!.friday!;
        });
        break;
      case "Saturday":
        isClosed=checkDateValidity(widget.business?.timings?.timings?.saturday);
        setState(() {
          timeList = widget.business!.timings!.timings!.saturday!;
        });
        break;
      case "Sunday":
        isClosed=checkDateValidity(widget.business?.timings?.timings?.sunday);
        setState(() {
          timeList = widget.business!.timings!.timings!.sunday!;
        });
        break;
    }
    return isClosed;
  }

//check validity according to current object
  bool checkDateValidity(List<TimeObj>? list) {
    bool isClosed =true;
    DateTime todayTime = DateFormat.Hm().parse(now.hour.toString() + ":" + now.minute.toString());
    if ((list?.isNotEmpty)!) {
      for (int i = 0; i < (list!.length); i++) {

        String? tempStartTime = list[i].startTime?.substring(
            (list[i].startTime!.indexOf('T') + 1), list[i].startTime!.length-1);
        String? tempEndTime = list[i].endTime?.substring(
            (list[i].endTime!.indexOf('T') + 1), list[i].endTime!.length-1);
        DateTime startDate = DateFormat.Hm().parse(tempStartTime!);
        DateTime endDate = DateFormat.Hm().parse(tempEndTime!);
        if (!todayTime.isBefore(startDate) && !todayTime.isAfter(endDate)) {
          isClosed = false;
          break;
        }
      }
    }
    return isClosed;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      shadowColor: Color(0xFF93A7BE).withOpacity(0.3),
      margin: EdgeInsets.symmetric(
          vertical: getProportionateScreenWidth(10.0)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: EdgeInsets.all(10.0),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
              color: Color(0xFFEFEFEF), width: 0.1),
          gradient: RadialGradient(
            radius: 1.0,
            center: Alignment(-0.6, -0.7),
            colors: const [
              Color(0xFFEFEFEF),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.business?.businessInfo?.name}',style: GoogleFonts.poppins(color: blueGrey,fontWeight: FontWeight.bold),),
            Row(
              children: [
                Text('4.0', style: GoogleFonts.poppins(color: blueGrey,fontSize: 12)),
                SizedBox(width: 5,),
                SvgPicture.asset(
                  "assets/Icons/rating_stars.svg",
                  height: 12,
                ),
                SizedBox(width: 5,),
                Text('(1,080)', style: GoogleFonts.poppins(color: blueGrey,fontSize: 12)),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(5),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/Icons/locations.svg",
                  width: 12,
                ),
                SizedBox(width: getProportionateScreenWidth(5.0),),
                Expanded(
                    child: Text(
                      "${widget.business?.businessInfo?.address?.formatedAddress}",
                      style: GoogleFonts.poppins(color: blueGrey,fontSize: 12),overflow: TextOverflow.ellipsis,maxLines: 2,)),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(5),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: SvgPicture.asset(
                    "assets/Icons/time.svg",
                    width: 12,
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(5.0),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (!isShopClosed() && widget.business!.isOpened!)
                        ? Text("Opened",
                        style: GoogleFonts.poppins(
                            color: green, fontSize: 10))
                        : Text("Closed",
                        style: GoogleFonts.poppins(
                            color: redBackground, fontSize: 10)),
                    SizedBox(
                      height: getProportionateScreenHeight(5),
                    ),
                    for (int i = 0; i < timeList.length; i++)
                      Text(
                        "${DateFormat('h:mm:a').format(DateTime.parse(timeList[i].startTime!))} to ${DateFormat('h:mm:a').format(DateTime.parse(timeList[i].endTime!))}",
                        style:
                        GoogleFonts.poppins(color: blueGrey, fontSize: 9),
                      )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
