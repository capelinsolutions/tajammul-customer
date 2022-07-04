
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tajammul_customer_app/Providers/userProvider.dart';
import 'package:tajammul_customer_app/Screens/AddAddress/add_address_main.dart';
import 'package:tajammul_customer_app/Screens/Checkout/checkout_main.dart';
import 'package:tajammul_customer_app/colors.dart';
import '../../../Components/CustomButton.dart';
import '../../../Components/CustomDialog.dart';
import '../../../Components/Loader.dart';
import '../../../Models/AddressData.dart';
import '../../../Models/Business.dart';
import '../../../Models/users.dart';
import '../../../Services/ApiCalls.dart';
import '../../../Services/loginUserCredentials.dart';
import '../../../SizeConfig.dart';

class SavedAddresses extends StatefulWidget {
  static const String routeName = "/savedAddresses";
  final String? from;
  const SavedAddresses({Key? key, this.from}) : super(key: key);

  @override
  State<SavedAddresses> createState() => _SavedAddressesState();
}

class _SavedAddressesState extends State<SavedAddresses> {
  LoginUserCredentials credentials = LoginUserCredentials();
  int? addressIndex;
  List<AddressData> selectedAddress = [];
  bool processing = false;
  bool isDelete = false;

  deleteAddress(Address? addressData) async {
    setState(() {
      processing = true;
    });
    Map<String, String>? result = await ApiCalls.deleteAddress(
        userId: context.read<UserProvider>().users.userId!,
        input: addressData!,
        index: addressIndex!);
    if (result["error"] == null) {
      context.read<UserProvider>().setAddress(addressDataFromJson((result["success"])!));
      Fluttertoast.showToast(
          msg: ('Address Deleted'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: orange,
          textColor: Colors.white,
          fontSize: 15.0);
    } else if (result["error"] == "Session Expired") {
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
        deleteAddress(value);
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
    }
    setState(() {
      processing = false;
    });
  }

  //get orders by business
  calculateBusinessesWithinRange() async {
    Map<String, String>? result = await ApiCalls.calculateBusinessesWithinRange(context.read<UserProvider>().users.userId!);
    if (result?["error"] == null) {
      if(!isDelete){
        context.read<UserProvider>().setBusiness(businessFromJson((result?["success"])!));
        Navigator.pop(context);
        Navigator.pop(context);
      }else{
        context.read<UserProvider>().setBusiness(businessFromJson((result?["success"])!));
      }
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
    setState((){
      processing = false;
    });
  }

  updateUserAddressStatus(int index) async {
    setState(() {
      processing = true;
    });
    Map<String, String>? result = await ApiCalls.updateUserAddressStatus(context.read<UserProvider>().users.userId!,index);
    if (result?["error"] == null) {
      context.read<UserProvider>().setUser(usersFromJson((result?["success"])!));
      calculateBusinessesWithinRange();
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
        updateUserAddressStatus(index);
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

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 1.0,
          centerTitle: true,
          iconTheme: IconThemeData(color: blueGrey),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
          ),
          title: Text(
            "Addresses",
            style: GoogleFonts.poppins(
                fontSize: 18, color: blueGrey, fontWeight: FontWeight.w600),
          ),
        ),
        body:
        user.users.addresses!.isEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: getProportionateScreenHeight(250),child: Center(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/Icons/no_address.svg",
                        width: 100.0,
                      ),
                      SizedBox(
                        height:
                        getProportionateScreenHeight(
                            20.0),
                      ),
                      Text(
                        "You do not have any Addresses yet",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: blueGrey,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Tap on the button to add a new one!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color:
                            blueGrey.withOpacity(0.5),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.7,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(10.0),
                        vertical: getProportionateScreenHeight(10)),
                    child: CustomButton(
                      label: 'Add New Address',
                      color: orange,
                      onPressed: () => Navigator.pushNamed(
                          context, AddAddressScreen.routeName),
                    ),
                  ),
                ),
              ],
            )
            : Stack(
              children: [
                AbsorbPointer(
                  absorbing: processing,
                  child: Opacity(
                    opacity: !processing ? 1.0 : 0.3,
                    child: Column(
                        children: [
                          SizedBox(height: getProportionateScreenHeight(10.0)),
                          Expanded(
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) => SizedBox(
                                        height: getProportionateScreenHeight(15),
                                      ),
                                  itemCount: user.users.addresses!.length,
                                  itemBuilder: (context, index) {
                                    var address = user.users.addresses![index].address;
                                    var isActive = user.users.addresses![index].isActive;
                                    return InkWell(
                                      onTap: () {
                                        if (widget.from == "checkout") {
                                          Provider.of<UserProvider>(context, listen: false).isOnCheckout(true);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen(address: address)));
                                        } else {
                                          setState((){
                                            isDelete = false;
                                          });
                                          Provider.of<UserProvider>(context, listen: false).isOnCheckout(false);
                                          updateUserAddressStatus(index);
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                getProportionateScreenWidth(10.0)),
                                        child: Card(
                                          elevation: 20.0,
                                          shadowColor:
                                              Color(0xFF93A7BE).withOpacity(0.3),
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 2.0),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0),
                                                ),
                                                border: (isActive)! ? Border.all(color: blueGrey,width: 5) : null,
                                                gradient: RadialGradient(
                                                  radius: 1.0,
                                                  center: Alignment(-0.6, -0.7),
                                                  colors: const [
                                                    Color(0xFFEFEFEF),
                                                    Color(0xFFFFFFFF),
                                                  ],
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        getProportionateScreenWidth(10),
                                                    vertical:
                                                        getProportionateScreenHeight(
                                                            5)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text("Delivery Address", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 14, color: blueGrey, fontWeight: FontWeight.bold),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child: InkWell(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => AddAddressScreen(address: user.users.addresses![index].address,
                                                                                  index: index)));
                                                                    },
                                                                    child: Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(8.0),
                                                                      child: Icon(
                                                                        Icons.edit,
                                                                        color: green,
                                                                        size: 20,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                user.users.addresses!.length != 1 ? SizedBox(
                                                                  width:
                                                                      getProportionateScreenWidth(
                                                                          3),
                                                                ): SizedBox(height: 0.0,width: 0.0,),
                                                                user.users.addresses!.length != 1 ? Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child: InkWell(
                                                                      onTap: () {
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return CustomDialog(
                                                                              message:
                                                                                  "Do you want to delete this address?",
                                                                              firstLabelButton:
                                                                                  'No',
                                                                              secondButtonLabel:
                                                                                  'Yes',
                                                                              imagePath:
                                                                                  '',
                                                                              onFirstPressed:
                                                                                  () {
                                                                                Navigator.pop(
                                                                                    context);
                                                                              },
                                                                              onSecondPressed:
                                                                                  () {
                                                                                Address? newAddress;
                                                                                setState(() {
                                                                                  addressIndex = index;
                                                                                  newAddress = address;
                                                                                });
                                                                                deleteAddress(newAddress);
                                                                                setState((){
                                                                                  isDelete = true;
                                                                                });
                                                                                calculateBusinessesWithinRange();
                                                                                Navigator.pop(context);
                                                                              },
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      child: Padding(
                                                                        padding:
                                                                            const EdgeInsets
                                                                                    .all(
                                                                                8.0),
                                                                        child:
                                                                            SvgPicture
                                                                                .asset(
                                                                          "assets/Icons/delete_Icon.svg",
                                                                          width: 15,
                                                                        ),
                                                                      )),
                                                                ) : SizedBox(height: 0.0,width: 0.0,),
                                                              ],
                                                            )
                                                          ]),
                                                    ),
                                                    Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Icon(
                                                            Icons.location_on_outlined,
                                                            color: orange,
                                                            size: 20,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                getProportionateScreenWidth(
                                                                    05.0),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding: EdgeInsets.only(
                                                                  right:
                                                                      getProportionateScreenWidth(
                                                                          20.0)),
                                                              child: Text(
                                                                "${address?.addressName} ${address?.formatedAddress}",
                                                                style:
                                                                    GoogleFonts.poppins(
                                                                  fontSize: 14,
                                                                  color: blueGrey,
                                                                ),
                                                                maxLines: 2,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    Align(
                                                      alignment: Alignment.bottomRight,
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 20,
                                                        color: blueGrey,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          getProportionateScreenHeight(
                                                              5),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  })),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(10.0),
                                  vertical: getProportionateScreenHeight(10)),
                              child: CustomButton(
                                label: 'Add New Address',
                                color: orange,
                                onPressed: () => Navigator.pushNamed(
                                    context, AddAddressScreen.routeName),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ),
                ),
                processing ? Loader(color: orange) : SizedBox(width: 0.0, height: 0.0),
              ],
            ),
      );
    });
  }
}
