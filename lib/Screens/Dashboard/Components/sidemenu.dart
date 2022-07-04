import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tajammul_customer_app/Providers/UpdateIndexProvider.dart';
import 'package:tajammul_customer_app/Providers/userProvider.dart';
import 'package:tajammul_customer_app/Screens/AddAddress/Components/PrivacyPolicy.dart';
import 'package:tajammul_customer_app/Screens/AddAddress/Components/SavedAddresses.dart';
import 'package:tajammul_customer_app/Screens/Dashboard/Components/sidemenulistview.dart';
import 'package:tajammul_customer_app/Screens/Favourites/favourites_screen.dart';
import 'package:tajammul_customer_app/main.dart';
import '../../../Components/CustomButton.dart';
import '../../../SizeConfig.dart';
import '../../../colors.dart';
import '../../SignIn/sign_in_main.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SideMenu extends StatefulWidget {
  final Function? onTabChanged;
  const SideMenu({
    Key? key, this.onTabChanged,
  }) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context,user,child){
      return Consumer<UpdateIndexProvider>(builder:(context, index,child){
        return Dialog(
            alignment: Alignment.center,
            elevation: 20.0,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            insetPadding: EdgeInsets.only(left: getProportionateScreenWidth(25.0),
                right: getProportionateScreenWidth(25.0),bottom: getProportionateScreenHeight(20.0)),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          padding: EdgeInsets.all(12.0),
                          width: getProportionateScreenWidth(40.0),
                          height: getProportionateScreenHeight(40.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            color: white,
                            border: Border.all(color: blueGrey, width: 1.0),
                          ),
                          child: SvgPicture.asset(
                            "assets/Icons/sideMenuClose.svg", color: blueGrey,)
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(5.0),),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(13.0),
                          ),
                          color: white),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              elevation: 10.0,
                              shadowColor: Color(0xFF93A7BE).withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  border:
                                  Border.all(color: Color(0xFFEFEFEF), width: 0.1),
                                  gradient: RadialGradient(
                                    radius: 1.0,
                                    center: Alignment(-0.6, -0.7),
                                    colors: const [
                                      Color(0xFFEFEFEF),
                                      Color(0xFFFFFFFF),
                                    ],
                                  ),
                                ),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: getProportionateScreenWidth(90.0),
                                        height: getProportionateScreenHeight(80.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    12.0)),
                                            child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  child: (user.users.imagePath!.isNotEmpty) && (user.users.imagePath !=null)
                                                      ? CachedNetworkImage(
                                                    imageUrl: "${env.config?.imageUrl}${(user.users.imagePath)!}",
                                                    fit: BoxFit.fill,
                                                  )
                                                      :Image.asset(
                                                    "assets/Images/background_pic_image",
                                                    fit: BoxFit.fill,
                                                  ),
                                                )
                                            )),
                                      ),
                                      SizedBox(
                                        width: getProportionateScreenWidth(10.0),
                                      ),
                                      Expanded(
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                "${user.users.name?.firstName} ${user.users.name?.lastName}",
                                                textAlign: TextAlign.start,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 18,
                                                    color: blueGrey,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              Text(
                                                "${user.users.phoneNumber}",
                                                textAlign: TextAlign.start,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: blueGrey,
                                                    fontWeight: FontWeight.normal),
                                              ),
                                            ]),
                                      ),

                                    ]
                                ),
                              ),
                            ),

                            SizedBox(height: getProportionateScreenHeight(20.0),),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                                  color: index.tabIndex == 0
                                      ? blueGrey.withOpacity(0.40)
                                      : Colors.transparent),
                              child: SideMenuListView(
                                  label: "Dashboard",
                                  primaryColor:
                                  index.tabIndex == 0 ? white : blueGrey,
                                  secondaryColor: index.tabIndex == 0
                                      ? blueGrey.withOpacity(0.40)
                                      : white,
                                  imagePath: "assets/Icons/dashboardGrid.svg",
                                  padding: 10.0,
                                  width: getProportionateScreenWidth(40.0),
                                  height: getProportionateScreenHeight(40.0),
                                  fontSize: 15,
                                  onPressed: () {
                                    widget.onTabChanged!(0);
                                  }),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                                  color: index.tabIndex == 2
                                      ? blueGrey.withOpacity(0.40)
                                      : Colors.transparent),
                              child: SideMenuListView(
                                  label: "History",
                                  primaryColor:
                                  index.tabIndex == 2 ? white : blueGrey,
                                  secondaryColor: index.tabIndex == 2
                                      ? blueGrey.withOpacity(0.40)
                                      : white,
                                  imagePath: "assets/Icons/orderHistory.svg",
                                  padding: 10.0,
                                  width: getProportionateScreenWidth(40.0),
                                  height: getProportionateScreenHeight(40.0),
                                  fontSize: 15,
                                  onPressed: () {
                                    widget.onTabChanged!(2);
                                  }),
                            ),
                            SideMenuListView(
                                label: "Addresses",
                                primaryColor: blueGrey,
                                secondaryColor: white,
                                imagePath: "assets/Icons/marker.svg",
                                padding: 10.0,
                                width: getProportionateScreenWidth(40.0),
                                height: getProportionateScreenHeight(40.0),
                                fontSize: 15,
                                onPressed: () {
                                  Navigator.pushNamed(context, SavedAddresses.routeName);
                                }),
                            SideMenuListView(
                                label: "Favourites",
                                primaryColor: blueGrey,
                                secondaryColor: white,
                                imagePath: "assets/Icons/heart_fill.svg",
                                padding: 10.0,
                                width: getProportionateScreenWidth(40.0),
                                height: getProportionateScreenHeight(40.0),
                                fontSize: 15,
                                onPressed: () {
                                  Navigator.pushNamed(context, FavouritesScreen.routeName);
                                }),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                                  color: index.tabIndex == 1
                                      ? blueGrey.withOpacity(0.40)
                                      : Colors.transparent),
                              child: SideMenuListView(
                                  label: "Settings",
                                  primaryColor:
                                  index.tabIndex == 1 ? white : blueGrey,
                                  secondaryColor: index.tabIndex == 1
                                      ? blueGrey.withOpacity(0.40)
                                      : white,
                                  imagePath: "assets/Icons/orderHistory.svg",
                                  padding: 10.0,
                                  width: getProportionateScreenWidth(40.0),
                                  height: getProportionateScreenHeight(40.0),
                                  fontSize: 15,
                                  onPressed: () {
                                    widget.onTabChanged!(1);
                                  }),
                            ),
                            SizedBox(height: getProportionateScreenHeight(70),),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Divider(
                                color: blueGrey,
                                thickness: 0.8,
                              ),
                            ),
                            SideMenuListView(
                                label: "Privacy Policy",
                                primaryColor: blueGrey,
                                secondaryColor: white,
                                imagePath: "assets/Icons/privacyPolicy.svg",
                                padding: 10.0,
                                width: getProportionateScreenWidth(40.0),
                                height: getProportionateScreenHeight(40.0),
                                fontSize: 15,
                                onPressed: () {
                                  Navigator.pushNamed(context, PrivacyPolicy.routeName);
                                }),
                            SizedBox(height: getProportionateScreenHeight(15.0),),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: SizedBox(
                                height: getProportionateScreenHeight(45.0),
                                width: double.infinity,
                                child: CustomButton(
                                    label: "Logout",
                                    color: orange,
                                    onPressed: () async {
                                      SharedPreferences _preferences = await SharedPreferences.getInstance();
                                      _preferences.setString("userCredentials", "");
                                      Navigator.of(context).pushNamedAndRemoveUntil(SignInScreen.routeName, (Route<dynamic> route) => false);
                                    }
                                ),
                              ),
                            ),
                            SizedBox(height: getProportionateScreenHeight(25.0),)
                          ]
                      ),
                    )
                  ]
              ),
            )
        );
      });
    });
  }
}
