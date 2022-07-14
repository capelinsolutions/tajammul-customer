import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tajammul_customer_app/Components/CustomButton.dart';
import 'package:tajammul_customer_app/Screens/Tabs/tabs_main.dart';
import '../../../../../Screens/Dashboard/body.dart';
import '../../../../../SizeConfig.dart';
import '../../../../../colors.dart';
import '../../../Components/CustomDialog.dart';
import '../../../Components/Loader.dart';
import '../../../Models/Business.dart';
import '../../../Models/Service.dart';
import '../../../Models/TimeSlots.dart';
import '../../../Models/Timings.dart';
import '../../../Providers/UpdateIndexProvider.dart';
import '../../../Providers/userProvider.dart';
import '../../../Services/ApiCalls.dart';
import '../../../Services/loginUserCredentials.dart';
import '../../../main.dart';

class Body extends StatefulWidget {
  final Service? service;
  final Business? business;
  const Body({Key? key, this.service, this.business}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<InfoComponents> slider = [
    InfoComponents(image: "assets/Images/background_pic_image"),
    InfoComponents(
      image: "assets/Images/background_pic_image",
    ),
  ];

  int activeIndex = 0;
  double infoHeight = 50;
  bool isInfoBoxOpen = false;
  bool isCalendarOpen = false;
  DateTime date = DateTime.now();
  final DateRangePickerController _controller = DateRangePickerController();

  String headerString = '';
  bool isOpened = false;
  List<TimeObj> timeList = [];
  List<TimeSlots> slots = [];
  bool available = false;
  TimeObj? time;
  int? slotNumber;
  String totalAmount = "";
  String instructions = "";
  int? rating = 0;
  final LoginUserCredentials _credentials = LoginUserCredentials();
  bool _processing = false;
  bool _isEnabled = false;
  bool isUserBooked = false;

  @override
  void initState() {
    getSlotsByBusinessAndService(DateFormat("yyyy-MM-dd").format(date));
    super.initState();
  }

  getSlotsByBusinessAndService(String date) async {
    Map<String, String>? result = await ApiCalls.getSlotsByBusinessAndService(
        widget.business!.businessId!,
        widget.service!.serviceName!,
        date,
        context.read<UserProvider>().users.userId!);

    if (result?["error"] == null) {
      setState(() {
        slots = timeSlotsFromJson((result?["success"])!);
        for (var i in slots) {
          if (i.bookedByUser!) {
            isUserBooked = true;
            break;
          }
        }
      });
    } else if (result?["error"] == "Session Expired") {
      await _credentials.getCurrentUser();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
                onWillPop: () async => false,
                child: CustomDialog(
                  message: "The Session Has Been Expired!",
                  firstLabelButton: "Login Again",
                  onFirstPressed: () async {
                    await _credentials.getCurrentUser();
                    String result = await ApiCalls.signInUser(
                        _credentials.getUsername()!,
                        _credentials.getPassword()!);

                    if (result == "Successfully Login") {
                      Navigator.pop(context, true);
                    }
                  },
                  imagePath: 'assets/Images/loginAgain.svg',
                ));
          }).then((value) async {
        getSlotsByBusinessAndService(date);
      });
    } else {
      Fluttertoast.showToast(
          msg: (result?["error"])!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: orange,
          textColor: Colors.white,
          fontSize: 15.0);
    }
  }

  createBookingServices(String date) async {
    setState(() {
      _processing = true;
    });
    Map<String, String>? result = await ApiCalls.createBookingServices(
        widget.business!,
        context.read<UserProvider>().users.userId!,
        date,
        widget.service!,
        slotNumber!,
        time!,
        totalAmount,
        instructions,
        rating!);
    if (result?["error"] == null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CustomDialog(
                message: (result?["success"])!,
                firstLabelButton: 'OK',
                imagePath: 'assets/Images/update.svg',
                onFirstPressed: () {
                  Provider.of<UpdateIndexProvider>(context, listen: false)
                      .setIndex(0);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      TabsScreen.routeName, (Route<dynamic> route) => false);
                },
              ));
      setState(() {
        _processing = false;
      });
    } else if (result?["error"] == "Session Expired") {
      await _credentials.getCurrentUser();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
                onWillPop: () async => false,
                child: CustomDialog(
                  message: "The Session Has Been Expired!",
                  firstLabelButton: "Login Again",
                  onFirstPressed: () async {
                    await _credentials.getCurrentUser();
                    String result = await ApiCalls.signInUser(
                        _credentials.getUsername()!,
                        _credentials.getPassword()!);
                    if (result == "Successfully Login") {
                      Navigator.pop(context, true);
                    }
                  },
                  imagePath: 'assets/Images/loginAgain.svg',
                ));
          }).then((value) async {
        createBookingServices(date);
      });
    } else {
      Fluttertoast.showToast(
          msg: (result?["error"])!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: red,
          textColor: Colors.white,
          fontSize: 15.0);
      setState(() {
        _processing = false;
      });
    }
    setState(() {
      _processing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double cellWidth = width / 9;
    if (widget.service?.discountedPrice == null ||
        widget.service?.discountedPrice == 0) {
      setState(() {
        totalAmount = widget.service!.price!.toString();
      });
    } else {
      setState(() {
        totalAmount = widget.service!.discountedPrice!.toString();
      });
    }
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: _processing,
          child: Opacity(
            opacity: !_processing ? 1.0 : 0.3,
            child: SingleChildScrollView(
              child: InkWell(
                radius: 0,
                onTap: () {
                  setState(() {
                    isCalendarOpen = false;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Container(
                        height: getProportionateScreenHeight(180),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: grey.withOpacity(.7),
                                  blurRadius: 5,
                                  offset: Offset(0, 3))
                            ]),
                        child: CarouselSlider.builder(
                          itemCount: widget.service!.listImagePath == null
                              ? slider.length
                              : widget.service!.listImagePath!.length,
                          options: CarouselOptions(
                              pauseAutoPlayInFiniteScroll: false,
                              height: getProportionateScreenHeight(180.0),
                              scrollDirection: Axis.horizontal,
                              reverse: false,
                              autoPlay: true,
                              viewportFraction: 1.0,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  activeIndex = index;
                                });
                              }),
                          itemBuilder: (context, index, realIndex) {
                            var image = slider[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: (widget.service!.listImagePath != null &&
                                      (widget
                                          .service!.listImagePath!.isNotEmpty))
                                  ? CachedNetworkImage(
                                      width: getProportionateScreenWidth(250.0),
                                      height: double.infinity,
                                      imageUrl:
                                          "${env.config?.imageUrl}${(widget.service!.listImagePath![index])}",
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      "${image.image}",
                                      fit: BoxFit.fill,
                                    ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AnimatedSmoothIndicator(
                          activeIndex: activeIndex, // PageController
                          count: widget.service!.listImagePath == null
                              ? slider.length
                              : widget.service!.listImagePath!.length,
                          effect: ColorTransitionEffect(
                              activeDotColor: orange,
                              dotWidth: 10,
                              dotHeight: 10), // your preferred effect
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      Card(
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
                              Text(
                                '${widget.service!.serviceName}',
                                style: GoogleFonts.poppins(
                                    color: blueGrey,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${widget.service!.description}",
                                style: GoogleFonts.poppins(
                                    color: blueGrey, fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(5),
                              ),
                              (widget.service?.discountedPrice == null ||
                                      widget.service?.discountedPrice == 0)
                                  ? Text(
                                      'Rs ${widget.service?.price}',
                                      style: GoogleFonts.poppins(
                                          color: blueGrey,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Rs. ${widget.service!.discountedPrice}',
                                            style: GoogleFonts.poppins(
                                                color: blueGrey,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          width: getProportionateScreenWidth(4),
                                        ),
                                        Text('Rs. ${widget.service!.price}',
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ))
                                      ],
                                    ),
                              Divider(
                                color: orange,
                                thickness: 1.0,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${widget.business?.businessInfo?.name}',
                                    style: GoogleFonts.poppins(
                                        color: blueGrey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('4.0',
                                      style: GoogleFonts.poppins(
                                          color: blueGrey, fontSize: 12)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SvgPicture.asset(
                                    "assets/Icons/rating_stars.svg",
                                    height: 12,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('(1,080)',
                                      style: GoogleFonts.poppins(
                                          color: blueGrey, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          Card(
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
                                                isInfoBoxOpen = !isInfoBoxOpen;
                                                if (isInfoBoxOpen) {
                                                  infoHeight =
                                                      getProportionateScreenHeight(
                                                          300.0);
                                                } else {
                                                  infoHeight =
                                                      getProportionateScreenHeight(
                                                          50.0);
                                                  setState(() {
                                                    isCalendarOpen = false;
                                                  });
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
                                              child: Row(children: [
                                                SvgPicture.asset(
                                                  "assets/Icons/time.svg",
                                                  height: 12,
                                                ),
                                                SizedBox(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          10.0),
                                                ),
                                                Text(
                                                  "Select your time slot",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      color: blueGrey,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(child: Container()),
                                                !isInfoBoxOpen
                                                    ? Icon(
                                                        Icons
                                                            .keyboard_arrow_down_rounded,
                                                        color: blueGrey,
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .keyboard_arrow_up_rounded,
                                                        color: blueGrey,
                                                      )
                                              ]),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: TextButton.icon(
                                                icon: SvgPicture.asset(
                                                  'assets/Icons/date.svg',
                                                  width: 10,
                                                ),
                                                label: Text(
                                                  DateFormat.yMMMd()
                                                      .format(date),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      color: blueGrey),
                                                ),
                                                style: TextButton.styleFrom(),
                                                onPressed: () {
                                                  setState(() {
                                                    isCalendarOpen =
                                                        !isCalendarOpen;
                                                  });
                                                }),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    getProportionateScreenWidth(
                                                        10.0)),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                        width:
                                                            getProportionateScreenWidth(
                                                                45),
                                                        child: Text(
                                                          'Select',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color:
                                                                      blueGrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                    SizedBox(
                                                        width:
                                                            getProportionateScreenWidth(
                                                                90),
                                                        child: Text(
                                                          'Time',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color:
                                                                      blueGrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                    SizedBox(
                                                        width:
                                                            getProportionateScreenWidth(
                                                                70),
                                                        child: Text(
                                                          'Available',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color:
                                                                      blueGrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                    SizedBox(
                                                        width:
                                                            getProportionateScreenWidth(
                                                                60),
                                                        child: Text(
                                                          'Booked',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color:
                                                                      blueGrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                  ],
                                                ),
                                                slots.isEmpty
                                                    ? SizedBox(
                                                        height:
                                                            getProportionateScreenHeight(
                                                                100),
                                                        child: Center(
                                                          child: Text(
                                                            'No Slots Right Now',
                                                            style: GoogleFonts
                                                                .poppins(),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        height:
                                                            getProportionateScreenHeight(
                                                                170),
                                                        child: ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                slots.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Opacity(
                                                                opacity: (isUserBooked) ? 0.3 : 1.0,
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width:
                                                                          getProportionateScreenWidth(
                                                                              50),
                                                                      child:
                                                                          Radio(
                                                                        value: slots[index].timeObj!,
                                                                        groupValue: time,
                                                                        onChanged: (!(slots[index].bookedByUser!) ||
                                                                                slots[index].totalAvailable != 0)
                                                                            ? (TimeObj? value) {
                                                                                if (isUserBooked == false) {
                                                                                  setState(() {
                                                                                    time = value;
                                                                                    slotNumber = slots[index].slotNumber;
                                                                                    _isEnabled = true;
                                                                                  });
                                                                                } else {
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (context) => CustomDialog(
                                                                                        message: "You already booked this service!",
                                                                                        firstLabelButton: "OK",
                                                                                        onFirstPressed: () {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        imagePath: 'assets/Images/warningUpdate.svg'),
                                                                                  );
                                                                                }
                                                                              }
                                                                            : null,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width: getProportionateScreenWidth(
                                                                            100),
                                                                        child:
                                                                            Text(
                                                                          '${DateFormat('h:mm:a').format(DateTime.parse(slots[index].timeObj!.startTime!))} - ${DateFormat('h:mm:a').format(DateTime.parse(slots[index].timeObj!.endTime!))}',
                                                                          style: GoogleFonts.poppins(
                                                                              color: blueGrey,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 10),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        )),
                                                                    SizedBox(
                                                                        width: getProportionateScreenWidth(
                                                                            90),
                                                                        child:
                                                                            Text(
                                                                          '${slots[index].totalAvailable}',
                                                                          style: GoogleFonts.poppins(
                                                                              color: blueGrey,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 10),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        )),
                                                                    SizedBox(
                                                                        width: getProportionateScreenWidth(
                                                                            60),
                                                                        child:
                                                                            Text(
                                                                          '${slots[index].totalBooked}',
                                                                          style: GoogleFonts.poppins(
                                                                              color: blueGrey,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 10),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        )),
                                                                  ],
                                                                ),
                                                              );
                                                            }),
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
                          ),
                          isCalendarOpen
                              ? isInfoBoxOpen
                                  ? Card(
                                      margin: const EdgeInsets.fromLTRB(
                                          20, 100, 20, 100),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      elevation: 10,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 25, horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Container(
                                                    width: cellWidth / 1.8,
                                                    height: cellWidth / 1.8,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: black)),
                                                    child: Center(
                                                      child: IconButton(
                                                        icon: Icon(Icons
                                                            .arrow_back_ios),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 3),
                                                        color: black,
                                                        iconSize: 10,
                                                        onPressed: () {
                                                          setState(() {
                                                            _controller
                                                                .backward!();
                                                          });
                                                        },
                                                      ),
                                                    )),
                                                SizedBox(
                                                  height: cellWidth / 1.8,
                                                  child: Text(
                                                    DateFormat.yMMMd()
                                                        .format(date),
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        color: blueGrey,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Container(
                                                    width: cellWidth / 1.8,
                                                    height: cellWidth / 1.8,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: orange)),
                                                    child: Center(
                                                      child: IconButton(
                                                        icon: Icon(Icons
                                                            .arrow_forward_ios),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 1),
                                                        color: orange,
                                                        iconSize: 10,
                                                        onPressed: () {
                                                          setState(() {
                                                            _controller
                                                                .forward!();
                                                          });
                                                        },
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          SfDateRangePicker(
                                            selectionColor: orange,
                                            selectionRadius: 15,
                                            controller: _controller,
                                            view: DateRangePickerView.month,
                                            headerHeight: 0,
                                            enablePastDates: false,
                                            initialDisplayDate: date,
                                            initialSelectedDate: date,
                                            onViewChanged: viewChanged,
                                            monthViewSettings:
                                                DateRangePickerMonthViewSettings(
                                              dayFormat: 'EEE',
                                              showTrailingAndLeadingDates: true,
                                              viewHeaderStyle:
                                                  DateRangePickerViewHeaderStyle(
                                                textStyle: GoogleFonts.poppins(
                                                    color: blueGrey,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            monthCellStyle:
                                                DateRangePickerMonthCellStyle(
                                                    leadingDatesTextStyle:
                                                        GoogleFonts.poppins(
                                                            color: grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                    textStyle: GoogleFonts
                                                        .poppins(
                                                            color: orange,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                    trailingDatesTextStyle:
                                                        GoogleFonts.poppins(
                                                            color: grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                            onSelectionChanged: (args) {
                                              if (args.value == null) {
                                                setState(() {
                                                  _isEnabled = false;
                                                });
                                              }
                                              setState(() {
                                                date = args.value;
                                                isCalendarOpen = false;
                                                getSlotsByBusinessAndService(
                                                    DateFormat("yyyy-MM-dd")
                                                        .format(date));
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      height: 0.0,
                                      width: 0.0,
                                    )
                              : SizedBox(
                                  height: 0.0,
                                  width: 0.0,
                                )
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          label: 'Book Now',
                          color: orange,
                          enabled: _isEnabled && !isUserBooked,
                          onPressed: () {
                            createBookingServices(
                                DateFormat("yyyy-MM-dd").format(date));
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        _processing ? const Loader(color: orange) : Container()
      ],
    );
  }

  void viewChanged(DateRangePickerViewChangedArgs args) {
    final DateTime visibleStartDate = args.visibleDateRange.startDate!;
    final DateTime visibleEndDate = args.visibleDateRange.endDate!;
    final int totalVisibleDays =
        (visibleStartDate.difference(visibleEndDate).inDays);
    final DateTime midDate =
        visibleStartDate.add(Duration(days: totalVisibleDays ~/ 2));
    headerString = DateFormat('MMMM yyyy').format(midDate).toString();
    SchedulerBinding.instance.addPostFrameCallback((duration) {
      setState(() {});
    });
  }
}
