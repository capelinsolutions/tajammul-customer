import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../Components/CustomButton.dart';
import '../../SizeConfig.dart';
import '../../colors.dart';
import '../SignIn/sign_in_main.dart';

class Body extends StatefulWidget{
  const Body({Key? key}) : super(key: key);


  @override
  _BodyState createState() => _BodyState();
}
class _BodyState extends State<Body>{

  List<InfoComponents> slider = [
    InfoComponents(image: "assets/Images/Info1.svg", title:"Discover"),
    InfoComponents(image: "assets/Images/Info2.svg", title:"Make the Payment "),
    InfoComponents(image: "assets/Images/Info3.svg", title:"Enjoy your shopping"),
     ];
  int activeIndex=0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
                children: [

                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 30),
                  child:Align(
                    alignment: Alignment.topRight,
                  child:(activeIndex!=2)
                      ?InkWell(
                    radius: 50.0,
                    onTap: () async{
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      preferences.setString("Info","Already Run");
                      Navigator.pushReplacementNamed(
                        context,
                        SignInScreen.routeName,
                      );
                    },
                      child:Text("Skip",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.normal
                        )
                      )
                  )
                      :Container(
                   height: getProportionateScreenHeight(22.0),
                  )
                  ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45.0,vertical: 25.0),
                      child: SvgPicture.asset("assets/Images/Logo.svg")),

                  SizedBox(height: getProportionateScreenHeight(40.0),),

                  CarouselSlider.builder(
                    itemCount: slider.length,
                    options: CarouselOptions(
                      pauseAutoPlayInFiniteScroll: false,
                      height: getProportionateScreenHeight(350.0),
                      scrollDirection: Axis.horizontal,
                      reverse: false,
                      enableInfiniteScroll: false,
                      viewportFraction: 1.0 ,
                      onPageChanged: (index,reason){
                      setState(() {
                       activeIndex=index;
                       print(slider[index].title);
                     });
                      }
                    ),
                    itemBuilder: (context,index,realIndex){
                          return Column(
                            children:[
                              ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: SvgPicture.asset(slider[index].image!,fit: BoxFit.fill,
                                  width:getProportionateScreenWidth(328.0),
                                height: getProportionateScreenHeight(244.03),
                              ),
                            ),

                            SizedBox(height: getProportionateScreenHeight(20.0),),

                            Text(slider[index].title!,
                            style: GoogleFonts.poppins(
                              color: blueGrey,
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                            ),)
                      ]
                          );
                        },
                  ),

                  SizedBox(height: 20,),

                  AnimatedSmoothIndicator(
                      activeIndex: activeIndex,  // PageController
                      count:  slider.length,
                      effect:  ColorTransitionEffect(
                        activeDotColor: orange,
                        dotWidth: 10,
                        dotHeight: 10
                      ),  // your preferred effect
                  ),

                  SizedBox(height: 20,),
                  (activeIndex==slider.length-1)
                  ?SizedBox(
                    height: getProportionateScreenHeight(50.0),
                    width: getProportionateScreenWidth(150.0),
                    child: CustomButton(
                        label: "GET STARTED",
                        color: orange,
                        onPressed: () async {
                          SharedPreferences preferences = await SharedPreferences.getInstance();
                          preferences.setString("Info","Already Run");
                          Navigator.pushReplacementNamed(
                            context,

                            SignInScreen.routeName,
                          );
                        }
                    ),
                  )
                      :Container()
                ]
             ),
      ),
    );
  }
}

class InfoComponents{
  String? image;
  String? title;

  InfoComponents({
   this.image,
   this.title,
});
}