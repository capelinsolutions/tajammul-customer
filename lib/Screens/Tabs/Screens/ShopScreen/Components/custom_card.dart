import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tajammul_customer_app/Models/Business.dart';
import 'package:tajammul_customer_app/Models/Timings.dart';
import 'package:tajammul_customer_app/SizeConfig.dart';
import 'package:tajammul_customer_app/colors.dart';
import 'package:tajammul_customer_app/main.dart';

class CustomCard extends StatefulWidget {
  final Business? business;
  final VoidCallback? onTap;

  const CustomCard({Key? key, this.onTap, this.business}) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  DateTime now = DateTime.now();
  bool isOpened = false;
  List<TimeObj> timeList = [];
  int? ratesOff;

  @override
  void initState() {
    for (int i = 0; i < timeList.length; i++) {
      print(timeList[i].startTime);
    }
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
    double width = MediaQuery.of(context).size.width;
    return AbsorbPointer(
      absorbing: !(!isShopClosed() && widget.business!.isOpened!),
      child: Opacity(
        opacity: !(!isShopClosed() && widget.business!.isOpened!) ? 0.5 : 1.0,
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 4,
                    offset: Offset(0, 3),),
              ],
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: getProportionateScreenHeight(20),
                    width: getProportionateScreenWidth(85),
                    decoration: BoxDecoration(
                      color: blueGrey,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(3),),
                    ),
                    child: Center(
                      child: Text(
                        'ratesOff',
                        style: GoogleFonts.poppins(fontSize: 10, color: white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: (width >= 650 && width < 1100) ? getProportionateScreenWidth(100): getProportionateScreenWidth(140),
                      height: getProportionateScreenHeight(130),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child:(widget.business?.businessInfo?.listImagePath !=null && (widget.business?.businessInfo?.listImagePath?.isNotEmpty)!)
                            ? CachedNetworkImage(
                          imageUrl: "${env.config?.imageUrl}${(widget.business!.businessInfo!.listImagePath![0])}",
                          fit: BoxFit.fill,
                        )
                            :Image.asset(
                          "assets/Images/background_pic_image",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Text(
                      '${widget.business!.businessInfo!.name}',
                      style: GoogleFonts.poppins(
                          color: blueGrey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 7, right: 5),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/Icons/locations.svg",
                            width: 10,
                          ),
                          SizedBox(
                            width: getProportionateScreenWidth(5.0),
                          ),
                          Expanded(
                              child: Text(
                            '${widget.business?.businessInfo?.address?.street} ${widget.business?.businessInfo?.address?.area} ${widget.business?.businessInfo?.address?.city} ${widget.business?.businessInfo?.address?.province} ${widget.business?.businessInfo?.address?.country} ${widget.business?.businessInfo?.address?.postalCode}',
                            style:
                                GoogleFonts.poppins(color: blueGrey, fontSize: 10),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),),
                        ],
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(5),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: SvgPicture.asset(
                          "assets/Icons/time.svg",
                          width: 10,
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(5.0),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (!isShopClosed() && widget.business!.isOpened!)
                              ? Text("Opened",
                                  style: GoogleFonts.poppins(
                                      color: green, fontSize: 10),)
                              : Text("Closed",
                                  style: GoogleFonts.poppins(
                                      color: redBackground, fontSize: 10),),
                          for (int i = 0; i < timeList.length; i++)
                            Text(
                              "${DateFormat('h:mm:a').format(DateTime.parse(timeList[i].startTime!))} to ${DateFormat('h:mm:a').format(DateTime.parse(timeList[i].endTime!))}",
                              style:
                                  GoogleFonts.poppins(color: blueGrey, fontSize: 9),
                            )
                        ],
                      ),
                      Expanded(child: Container(),),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: EdgeInsets.all(1),
                          height: getProportionateScreenHeight(30),
                          width: getProportionateScreenWidth(40),
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),)
                              ],),
                          child: Container(
                            height: getProportionateScreenHeight(25),
                            width: getProportionateScreenWidth(35),
                            decoration: BoxDecoration(
                              color: orange,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SvgPicture.asset(
                                  "assets/Icons/rating.svg",
                                  width: 10,
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(5),
                                ),
                                Text(
                                  '4.7',
                                  style: GoogleFonts.poppins(
                                      fontSize: 10, color: white),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
