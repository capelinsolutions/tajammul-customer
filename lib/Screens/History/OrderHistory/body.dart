import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:tajammul_customer_app/Providers/userProvider.dart';
import 'package:tajammul_customer_app/UserConstant.dart';
import 'package:tajammul_customer_app/colors.dart';

import '../../../Components/CustomDialog.dart';
import '../../../Components/Loader.dart';
import '../../../Models/Order.dart';
import '../../../Services/ApiCalls.dart';
import '../../../Services/loginUserCredentials.dart';
import '../../../SizeConfig.dart';
import 'components/ordersItemsList.dart';

enum RadioSelection { inProgress, completed }

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin{

  final int _noOfElements = 10;
  int _pageNo = 0;
  int _totalPages = 0;
  List<Order> _orderList = [];
  LoginUserCredentials credentials = LoginUserCredentials();
  bool processing = false;
  AnimationController? _controller;
  Animation<Offset>? _offset;
  String _snackMessage = "";

  @override
  void initState(){
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _offset = Tween<Offset>(begin: Offset(0.0, -2.0), end: Offset(0.0, 0.0))
        .animate(_controller!);
    getOrdersByCustomerAndStatus(STATUS_ORDER_IN_PENDING);
    super.initState();
  }

  //get orders by business
  getOrdersByCustomerAndStatus(String orderStatus) async {
    setState(() {
      processing = true;
    });
    Map<String, String>? result = await ApiCalls.getOrdersByCustomerAndStatus(context.read<UserProvider>().users.userId!, _pageNo, _noOfElements, orderStatus);
    if (result?["error"] == null) {
      setState(() {
        _orderList = orderListFromJson((result?["success"])!);
        _totalPages = int.parse((result?["totalPages"])!);
        _pageNo++;
      });
    } else if (result?["error"] == "Session Expired") {
      await credentials.getCurrentUser();
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
                    await credentials.getCurrentUser();
                    String result = await ApiCalls.signInUser(
                        credentials.getUsername()!, credentials.getPassword()!);
                    if (result == "Successfully Login") {
                      Navigator.pop(context, true);
                    }
                  },
                  imagePath: 'assets/Images/loginAgain.svg',
                ));
          }).then((value) async {
        getOrdersByCustomerAndStatus(orderStatus);
      });
    } else {
      displaySnackMessage((result?["error"])!);
      setState(() {
        processing = false;
      });
    }
    setState(() {
      processing = false;
    });
  }

  getLoadMoreOrders(String orderStatus) async {
    Map<String, String>? result = await ApiCalls.getOrdersByCustomerAndStatus(context.read<UserProvider>().users.userId!, _pageNo, _noOfElements, orderStatus);
    if (result?["error"] == null) {
      setState(() {
        _orderList.addAll(orderListFromJson((result?["success"])!));
        _totalPages = int.parse((result?["totalPages"])!);
        _pageNo++;
      });
    } else if (result?["error"] == "Session Expired") {
      await credentials.getCurrentUser();
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
                    await credentials.getCurrentUser();
                    String result = await ApiCalls.signInUser(
                        credentials.getUsername()!, credentials.getPassword()!);
                    if (result == "Successfully Login") {
                      Navigator.pop(context, true);
                    }
                  },
                  imagePath: 'assets/Images/loginAgain.svg',
                ));
          }).then((value) async {
        getLoadMoreOrders(orderStatus);
      });
    } else {
      displaySnackMessage((result?["error"])!);
    }
  }

  displaySnackMessage(String message) {
    setState(() {
      _snackMessage = message;
    });
    _controller?.forward();
    Future.delayed(Duration(seconds: 3), () {
      _controller?.reverse();
    });
  }

  //re initialize all variables
  reInitialize() {
    setState(() {
      _pageNo = 0;
      _totalPages =0;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  RadioSelection _site = RadioSelection.inProgress;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: processing,
          child: Opacity(
            opacity: !processing ? 1.0 : 0.3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: [
                          Radio(
                            value: RadioSelection.inProgress,
                            groupValue: _site,
                            hoverColor: blueGrey,
                            activeColor: blueGrey,
                            onChanged: (RadioSelection? value) {
                              reInitialize();
                              setState(() {
                                _site = value!;
                                getOrdersByCustomerAndStatus(STATUS_ORDER_IN_PENDING);
                              });
                            },
                          ),
                          Text('In-Progress',style: GoogleFonts.poppins(),)
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          children: [
                            Radio(
                              value: RadioSelection.completed,
                              groupValue: _site,
                              hoverColor: blueGrey,
                              activeColor: blueGrey,
                              onChanged: (RadioSelection? value) {
                                reInitialize();
                                setState(() {
                                  _site = value!;
                                  getOrdersByCustomerAndStatus(STATUS_ORDER_COMPLETED);
                                });
                              },
                            ),
                            Text('Completed',style: GoogleFonts.poppins(),)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                    _orderList.isNotEmpty
                    ? Expanded(
                  child: LazyLoadScrollView(
                    scrollOffset: 100,
                    scrollDirection: Axis.vertical,
                    onEndOfPage: () {
                      if (_pageNo < _totalPages) {
                         if(_site == RadioSelection.inProgress){
                           getLoadMoreOrders(STATUS_ORDER_IN_PENDING);
                         } else{
                           getLoadMoreOrders(STATUS_ORDER_COMPLETED);
                         }
                      }
                    },
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _orderList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: OrderItemsList(
                                order: _orderList[index],
                                refresh: (value) {
                                  if (value != null) {
                                    displaySnackMessage(value["success"]);
                                  }
                                }
                            ),
                          );
                        }),
                  ),
                )
                    : Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/Icons/search_icon.svg",
                          color: blueGrey,
                          width: 20.0,
                        ),
                        SizedBox(
                          height:
                          getProportionateScreenHeight(20.0),
                        ),
                        Text(
                          "You do not have any Orders yet",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: blueGrey,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "You can place Orders",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: blueGrey.withOpacity(0.5),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        processing ? Loader(color: orange) : SizedBox(width: 0.0, height: 0.0),
        Align(
          alignment: Alignment.topCenter,
          child: SlideTransition(
            position: _offset!,
            child: Container(
              margin: EdgeInsets.only(top: getProportionateScreenHeight(10.0)),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  color: redBackground,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Text(
                _snackMessage,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 15, color: white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
