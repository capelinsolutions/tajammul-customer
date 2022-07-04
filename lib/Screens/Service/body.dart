import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:tajammul_customer_app/Components/Loader.dart';
import 'package:tajammul_customer_app/Models/Business.dart';
import 'package:tajammul_customer_app/Screens/Service/screens/service_details.dart';
import 'package:tajammul_customer_app/Screens/Shop/components/shop_card.dart';
import 'package:tajammul_customer_app/colors.dart';

import '../../../../Components/CustomSearchTextField.dart';
import '../../../../SizeConfig.dart';
import '../../Components/CustomDialog.dart';
import '../../Models/Debouncer.dart';
import '../../Models/Service.dart';
import '../../Services/ApiCalls.dart';
import '../../Services/loginUserCredentials.dart';
import '../../main.dart';
import '../MyStore/Components/serviceList.dart';

class Body extends StatefulWidget {
  final Business? business;

  const Body({Key? key, this.business}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  final shopSearchController = TextEditingController();
  bool processing = false;
  bool _isSearching = false;
  bool expansion = false;
  List<Service> _serviceList = [];
  List<Service> _searchServiceList = [];
  final LoginUserCredentials _credentials = LoginUserCredentials();
  final _debouncer = Debouncer(milliseconds: 1000);
  int noOfElements = 10;
  int _pageNo = 0;
  int _totalPages = 0;
  AnimationController? _controller;
  Animation<Offset>? offset;
  String _snackMessage = "";
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();

  @override
  void initState() {
    reset();
    getAllServicesInBusiness();
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    offset = Tween<Offset>(
            begin: const Offset(0.0, -2.0), end: const Offset(0.0, 0.0))
        .animate(_controller!);
  }

  getAllServicesInBusiness() async {
    setState(() {
      processing = true;
    });
    Map<String, String>? result = await ApiCalls.getAllServicesInBusiness(
        widget.business!.businessId!, _pageNo, noOfElements);
    if (result?["error"] == null) {
      setState(() {
        _serviceList = serviceFromJson((result?["success"])!);
        _totalPages = int.parse((result?["totalPages"])!);
        _pageNo++;
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
        getAllServicesInBusiness();
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
      setState(() {
        processing = false;
      });
    }
    setState(() {
      processing = false;
    });
  }

  getLoadMoreServicesInBusiness() async {
    Map<String, String>? result = await ApiCalls.getAllServicesInBusiness(
        widget.business!.businessId!, _pageNo, noOfElements);
    if (result?["error"] == null) {
      setState(() {
        _serviceList.addAll(serviceFromJson((result?["success"])!));
        _totalPages = int.parse((result?["totalPages"])!);
        _pageNo++;
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
        getLoadMoreServicesInBusiness();
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

  getSearchServicesInBusiness(String serviceName) async {
    Map<String, String>? result = await ApiCalls.searchServicesInBusiness(
        widget.business!.businessId!, serviceName);
    if (result?["error"] == null) {
      setState(() {
        _searchServiceList = serviceFromJson((result?["success"])!);
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
        getSearchServicesInBusiness(serviceName);
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
    setState(() {
      processing = false;
    });
  }

  //reset
  reset() {
    setState(() {
      _pageNo = 0;
      _totalPages = 0;
      _serviceList = [];
      _searchServiceList = [];
    });
  }

  //print snack message
  displaySnackMessage(String message) {
    if (mounted) {
      setState(() {
        processing = false;
        _snackMessage = message;
      });
      _controller?.forward();
      Future.delayed(Duration(seconds: 3), () {
        _controller?.reverse();
      });
    }
  }

  @override
  void dispose() {
    shopSearchController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: processing,
          child: Opacity(
            opacity: processing? 0.3 :1.0,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: getProportionateScreenHeight(200),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFFEFEFEF), width: 0.1),
                    boxShadow: const [
                      BoxShadow(
                        color: grey,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    child: (widget.business?.businessInfo?.listImagePath != null &&
                            (widget.business?.businessInfo?.listImagePath
                                ?.isNotEmpty)!)
                        ? CachedNetworkImage(
                            imageUrl:
                                "${env.config?.imageUrl}${(widget.business!.businessInfo!.listImagePath![0])}",
                            fit: BoxFit.fill,
                          )
                        : Image.asset(
                            "assets/Images/background_pic_image",
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
                Positioned(
                  top: getProportionateScreenHeight(50),
                  left: getProportionateScreenWidth(15),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: getProportionateScreenHeight(30),
                      width: getProportionateScreenWidth(30),
                      decoration: BoxDecoration(
                          color: yellowOpacity, shape: BoxShape.circle),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/Icons/back_arrow.svg",
                          width: 8,
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: getProportionateScreenHeight(120)),
                    SizedBox(
                      height: getProportionateScreenHeight(35),
                      width: getProportionateScreenWidth(270),
                      child: CustomSearchTextField(
                        controller: shopSearchController,
                        label: 'Search by Products',
                        onChanged: (value) {
                          reset();
                          if (value != "") {
                            _debouncer.run(() {
                              getSearchServicesInBusiness(value);
                            });
                            setState(() {
                              _isSearching = true;
                            });
                          } else {
                            setState(() {
                              reset();
                              _isSearching = false;
                            });
                            getAllServicesInBusiness();
                          }
                        },
                      ),
                    ),
                    SizedBox(
                        width: getProportionateScreenWidth(270),
                        child: ShopCard(
                          business: widget.business,
                        )),
                    !_isSearching
                        ? SizedBox(height: getProportionateScreenHeight(10))
                        : SizedBox(
                            width: 0.0,
                            height: 0.0,
                          ),
                    !_isSearching
                        ? _serviceList.isEmpty
                            ? Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/Icons/search_icon.svg",
                                      color: blueGrey,
                                      width: 20.0,
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(20.0),
                                    ),
                                    Text(
                                      "This category have no products yet",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: blueGrey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "It will soon to be uploaded",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: blueGrey.withOpacity(0.5),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            : Expanded(
                                child: LazyLoadScrollView(
                                  scrollOffset: 100,
                                  scrollDirection: Axis.vertical,
                                  onEndOfPage: () {
                                    if (_pageNo < _totalPages) {
                                      getLoadMoreServicesInBusiness();
                                    }
                                  },
                                  child: GridView.builder(
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                      top: 10,
                                      right: 15,
                                      bottom: 10,
                                    ),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1 / 1.55,
                                      mainAxisSpacing: 15,
                                      crossAxisSpacing: 10,
                                    ),
                                    itemCount: _serviceList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return ServiceItemsList(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ServiceDetails(
                                                  service: _serviceList[index],
                                                  business: widget.business),
                                            ),
                                          );
                                        },
                                        service: _serviceList[index],
                                        refresh: () {
                                          _pageNo = 0;
                                          getAllServicesInBusiness();
                                        },
                                        processing: (value) {
                                          setState(() {
                                            processing = value;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              )
                        : _searchServiceList.isEmpty
                            ? Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/Icons/search_icon.svg",
                                      color: blueGrey,
                                      width: 20.0,
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(20.0),
                                    ),
                                    Text(
                                      "This category have no products yet",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: blueGrey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "It will soon to be uploaded",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: blueGrey.withOpacity(0.5),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            : Expanded(
                                child: GridView.builder(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                    top: 10,
                                    right: 15,
                                    bottom: 10,
                                  ),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1 / 1.55,
                                    mainAxisSpacing: 15,
                                    crossAxisSpacing: 10,
                                  ),
                                  itemCount: _searchServiceList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return ServiceItemsList(
                                      service: _searchServiceList[index],
                                      refresh: () {
                                        _pageNo = 0;
                                        getAllServicesInBusiness();
                                      },
                                      processing: (value) {
                                        setState(() {
                                          processing = value;
                                        });
                                      },
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ServiceDetails(
                                                service: _searchServiceList[index],
                                                business: widget.business),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                  ],
                ),
              ],
            ),
          ),
        ),
        processing ? Loader(color: orange) : SizedBox(width: 0.0, height: 0.0),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: SlideTransition(
                position: offset!,
                child: Container(
                  margin:
                      EdgeInsets.only(top: getProportionateScreenHeight(10.0)),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Text(
                    _snackMessage,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: white,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
