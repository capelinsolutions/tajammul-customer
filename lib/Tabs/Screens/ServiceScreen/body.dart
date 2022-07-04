import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tajammul_customer_app/Models/Business.dart';
import 'package:tajammul_customer_app/Providers/userProvider.dart';
import 'package:tajammul_customer_app/SizeConfig.dart';
import 'package:tajammul_customer_app/colors.dart';
import '../../../../Components/CustomSearchTextField.dart';
import '../../../Components/CustomDialog.dart';
import '../../../Components/Loader.dart';
import '../../../Models/Debouncer.dart';
import '../../../Screens/Service/dashboard_service_main.dart';
import '../../../Services/ApiCalls.dart';
import '../../../Services/loginUserCredentials.dart';
import '../ShopScreen/Components/custom_card.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final shopController = TextEditingController();

  bool processing = false;
  final List<Business> _business = [];
  List<Business> _searchBusiness = [];
  final LoginUserCredentials _credentials = LoginUserCredentials();
  final int _noOfElements = 10;
  int _pageNo = 0;
  final _debouncer = Debouncer(milliseconds: 1000);
  bool _isSearching = false;
  @override
  void initState() {
    calculateBusinessesWithinRange();
    for (var i in (context.read<UserProvider>().users.businesses)!) {
      if (i.businessDetails!.servicesList!.isNotEmpty) {
        _business.add(i);
      }
    }
    super.initState();
  }

  calculateBusinessesWithinRange() async {
    setState(() {
      processing = true;
    });
    Map<String, String>? result = await ApiCalls.calculateBusinessesWithinRange(
        context.read<UserProvider>().users.userId!);
    if (result?["error"] == null) {
      context
          .read<UserProvider>()
          .setBusiness(businessFromJson((result?["success"])!));
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

  getShopByNameWhoProvideServices(String businessName) async {
    setState(() {
      processing = true;
    });
    Map<String, String>? result =
        await ApiCalls.getShopByNameWhoProvideServices(
            _pageNo, _noOfElements, businessName);
    if (result?["error"] == null) {
      if (mounted) {
        setState(() {
          print((result?["success"])!);
          _searchBusiness = businessFromJson((result?["success"])!);
          _pageNo++;
        });
      }
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
                      _credentials.getUsername()!, _credentials.getPassword()!);
                  if (result == "Successfully Login") {
                    Navigator.pop(context, true);
                  }
                },
                imagePath: 'assets/Images/loginAgain.svg',
              ),
            );
          }).then((value) async {
        getShopByNameWhoProvideServices(businessName);
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

  //re initialize all variables
  reInitialize() {
    setState(() {
      _pageNo = 0;
      _searchBusiness = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<UserProvider>(builder: (context, user, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: grey.withOpacity(.1),
                        blurRadius: 5,
                        offset: Offset(0, 3))
                  ]),
                  height: getProportionateScreenHeight(35),
                  child: CustomSearchTextField(
                    controller: shopController,
                    label: 'Search by shops',
                    onChanged: (value) {
                      reInitialize();
                      if (value != "") {
                        _debouncer.run(() {
                          getShopByNameWhoProvideServices(value);
                        });
                        setState(() {
                          _isSearching = true;
                        });
                      } else {
                        setState(() {
                          reInitialize();
                          _isSearching = false;
                        });
                        context.read<UserProvider>().users.businesses;
                      }
                    },
                  ),
                ),
              ),
              (user.users.addresses == null || user.users.addresses!.isEmpty)
                  ? SizedBox(
                      height: getProportionateScreenHeight(250),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/Icons/no_address.svg",
                              color: blueGrey,
                              width: 30.0,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(20.0),
                            ),
                            Text(
                              "You have no addresses to search shops!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: blueGrey,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "You can add new address to get shops",
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
                  : _business.isEmpty
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
                                "You do not have any Shops in your vicinity",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: blueGrey,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "You can change your address to get other shops too",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: blueGrey.withOpacity(0.5),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      : !_isSearching
                          ? Expanded(
                              child: GridView.builder(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                  top: 10,
                                  right: 15,
                                  bottom: 10,
                                ),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1 / 1.68,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 10,
                                ),
                                shrinkWrap: true,
                                itemCount: _business.length,
                                itemBuilder: (context, index) {
                                  return CustomCard(
                                    business: _business[index],
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      Navigator.pushNamed(context,
                                          ServiceDashboardScreen.routeName,
                                          arguments: _business[index]);
                                    },
                                  );
                                },
                              ),
                            )
                          : _searchBusiness.isEmpty
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
                                        height:
                                            getProportionateScreenHeight(20.0),
                                      ),
                                      Text(
                                        "There are no shops",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: blueGrey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Please enter the correct name",
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
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1 / 1.68,
                                      mainAxisSpacing: 15,
                                      crossAxisSpacing: 10,
                                    ),
                                    shrinkWrap: true,
                                    itemCount: _searchBusiness.length,
                                    itemBuilder: (context, index) {
                                      return CustomCard(
                                        business: _searchBusiness[index],
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          Navigator.pushNamed(context,
                                              ServiceDashboardScreen.routeName,
                                              arguments:
                                                  _searchBusiness[index]);
                                        },
                                      );
                                    },
                                  ),
                                ),
              SizedBox(
                height: getProportionateScreenHeight(15),
              ),
            ],
          );
        }),
        processing ? Loader(color: orange) : SizedBox(width: 0.0, height: 0.0),
      ],
    );
  }
}
