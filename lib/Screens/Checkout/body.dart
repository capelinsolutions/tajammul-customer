import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tajammul_customer_app/Models/AddressData.dart';
import 'package:tajammul_customer_app/Providers/UpdateIndexProvider.dart';
import 'package:tajammul_customer_app/Providers/userProvider.dart';
import 'package:tajammul_customer_app/Screens/AddAddress/Components/SavedAddresses.dart';
import 'package:tajammul_customer_app/Screens/Tabs/tabs_main.dart';
import 'package:tajammul_customer_app/Services/HiveServices.dart';
import '../../Components/CustomButton.dart';
import '../../Components/CustomDialog.dart';
import '../../Models/CartProduct.dart';
import '../../Models/HiveProduct.dart';
import '../../Models/users.dart';
import '../../Services/ApiCalls.dart';
import '../../Services/loginUserCredentials.dart';
import '../../SizeConfig.dart';
import '../../colors.dart';
import 'Conponents/checkoutList.dart';

class Body extends StatefulWidget {
  final Address? address;
  const Body({Key? key, this.address}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _processing = false;
  LoginUserCredentials credentials = LoginUserCredentials();
  AnimationController? _controller;
  Animation<Offset>? _offset;
  int totalAmount = 0;
  String _snackMessage = "";
  Box<HiveProduct>? dataBox;

  @override
  void initState() {
    // TODO: implement initState
    dataBox = Hive.box<HiveProduct>('cart');
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _offset = Tween<Offset>(begin: Offset(0.0, -2.0), end: Offset(0.0, 0.0))
        .animate(_controller!);
    super.initState();
  }

  //calculate Discount
  int calDiscount(List<CartProduct> productList) {
    int discountedPrice = 0;
    int price = 0;
    for (var i in productList) {
      discountedPrice += (i.discountedPrice ?? i.price!) * i.quantity!;
      price += i.price! * i.quantity!;
    }

    return (price - discountedPrice);
  }

  //calculate total
  int calSub(List<CartProduct> productList) {
    int price = 0;
    for (var i in productList) {
      price += i.price! * i.quantity!;
    }
    return price;
  }

  //calculate total
  int calTotal(List<CartProduct> productList) {
    int discountedPrice = 0;
    int price = 0;
    for (var i in productList) {
      discountedPrice += (i.discountedPrice ?? i.price!) * i.quantity!;
      price += i.price! * i.quantity!;
    }
    totalAmount = price - (price - discountedPrice);
    return price - (price - discountedPrice);
  }

  //on checkout press
  checkoutOrder(List<String> categories, List<CartProduct> cartProduct, Box<HiveProduct> items) async {
    setState(() {
      _processing = true;
    });
    Users user = Provider.of<UserProvider>(context, listen: false).users;
    Map<String, String>? result = await ApiCalls.createOrder(
        categories,
        cartProduct,
        user,
        totalAmount,
        widget.address!,
        items.getAt(0)!.business!);
    if (result?["error"] == null) {
      //clear cart list
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CustomDialog(
                message: (result?["success"])!,
                firstLabelButton: 'OK',
                imagePath: 'assets/Images/update.svg',
                onFirstPressed: () {
                  HiveServices.removeAll();
                  Provider.of<UserProvider>(context, listen: false)
                      .isOnCheckout(false);
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
        checkoutOrder(categories, cartProduct, items);
      });
    } else {
      if ((result?.containsKey("data"))!) {
        HiveServices.initializeCartList(cartProductFromJson((result?["data"])!), items);
        displaySnackMessage((result?["error"])!);
        setState(() {
          _processing = true;
        });
      } else {
        setState(() {
          _processing = false;
        });
      }
    }
    setState(() {
      _processing = false;
    });
  }

  //print snack message
  displaySnackMessage(String message) {
    setState(() {
      _snackMessage = message;
    });
    _controller?.forward();
    Future.delayed(Duration(seconds: 3), () {
      _controller?.reverse();
    });
  }

  Future<bool> _willPopCallback() async {
    Navigator.pop(context);
    Provider.of<UserProvider>(context, listen: false).isOnCheckout(false);
    return Future.value(true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, user, child) {
        return ValueListenableBuilder(
          valueListenable: dataBox!.listenable(),
          builder: (context, Box<HiveProduct> items, _) {
            return WillPopScope(
              onWillPop: _willPopCallback,
              child: SafeArea(
                  child: Stack(
                children: [
                  (items.getAt(0)!.cartData!.isNotEmpty)
                      ? AbsorbPointer(
                          absorbing: _processing,
                          child: Opacity(
                            opacity: !_processing ? 1.0 : 0.3,
                            child: Form(
                              key: _formKey,
                              child: SizedBox(
                                height: double.infinity,
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            getProportionateScreenWidth(16.0),
                                        vertical:
                                            getProportionateScreenHeight(16.0)),
                                    child: Column(
                                      children: [
                                        user.isCheckout
                                            ? Card(
                                                elevation: 20.0,
                                                shadowColor: Color(0xFF93A7BE)
                                                    .withOpacity(0.3),
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(20.0),
                                                      ),
                                                      gradient: RadialGradient(
                                                        radius: 1.5,
                                                        center: Alignment(
                                                            -0.6, -0.6),
                                                        colors: const [
                                                          Color(0xFFEFEFEF),
                                                          Color(0xFFFFFFFF),
                                                        ],
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal:
                                                              getProportionateScreenWidth(
                                                                  15.0),
                                                          vertical:
                                                              getProportionateScreenHeight(
                                                                  10.0)),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Delivery Address",
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontSize:
                                                                        16,
                                                                    color:
                                                                        blueGrey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                getProportionateScreenHeight(
                                                                    10.0),
                                                          ),
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                "assets/Icons/locations.svg",
                                                                width: 10.0,
                                                              ),
                                                              SizedBox(
                                                                width:
                                                                    getProportionateScreenWidth(
                                                                        10),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  "${widget.address?.formatedAddress}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  maxLines: 2,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        blueGrey,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                getProportionateScreenHeight(
                                                                    10.0),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        ListView.separated(
                                          separatorBuilder: (context, index) =>
                                              SizedBox(
                                            height: 10,
                                          ),
                                          clipBehavior: Clip.none,
                                          shrinkWrap: true,
                                          reverse: true,
                                          itemCount: items.getAt(0)!.cartData!.length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (BuildContext context, int index) {
                                            return CheckoutItemsList(
                                              product: (items.getAt(0)!.cartData![index]),
                                              subtract: () {
                                                HiveProduct? hp = items.getAt(0);
                                                if ((hp!.cartData?.length)! > 1) {
                                                  String? category;
                                                  HiveProduct? hp = items.getAt(0);
                                                  hp!.categoryProduct?.forEach((key, value) {
                                                    if (value.contains(hp.cartData?[index].productName)) {
                                                      category = key;
                                                    }
                                                  });
                                                  HiveServices.subtractQuantity(index, category!, items);
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext context) {
                                                        return WillPopScope(
                                                            onWillPop: () async => false,
                                                            child: CustomDialog(
                                                              message: "Are you sure? you want to remove??",
                                                              firstLabelButton: "No",
                                                              secondButtonLabel: "Yes",
                                                              onFirstPressed: () async {
                                                                Navigator.pop(context);
                                                              },
                                                              onSecondPressed: () async {
                                                                String? category;
                                                                hp.categoryProduct?.forEach((key, value) {
                                                                  if (value.contains(hp.cartData?[index].productName)) {
                                                                    category = key;
                                                                  }
                                                                });
                                                                HiveServices.removeProduct((hp.cartData?[index])!, category!, items);
                                                                Navigator.pop(context);
                                                                Provider.of<UpdateIndexProvider>(context, listen: false).setIndex(0);
                                                                Navigator.pushNamed(context, TabsScreen.routeName);
                                                                Provider.of<UserProvider>(context, listen: false).isOnCheckout(false);
                                                              },
                                                              imagePath: 'assets/Images/warningUpdate.svg',
                                                            ));
                                                      });
                                                }
                                              },
                                              remove: () {
                                                HiveProduct? hp = items.getAt(0);
                                                if ((hp!.cartData?.length)! > 1) {
                                                  String? category;
                                                  hp.categoryProduct
                                                      ?.forEach((key, value) {
                                                    if (value.contains(hp
                                                        .cartData?[index]
                                                        .productName)) {
                                                      category = key;
                                                    }
                                                  });
                                                  HiveServices.removeProduct(
                                                      (hp.cartData?[index])!,
                                                      category!,
                                                      items);
                                                }
                                                else {
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext context) {
                                                        return WillPopScope(
                                                            onWillPop: () async => false,
                                                            child: CustomDialog(
                                                              message: "Are you sure? you want to remove??",
                                                              firstLabelButton: "No",
                                                              secondButtonLabel: "Yes",
                                                              onFirstPressed: () async {
                                                                Navigator.pop(context);
                                                              },
                                                              onSecondPressed: () async {
                                                                String? category;
                                                                hp.categoryProduct?.forEach((key, value) {
                                                                  if (value.contains(hp.cartData?[index].productName)) {
                                                                    category = key;
                                                                  }
                                                                });
                                                                HiveServices.removeProduct((hp.cartData?[index])!, category!, items);
                                                                Navigator.pop(context);
                                                                Provider.of<UpdateIndexProvider>(context, listen: false).setIndex(0);
                                                                Navigator.pushNamed(context, TabsScreen.routeName);
                                                                Provider.of<UserProvider>(context, listen: false).isOnCheckout(false);
                                                              },
                                                              imagePath: 'assets/Images/warningUpdate.svg',
                                                            ));
                                                      });
                                                }
                                              },
                                              add: () {
                                                HiveProduct? hp = items.getAt(0);
                                                if ((hp!.cartData?[index].quantity)! <
                                                    (hp.cartData?[index].updatedStock)!) {
                                                  HiveServices.addQuantity(index, items);
                                                } else {
                                                  displaySnackMessage(
                                                      "You can't add more ");
                                                }
                                              },
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: getProportionateScreenHeight(
                                              10.0),
                                        ),
                                        Card(
                                          elevation: 20.0,
                                          shadowColor: Color(0xFF93A7BE)
                                              .withOpacity(0.3),
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2.0),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0),
                                                ),
                                                gradient: RadialGradient(
                                                  radius: 1.5,
                                                  center: Alignment(-0.6, -0.6),
                                                  colors: const [
                                                    Color(0xFFEFEFEF),
                                                    Color(0xFFFFFFFF),
                                                  ],
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        getProportionateScreenWidth(
                                                            15.0),
                                                    vertical:
                                                        getProportionateScreenHeight(
                                                            10.0)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Payment details",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 16,
                                                              color: blueGrey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          getProportionateScreenHeight(
                                                              10.0),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Subtotal",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 14,
                                                                  color:
                                                                      blueGrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                        Text(
                                                          "Rs. ${calSub(items.getAt(0)!.cartData!).toString()}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 14,
                                                                  color:
                                                                      blueGrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          getProportionateScreenHeight(
                                                              10.0),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Discount",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 14,
                                                                  color:
                                                                      blueGrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                        Text(
                                                          "Rs. ${calDiscount(items.getAt(0)!.cartData!).toString()}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 14,
                                                                  color:
                                                                      blueGrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          getProportionateScreenHeight(
                                                              10.0),
                                                    ),
                                                    Divider(
                                                      color: orange,
                                                      thickness: 1.0,
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          getProportionateScreenHeight(
                                                              5.0),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Total",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 15,
                                                                  color: orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                        Text(
                                                          "Rs. ${calTotal(items.getAt(0)!.cartData!).toString()}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 15,
                                                                  color: orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          getProportionateScreenHeight(
                                                              5.0),
                                                    ),
                                                    Divider(
                                                      color: orange,
                                                      thickness: 1.0,
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          getProportionateScreenHeight(
                                                              10.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: user.isCheckout
                                              ? SizedBox(
                                                  height:
                                                      getProportionateScreenHeight(
                                                          45.0),
                                                  width: double.infinity,
                                                  child: CustomButton(
                                                      label: "Checkout",
                                                      color: orange,
                                                      onPressed: () {
                                                        checkoutOrder(
                                                            items
                                                                .getAt(0)!
                                                                .categoryList!,
                                                            items
                                                                .getAt(0)!
                                                                .cartData!,
                                                            items);
                                                      }),
                                                )
                                              : SizedBox(
                                                  height:
                                                      getProportionateScreenHeight(
                                                          45.0),
                                                  width: double.infinity,
                                                  child: CustomButton(
                                                      label:
                                                          "Review payment and address",
                                                      color: orange,
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    SavedAddresses(
                                                                        from:
                                                                            'checkout')));
                                                      }),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/Icons/cartIcon.svg",
                                width: 40.0,
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10.0),
                              ),
                              Text(
                                "Empty!!",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: blueGrey,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "You haven't added anything in the cart",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: blueGrey.withOpacity(0.5),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: SlideTransition(
                      position: _offset!,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: getProportionateScreenHeight(10.0)),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            color: redBackground,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
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
                ],
              )),
            );
          },
        );
      },
    );
  }
}
