import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:tajammul_customer_app/Components/Loader.dart';
import 'package:tajammul_customer_app/Models/HiveProduct.dart';
import 'package:tajammul_customer_app/Providers/UpdateIndexProvider.dart';
import 'package:tajammul_customer_app/Services/HiveServices.dart';
import '../../Components/CustomDialog.dart';
import '../../Services/loginUserCredentials.dart';
import '../../SizeConfig.dart';
import '../../colors.dart';
import '../Models/AddressData.dart';
import '../Models/Business.dart';
import '../Models/PlacesDetails.dart';
import '../Models/users.dart';
import '../Providers/userProvider.dart';
import '../Screens/Checkout/checkout_main.dart';
import '../Screens/Dashboard/Components/sidemenu.dart';
import '../Services/ApiCalls.dart';
import 'package:location/location.dart' as loc;
import 'package:tajammul_customer_app/Tabs/body.dart';
import '../Services/LocalNotificationFlutter.dart';
import '../UserConstant.dart';


class TabsScreen extends StatefulWidget {
  static const String routeName = "/Tabs";
  final String? from;
  const TabsScreen({Key? key,this.from}) : super(key: key);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabsScreen> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<Offset>? offset;
  bool bottomSheet = false;
  bool processing = false;
  var location = loc.Location();
  LocationData? currentPosition;
  bool? isLocationEnabled;
  Address? address;
  String _snackMessage = "";
  AnimationController? _controller;
  Box<HiveProduct>? dataBox;
  LoginUserCredentials credentials = LoginUserCredentials();

  @override
  void initState() {
    dataBox = Hive.box<HiveProduct>('cart');
    getUserData();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    offset = Tween<Offset>(
            begin: const Offset(0.0, 1.0), end: const Offset(0.0, 0.0))
        .animate(controller!);
    super.initState();
  }


  final List<String> _appBarTitle = [
    "Home",
    "Profile",
    "History",
    "Notifications",
  ];

