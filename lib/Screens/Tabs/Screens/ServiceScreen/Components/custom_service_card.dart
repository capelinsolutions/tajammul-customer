import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tajammul_customer_app/Models/Business.dart';
import 'package:tajammul_customer_app/Models/Timings.dart';
import 'package:tajammul_customer_app/SizeConfig.dart';
import 'package:tajammul_customer_app/colors.dart';


class CustomServiceCard extends StatefulWidget {
  final Business? business;
  final VoidCallback? onTap;

  const CustomServiceCard({Key? key, this.onTap, this.business}) : super(key: key);

  @override
  State<CustomServiceCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomServiceCard> {
  DateTime now = DateTime.now();
  bool isOpened = false;
  List<TimeObj> timeList = [];
  int? ratesOff;

  @override
  void initState() {
    getShopTimings();
    super.initState();
  }

  void getShopTimings() {
    var day = DateFormat('EEEE').format(now);
    switch (day) {
      case "Monday":
        if (widget.business!.timings!.timings!.monday!.isNotEmpty) {
          setState(() {
            timeList = widget.business!.timings!.timings!.monday!;
            isOpened = true;
          });
        }
        break;
      case "Tuesday":
        if (widget.business!.timings!.timings!.tuesday!.isNotEmpty) {
          setState(() {
            timeList = widget.business!.timings!.timings!.tuesday!;
            isOpened = true;
          });
        }
        break;
      case "Wednesday":
        if (widget.business!.timings!.timings!.wednesday!.isNotEmpty) {
          setState(() {
            timeList = widget.business!.timings!.timings!.wednesday!;
            isOpened = true;
          });
        }
        break;

      case "Thursday":
        if (widget.business!.timings!.timings!.thursday!.isNotEmpty) {
          setState(() {
            timeList = widget.business!.timings!.timings!.thursday!;
            isOpened = true;
          });
        }
        break;

      case "Friday":
        if (widget.business!.timings!.timings!.friday!.isNotEmpty) {
          setState(() {
            timeList = widget.business!.timings!.timings!.friday!;
            isOpened = true;
          });
        }
        break;

      case "Saturday":
        if (widget.business!.timings!.timings!.saturday!.isNotEmpty) {
          setState(() {
            timeList = widget.business!.timings!.timings!.saturday!;
            isOpened = true;
          });
        }
        break;

      case "Sunday":
        if (widget.business!.timings!.timings!.sunday!.isNotEmpty) {
          setState(() {
            timeList = widget.business!.timings!.timings!.sunday!;
            isOpened = true;
          });
        }
        break;
      default:
        isOpened = false;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                  width: getProportionateScreenWidth(140),
                  height: getProportionateScreenHeight(130),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: widget.business?.businessInfo?.imagePath == null
                        ? Image(
                            image: AssetImage(
                              'assets/Images/no_image.jpg',
                            ),
                            fit: BoxFit.cover,
                          )
                        : Image(
                            image: NetworkImage(
                                '${widget.business?.businessInfo?.imagePath}'),
                            fit: BoxFit.cover,
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
                      isOpened
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
    );
  }
}
