import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tajammul_customer_app/Models/Bookings.dart';

import '../../../../SizeConfig.dart';
import '../../../../colors.dart';
import '../../../../main.dart';

class BookingItemsList extends StatefulWidget {
  final Bookings bookings;
  final Function refresh;
  const BookingItemsList({Key? key, required this.bookings, required this.refresh}) : super(key: key);

  @override
  State<BookingItemsList> createState() => _BookingItemsListState();
}

class _BookingItemsListState extends State<BookingItemsList> {

  double infoHeight =90;
  bool isInfoBoxOpen = false;

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
      child: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            gradient: RadialGradient(
              radius: 1.0,
              center: Alignment(-0.6, -0.7),
              colors: const [
                Color(0xFFEFEFEF),
                Color(0xFFFFFFFF),
              ],
            ),
          ),
          child: AnimatedSize(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 500),
            child: SizedBox(
              width: double.infinity,
              height: infoHeight,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isInfoBoxOpen =  !isInfoBoxOpen;
                          if (isInfoBoxOpen) {
                            infoHeight =
                                getProportionateScreenHeight(
                                    260.0);
                          } else {
                            infoHeight =
                                getProportionateScreenHeight(
                                    90.0);
                          }
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                            getProportionateScreenWidth(
                                10.0),
                            vertical:
                            getProportionateScreenHeight(
                                10.0)),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children:[
                                        Text(
                                          "Booking ID: ",
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              color: blueGrey,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "${widget.bookings.bookingId.toString()} ",
                                          textAlign: TextAlign.start,
                                          //overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              color: blueGrey,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ]
                                  ),
                                  !isInfoBoxOpen
                                      ? Icon(
                                    Icons
                                        .keyboard_arrow_down_rounded,
                                    color:
                                    blueGrey,
                                  )
                                      : Icon(
                                    Icons
                                        .keyboard_arrow_up_rounded,
                                    color:
                                    blueGrey,
                                  )
                                ]),
                            Row(
                              children: [
                                SizedBox(
                                  width: getProportionateScreenWidth(30),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child:(widget.bookings.business?.users?[0].imagePath !=null && (widget.bookings.business?.users?[0].imagePath!.isNotEmpty)!)
                                        ? CachedNetworkImage(
                                      imageUrl: "${env.config?.imageUrl}${(widget.bookings.business?.users?[0].imagePath)}",
                                      fit: BoxFit.fill,
                                    )
                                        :Image.asset(
                                      "assets/Images/background_pic_image",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        children:[
                                          Text(
                                            widget.bookings.business?.users?[0].name?.firstName ?? " ",
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: blueGrey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(" "),
                                          Text(
                                            widget.bookings.business?.users?[0].name?.lastName ?? " ",
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: blueGrey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ]
                                    ),
                                    Text(
                                      widget.bookings.business?.businessInfo?.name ?? "",
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: orange,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(
                          horizontal:
                          getProportionateScreenWidth(
                              15.0)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: getProportionateScreenHeight(120),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                      Text("${widget.bookings.bookingDetails?.serviceCartItems?.serviceName}".toUpperCase(),style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: blueGrey,
                                          fontWeight: FontWeight.w700,
                                      ),),
                                        SizedBox(height: 15,),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Time Slot",style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: black,
                                                  fontWeight: FontWeight.w700),),
                                              Text(
                                                '${DateFormat('h:mm:a').format(DateTime.parse(widget.bookings.bookingDetails!.timeObj!.startTime!))} to ${DateFormat('h:mm:a').format(DateTime.parse(widget.bookings.bookingDetails!.timeObj!.endTime!))}',style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: green,
                                                  fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Price",style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: black,
                                                  fontWeight: FontWeight.w700),),
                                              Text("Rs. ${widget.bookings.bookingDetails?.serviceCartItems?.price}",style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: orange,
                                                  fontWeight: FontWeight.w500,
                                              ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Discount",style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: black,
                                                  fontWeight: FontWeight.w700),),
                                              Text("Rs. ${(widget.bookings.bookingDetails?.serviceCartItems?.price)! - (widget.bookings.bookingDetails?.serviceCartItems?.discountedPrice ?? widget.bookings.bookingDetails?.serviceCartItems?.price)!}",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: orange,
                                                    fontWeight: FontWeight.w500),),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total',style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: orange,
                                  fontWeight: FontWeight.w500),),
                              Text(
                                "Rs. ${widget.bookings.bookingDetails!.serviceCartItems!.discountedPrice}",
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: orange,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