  void _onItemTapped(int index) {
    HiveProduct? hp;
    hp=dataBox?.getAt(0);
    if (index == 2) {
      if (hp!.cartData!.isNotEmpty && hp.categoryList!.isNotEmpty) {
        //for index
        Provider.of<UpdateIndexProvider>(context, listen: false).setIndex(0);
        //is on pos screen
        Provider.of<UserProvider>(context, listen: false).isOnCheckout(false);
      } else {
        //for index
        Provider.of<UpdateIndexProvider>(context, listen: false).setIndex(index);
      }
    } else {
      if (Provider.of<UserProvider>(context, listen: false).isCheckout) {
        if (hp!.cartData!.isEmpty && hp.categoryList!.isEmpty) {
          //is on pos screen
          Provider.of<UserProvider>(context, listen: false).isOnCheckout(false);
        } else {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return WillPopScope(
                    onWillPop: () async => false,
                    child: CustomDialog(
                      message: "Are you sure? you want to remove the state",
                      firstLabelButton: "Yes",
                      secondButtonLabel: "No",
                      onFirstPressed: () async {

                        //clear cart list
                        HiveServices.removeAll();

                        Navigator.pop(context);

                        //is on pos screen
                        Provider.of<UserProvider>(context, listen: false)
                            .isOnCheckout(false);
                      },
                      onSecondPressed: () async {
                        //is on pos screen
                        Provider.of<UserProvider>(context, listen: false)
                            .isOnCheckout(false);

                        Navigator.pop(context);
                      },
                      imagePath: 'assets/Images/warningUpdate.svg',
                    ));
              });
        }
      }
      //for index
      Provider.of<UpdateIndexProvider>(context, listen: false).setIndex(index);
    }
  }

  //handle notification on different app states
  notificationHandler(){
    //handle message when app gets terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message!=null){
        final route = message.data['route'];
        if(route == "order" || route == "booking"){
          //HiveServices.removeAll();
          Provider.of<UpdateIndexProvider>(context,listen: false).setIndex(2);
          //Navigator.of(context).pushNamed(TabsScreen.routeName);
        }
      }
    });
    //handle message when app gets terminated
    FirebaseMessaging.onMessage.listen((message) {
      final route = message.data['route'];
      if(route == "order" || route == "booking"){
        LocalNotificationFlutter.display(message);
        // HiveServices.removeAll();
        // Provider.of<UpdateIndexProvider>(context,listen: false).setIndex(2);
        // Navigator.of(context).pushNamed(TabsScreen.routeName);
      }
    });

    //handle message when app gets terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final route = message.data['route'];
      if(route == "order" || route == "booking"){
        //HiveServices.removeAll();
        Provider.of<UpdateIndexProvider>(context,listen: false).setIndex(2);
        //Navigator.of(context).pushNamed(TabsScreen.routeName);
      }
    });
  }

  Future<bool> _checkLocationPermissions() async {
    bool serviceEnabled = false;
    PermissionStatus permission;
    bool permissionCheck = false;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        _checkLocationPermissions();
      } else {
        permission = await location.hasPermission();
        if (permission == PermissionStatus.denied) {
          permission = await location.requestPermission();
          if (permission == PermissionStatus.denied) {
            _checkLocationPermissions();
            permissionCheck = false;
            setState(() {
              processing = false;
            });
          }
        }
        if (permission == PermissionStatus.deniedForever) {
          Fluttertoast.showToast(
              msg:
              "Location permissions are permanently denied, please open app settings to active location permissions.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: orange,
              textColor: Colors.white,
              fontSize: 15.0);
          permissionCheck = false;
          setState(() {
            processing = false;
          });
        }
        permissionCheck = true;
      }
    } else {
      permission = await location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await location.requestPermission();
        if (permission == PermissionStatus.denied) {
          _checkLocationPermissions();
          permissionCheck = false;
          setState(() {
            processing = false;
          });
        }
      }
      if (permission == PermissionStatus.deniedForever) {
        Fluttertoast.showToast(
            msg:
            "Location permissions are permanently denied, please open app settings to active location permissions.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: orange,
            textColor: Colors.white,
            fontSize: 15.0);
        permissionCheck = false;
        setState(() {
          processing = false;
        });
      }
      permissionCheck = true;
    }
    return permissionCheck;
  }

  //get current location of user
  getCurrentLocation() async {
    bool isLocationEnabled = await _checkLocationPermissions();
    if (isLocationEnabled) {
      LocationData position = await location.getLocation();
      currentPosition = position;

      LatLng latLngPosition = LatLng(position.latitude!, position.longitude!);
      address = await getCurrentAddress(latLngPosition);
      addAddress();
    }
  }

  //get Address
  Future<Address?> getCurrentAddress(LatLng latLng) async{
    String result = await ApiCalls.getAddressFromLatLng(latLng.latitude,latLng.longitude);
    if (result != "Something went wrong please try again") {

      PlacesDetails placesDetails = placesDetailsFromJson(result);
      address = setAddress(placesDetails);
      return address;
    }
    else {
      displaySnackMessage(result);
    }
    return null;
  }

  //set address to address object
  Address setAddress(PlacesDetails placesDetails){
    Address? address = Address();
    for (var addComp in placesDetails.addressComponents ?? []) {
      if ((addComp.types?.contains("plus-code") ?? false) || (addComp.types?.contains("street_number") ?? false)) {
        address.street = addComp.longName;
      }
      if ((addComp.types?.contains("premise") ?? false)) {
        String additionalStreet = address.street ?? "";
        additionalStreet += "${addComp.longName} ";
        address.street = additionalStreet;
      }
      if ((addComp.types?.contains("route") ?? false)) {
        String additionalStreet = address.street ?? "";
        additionalStreet += " ${addComp.longName} ";
        address.street = additionalStreet;
      }
      if ((addComp.types?.contains("neighborhood") ?? false)) {
        String additionalStreet = address.street ?? "";
        additionalStreet += " ${addComp.longName} ";
        address.street = additionalStreet;
      }
      if ((addComp.types?.contains("sublocality") ?? false) && (addComp.types?.contains("sublocality_level_1") ?? false)) {
        address.area = addComp.longName;
      }
      if (addComp.types?.contains("administrative_area_level_1") ?? false) {
        address.province = addComp.longName;
      }
      if (addComp.types?.contains("locality") ?? false) {
        address.city = addComp.longName;
      }
      if (addComp.types?.contains("country") ?? false) {
        address.country = addComp.longName;
      }
      if (addComp.types?.contains("postal_code") ?? false) {
        address.postalCode = addComp.longName;
      }
    }
    address.longitude = placesDetails.geometry?.location?.lng.toString();
    address.latitude = placesDetails.geometry?.location?.lat.toString();
    address.formatedAddress =placesDetails.formattedAddress;
    address.addressName = placesDetails.name ?? "";
    address.addressType = USER_CURRENT_ADDRESS;
    return address;
  }

  displaySnackMessage(String message) {
    try {
      setState(() {
        _snackMessage = message;
      });
      _controller?.forward();
      Future.delayed(Duration(seconds: 2), () {
        _controller?.reverse();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  //get businesses according to the address
  calculateBusinessesWithinRange() async {
    Map<String, String>? result = await ApiCalls.calculateBusinessesWithinRange(context.read<UserProvider>().users.userId!);
    if (result?["error"] == null) {
      context.read<UserProvider>().setBusiness(businessFromJson((result?["success"])!));
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
        calculateBusinessesWithinRange();
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

  //add new address according to the location
  addAddress() async {
    Map<String, String>? result = await ApiCalls.addAddress(
        userId: context.read<UserProvider>().users.userId!, input: address!);
    if (result["error"] == null) {
      context.read<UserProvider>().setAddress(addressDataFromJson((result["success"])!));
      calculateBusinessesWithinRange();
    } else if (result["error"] == "Session Expired") {
      await credentials.getCurrentUser();
      setState((){
        processing = false;
      });
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
        addAddress();
      });
    } else {
      Fluttertoast.showToast(
          msg: (result["error"])!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: orange,
          textColor: Colors.white,
          fontSize: 15.0);
      setState((){
        processing = false;
      });
    }
  }

  getUserData() async {
    setState(() {
      processing = true;
    });
    Map<String, String>? result = await ApiCalls.getUserById();
    if (result?["error"] == null) {
      if (mounted) {
        context.read<UserProvider>().setUser(usersFromJson((result?["success"])!));
        getCurrentLocation();
        LocalNotificationFlutter.initialize(context);
        notificationHandler();
      }
    } else if (result?["error"] == "Session Expired") {
      await credentials.getCurrentUser();
      setState((){
        processing = false;
      });
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
                        credentials.getUsername()!,
                        credentials.getPassword()!);
                    if (result == "Successfully Login") {
                      Navigator.pop(context, true);
                    }
                  },
                  imagePath: 'assets/Images/loginAgain.svg',
                ));
          }).then((value) async {
        getUserData();
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
      setState((){
        processing = false;
      });
    }
  }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = GoogleFonts.poppins(
        fontSize: getProportionateScreenWidth(12.0),
        color: blueGrey,
        fontWeight: FontWeight.w700);
    SizeConfig().init(context);
    return Consumer<UpdateIndexProvider>(
      builder: (context, value, child) {
        return ValueListenableBuilder(
            valueListenable: dataBox!.listenable(),
            builder: (context, Box<HiveProduct> items, _){
              return Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    AbsorbPointer(
                      absorbing: processing,
                      child: Opacity(
                        opacity: processing ? 0.3:1.0,
                        child: Scaffold(
                          backgroundColor: backgroundColor,
                          appBar: AppBar(
                            elevation: value.tabIndex == 0 ? 0 : 0.5,
                            backgroundColor: value.tabIndex == 0 ? blueGrey : backgroundColor,
                            leading: Builder(
                              builder: (BuildContext context) {
                                return IconButton(
                                  icon: Icon(
                                    Icons.menu,
                                    color: value.tabIndex == 0 ? white : blueGrey,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return SideMenu(
                                          onTabChanged: (value) {
                                            Navigator.pop(context);
                                            Provider.of<UpdateIndexProvider>(context, listen: false).setIndex(value);
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            centerTitle: true,
                            iconTheme: const IconThemeData(color: blueGrey),
                            title: value.tabIndex == 0
                                ? Text(
                              _appBarTitle[0],
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: white,
                                  fontWeight: FontWeight.w600),
                            )
                                : Text(
                              _appBarTitle[value.tabIndex],
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: blueGrey,
                                  fontWeight: FontWeight.w600),
                            ),
                            actions: [
                              value.tabIndex == 0 ? items.getAt(0)!.cartData!.isNotEmpty ?  InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, CheckoutScreen.routeName);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 20.0),
                              padding: const EdgeInsets.all(2.0),
                              width: getProportionateScreenWidth(40.98),
                              height: getProportionateScreenHeight(31.7),
                              child: Stack(clipBehavior: Clip.none, children: [
                                SvgPicture.asset(
                                  "assets/Icons/Cart.svg",
                                  width: 150.0,
                                ),
                                Positioned(
                                    left: getProportionateScreenWidth(30.0),
                                    top: getProportionateScreenHeight(20.0),
                                    child: Container(
                                      width: getProportionateScreenWidth(12.0),
                                      height: getProportionateScreenWidth(12.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50.0),
                                          color: darkRed),
                                      child: Center(
                                        child: Text(
                                          '${items.getAt(0)!.cartData!.length}',
                                          style: GoogleFonts.poppins(
                                              fontSize: 8,
                                              color: white,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ))
                              ]),
                            ),
                          ) : InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, CheckoutScreen.routeName);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 20.0),
                              padding: const EdgeInsets.all(2.0),
                              width: getProportionateScreenWidth(40.98),

                              height: getProportionateScreenHeight(31.7),
                              child: Stack(clipBehavior: Clip.none, children: [
                                SvgPicture.asset(
                                  "assets/Icons/Cart.svg",
                                  width: 150.0,
                                ),
                                Positioned(
                                    left: getProportionateScreenWidth(30.0),
                                    top: getProportionateScreenHeight(20.0),
                                    child: Container(
                                      width: getProportionateScreenWidth(12.0),
                                      height: getProportionateScreenWidth(12.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50.0),
                                          color: darkRed),
                                      child: Center(
                                        child: Text(
                                          '0',
                                          style: GoogleFonts.poppins(
                                              fontSize: 8,
                                              color: white,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ))
                              ]),
                            ),
                          ) : Container()
                            ],
                          ),
                          body: Body(),
                          bottomNavigationBar: Card(
                            margin: const EdgeInsets.all(0.0),
                            elevation: 20.0,
                            shadowColor: const Color(0xFF93A7BE),
                            color: backgroundColor,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                BottomNavigationBar(
                                  type: BottomNavigationBarType.fixed,
                                  elevation: 0.0,
                                  items: <BottomNavigationBarItem>[
                                    BottomNavigationBarItem(
                                      activeIcon: Padding(
                                        padding: const EdgeInsets.only(bottom: 5.0),
                                        child: SvgPicture.asset(
                                          "assets/Icons/dashboard.svg",
                                          width: getProportionateScreenWidth(22.0),
                                        ),
                                      ),
                                      icon: Padding(
                                        padding: const EdgeInsets.only(bottom: 5.0),
                                        child: SvgPicture.asset(
                                          "assets/Icons/dashboard.svg",
                                          width: getProportionateScreenWidth(22.0),
                                          color: blueGrey.withOpacity(0.5),
                                        ),
                                      ),
                                      label: 'Home',
                                    ),
                                    BottomNavigationBarItem(
                                      activeIcon: Padding(
                                        padding: const EdgeInsets.only(bottom: 5.0),
                                        child: SvgPicture.asset(
                                          "assets/Icons/profile.svg",
                                          width: getProportionateScreenWidth(22.0),
                                        ),
                                      ),
                                      icon: Padding(
                                        padding: const EdgeInsets.only(bottom: 5.0),
                                        child: SvgPicture.asset(
                                          "assets/Icons/profile.svg",
                                          width: getProportionateScreenWidth(22.0),
                                          color: blueGrey.withOpacity(0.5),
                                        ),
                                      ),
                                      label: 'Profile',
                                    ),
                                    BottomNavigationBarItem(
                                      activeIcon: Padding(
                                        padding: const EdgeInsets.only(bottom: 5.0),
                                        child: SvgPicture.asset(
                                          "assets/Icons/products.svg",
                                          width: getProportionateScreenWidth(19.0),
                                        ),
                                      ),
                                      icon: Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0),
                                          child: SvgPicture.asset(
                                            "assets/Icons/products.svg",
                                            width: getProportionateScreenWidth(19.0),
                                            color: blueGrey.withOpacity(0.5),
                                          )),
                                      label: 'History',
                                    ),
                                    BottomNavigationBarItem(
                                      activeIcon: Padding(
                                        padding: const EdgeInsets.only(bottom: 5.0),
                                        child: SvgPicture.asset(
                                          "assets/Icons/notification.svg",
                                          width: getProportionateScreenWidth(22.0),
                                        ),
                                      ),
                                      icon: Padding(
                                        padding: const EdgeInsets.only(bottom: 5.0),
                                        child: SvgPicture.asset(
                                          "assets/Icons/notification.svg",
                                          width: getProportionateScreenWidth(22.0),
                                          color: blueGrey.withOpacity(0.5),
                                        ),
                                      ),
                                      label: 'Notifications',
                                    ),
                                  ],
                                  currentIndex: value.tabIndex,
                                  selectedItemColor: blueGrey,
                                  showSelectedLabels: true,
                                  showUnselectedLabels: true,
                                  selectedLabelStyle: style,
                                  unselectedLabelStyle: style,
                                  selectedIconTheme: const IconThemeData(
                                    color: blueGrey,
                                  ),
                                  unselectedIconTheme: IconThemeData(
                                    color: blueGrey.withOpacity(0.5),
                                  ),
                                  backgroundColor: backgroundColor,
                                  unselectedItemColor: blueGrey.withOpacity(0.5),
                                  onTap: _onItemTapped,
                                ),
                                SvgPicture.asset(
                                  "assets/Images/Home Indicator.svg",
                                  width: 145.0,
                                ),
                                const SizedBox(
                                  height: 3.0,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    processing ? Loader(color: orange) : SizedBox(height: 0.0,width: 0.0,),
                  ],
                ),
              );
            });
      },
    );
  }
}
