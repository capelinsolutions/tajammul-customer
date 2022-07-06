import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tajammul_customer_app/Components/CustomDialog.dart';
import 'package:tajammul_customer_app/Components/Loader.dart';
import 'package:tajammul_customer_app/Models/Business.dart';
import 'package:tajammul_customer_app/Models/Debouncer.dart';
import 'package:tajammul_customer_app/Providers/userProvider.dart';
import 'package:tajammul_customer_app/Screens/Shop/dashboard_screen_main.dart';
import 'package:tajammul_customer_app/Services/ApiCalls.dart';
import 'package:tajammul_customer_app/Services/loginUserCredentials.dart';
import 'package:tajammul_customer_app/SizeConfig.dart';
import '../ShopScreen/Components/custom_card.dart';
import 'package:tajammul_customer_app/colors.dart';
import '../../../../Components/CustomSearchTextField.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final shopController = TextEditingController();

  bool processing = false;
  int noOfElements = 10;
  final _debouncer = Debouncer(milliseconds: 1000);
  bool _isSearching = false;
  int pageNo = 0;
  final LoginUserCredentials _credentials = LoginUserCredentials();

  getSearchShopsInBusiness(String shopName) async {
    setState(() {
      processing = true;
    });
    Map<String, String>? result =
        await ApiCalls.getBusinessByName(shopName, noOfElements, pageNo);
    if (result?["error"] == null) {
      context
          .read<UserProvider>()
          .setSearchBusiness(businessFromJson((result?["success"])!));
      setState(() {
        pageNo++;
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
        getSearchShopsInBusiness(shopName);
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
      pageNo = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Stack(
        children: [
          AbsorbPointer(
            absorbing: processing,
            child: Opacity(
              opacity: processing ? 0.3 : 1.0,
              child: Column(
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
                          reset();
                          if (value != "") {
                            _debouncer.run(() {
                              getSearchShopsInBusiness(value);
                            });
                            setState(() {
                              _isSearching = true;
                            });
                          } else {
                            setState(() {
                              reset();
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
                      : user.users.businesses!.isEmpty
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
                                      crossAxisCount:
                                          (width >= 650 && width < 1100) ? 3 : 2,
                                      childAspectRatio: (width >= 650 &&
                                              width < 1100)
                                          ? 1 / getProportionateScreenHeight(0.9)
                                          : 1 / getProportionateScreenHeight(1.75),
                                      mainAxisSpacing: 15,
                                      crossAxisSpacing:
                                          (width >= 650 && width < 1100) ? 15 : 10,
                                    ),
                                    shrinkWrap: true,
                                    itemCount: user.users.businesses!.length,
                                    itemBuilder: (context, index) {
                                      return CustomCard(
                                        business: user.users.businesses![index],
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          Navigator.pushNamed(context, ShopDashboardScreen.routeName,
                                              arguments: user.users.businesses![index]);
                                        },
                                      );
                                    },
                                  ),
                                )
                              : user.searchBusiness.isEmpty
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
                                          scrollDirection: Axis.vertical,
                                          itemCount: user.searchBusiness.length,
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            return CustomCard(
                                              business: user.searchBusiness[index],
                                              onTap: () {
                                                FocusScope.of(context).unfocus();
                                                Navigator.pushNamed(context,
                                                    ShopDashboardScreen.routeName,
                                                    arguments:
                                                        user.searchBusiness[index]);
                                              },
                                            );
                                          }),
                                    ),
                  SizedBox(
                    height: getProportionateScreenHeight(15),
                  ),
                ],
              ),
            ),
          ),
          processing ? Loader(color: orange) : SizedBox(width: 0.0, height: 0.0),
        ],
      );
    });
  }
}
