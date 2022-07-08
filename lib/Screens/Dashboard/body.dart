import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tajammul_customer_app/Screens/Tabs/Screens/ServiceScreen/services_screen.dart';
import 'package:tajammul_customer_app/Screens/Tabs/Screens/ShopScreen/shop_screen.dart';
import '../../Components/CustomDialog.dart';
import '../../Components/Loader.dart';
import '../../Models/Business.dart';
import '../../Providers/userProvider.dart';
import '../../Services/ApiCalls.dart';
import '../../Services/loginUserCredentials.dart';
import '../../SizeConfig.dart';
import '../../colors.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin{
  List<InfoComponents> slider = [
    InfoComponents(image: "assets/Images/Info1.svg",),
    InfoComponents(image: "assets/Images/Info2.svg",),
    InfoComponents(image: "assets/Images/Info3.svg"),
  ];
  TabController? _controller;
  int _selectedIndex = 0;
  int activeIndex =0;
  bool processing = false;
  final LoginUserCredentials _credentials = LoginUserCredentials();


  calculateBusinessesWithinRange() async {
    setState(() {
      processing = true;
    });
    Map<String, String>? result = await ApiCalls.calculateBusinessesWithinRange(context.read<UserProvider>().users.userId!);
    if (result?["error"] == null) {
      context.read<UserProvider>().setBusiness(businessFromJson((result?["success"])!));
      setState(() {
        _selectedIndex = _controller!.index;
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
                        _credentials.getUsername()!, _credentials.getPassword()!);
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

  final List<Widget> _screens = <Widget>[
    ShopScreen(),
    ServiceScreen()
  ];

  @override
  void initState(){
    super.initState();
    _controller = TabController(length: _screens.length, vsync: this);
    _controller?.addListener(() {
      calculateBusinessesWithinRange();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Container(
              height: getProportionateScreenHeight(100),
              decoration: BoxDecoration(
                  color: blueGrey,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Container(
                    height: getProportionateScreenHeight(150),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      child: CarouselSlider.builder(
                        itemCount: slider.length,
                        options: CarouselOptions(
                            pauseAutoPlayInFiniteScroll: false,
                            height: getProportionateScreenHeight(350.0),
                            scrollDirection: Axis.horizontal,
                            reverse: false,
                            autoPlay: true,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            autoPlayAnimationDuration: Duration(milliseconds: 800),
                            enableInfiniteScroll: true,
                            viewportFraction: 1.0 ,
                            onPageChanged: (index,reason){
                              setState(() {
                                activeIndex=index;
                              });
                            }
                        ),
                        itemBuilder: (context,index,realIndex){
                          return SizedBox(
                            height: getProportionateScreenHeight(100),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                              child: SvgPicture.asset(
                                'assets/Images/Logo.svg',
                                width: 280,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                AnimatedSmoothIndicator(
                  activeIndex: activeIndex,  // PageController
                  count: slider.length,
                  effect:  ColorTransitionEffect(
                      activeDotColor: orange,
                      dotWidth: 10,
                      dotHeight: 10
                  ),  // your preferred effect
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.0),
                    border: Border(bottom: BorderSide(color: grey, width: 0.8)),
                  ),
                  child: TabBar(
                    indicatorColor: orange,
                    indicatorWeight: 1.5,
                    labelColor: orange,
                    labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 12),
                    unselectedLabelColor: grey,
                    controller: _controller,
                    onTap: (value){
                      calculateBusinessesWithinRange();
                    },
                    tabs: const [
                      Tab(text: "Shop"),
                      Tab(text: "Services")
                    ],
                  ),
                ),
                Expanded(
                    child: Stack(
                      children: [
                        AbsorbPointer(
                            absorbing: processing,
                            child: Opacity(
                                opacity: !processing ? 1.0 : 0.3,
                                child: TabBarView(
                                    controller: _controller,
                                    children: _screens))),
                        processing ? Loader(color: orange) : SizedBox(width: 0.0, height: 0.0),

                      ],
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
class InfoComponents{
  String? image;

  InfoComponents({
    this.image,
  });
}