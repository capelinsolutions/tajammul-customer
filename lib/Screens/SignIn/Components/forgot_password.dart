import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Components/CustomButton.dart';
import '../../../Components/CustomDialog.dart';
import '../../../Components/CustomTextField.dart';
import '../../../Components/Loader.dart';
import '../../../Services/ApiCalls.dart';
import '../../../Services/loginUserCredentials.dart';
import '../../../SizeConfig.dart';
import '../../../colors.dart';
import '../../Signup/Components/OTP.dart';
class ForgotPassword extends StatefulWidget{
  const ForgotPassword({Key? key}) : super(key: key);


  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}
class _ForgotPasswordState extends State<ForgotPassword> with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  LoginUserCredentials credentials = LoginUserCredentials();
  bool processing = false;
  AnimationController? _controller;
  Animation<Offset>? _offset;
  String _snackMessage = "";

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _offset =
        Tween<Offset>(begin: Offset(0.0, -2.0), end: Offset(0.0, 0.0)).animate(
            _controller!);
    super.initState();
  }

  //get user phoneNumber
  void getUserPhoneNumber() async {
    setState(() {
      processing = true;
    });
    Map<String, String>? result =
    await ApiCalls.getPhoneNumber(_usernameController.text);
    if (result?["error"] == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          OTP(from: "Forgot Password",
              phoneNumber: result?["success"],
              username: _usernameController.text),),);
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
        getUserPhoneNumber();
      });
    } else {
      displaySnackMessage((result?["error"])!);
    }
    setState(() {
      processing = false;
    });
  }


//print snack message
  displaySnackMessage(String message) {
    try {
      setState(() {
        _snackMessage = message;
      });
      _controller?.forward();
      Future.delayed(Duration(seconds: 3), () {
        _controller?.reverse();
      });
    }
    catch (e) {
      log(e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: Stack(
                children: [
                  Opacity(
                      opacity: !processing ? 1.0 : 0.3,
                      child: Form(
                        key: formKey,
                        child: SizedBox(
                          height: double.infinity,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: getProportionateScreenHeight(
                                    50.0),),
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: getProportionateScreenWidth(
                                          40.0),),
                                    child: SvgPicture.asset(
                                        "assets/Images/Logo.svg")),

                                SizedBox(height: getProportionateScreenHeight(
                                    30)),

                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: getProportionateScreenWidth(
                                          10.0)),
                                  child: Text(
                                    "Tajammul is an e-commerce solution providing online grocery and services",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: blueGrey,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                SizedBox(height: getProportionateScreenHeight(
                                    10)),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: getProportionateScreenWidth(
                                          16.0)),
                                  child: Stack(
                                    children: [
                                      Card(
                                        elevation: 20.0,
                                        shadowColor: Color(0xFF93A7BE)
                                            .withOpacity(0.3),
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2.0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0),
                                                ),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: const[
                                                    Color(0xFFF5F5F5),
                                                    Color(0xFFFFFFFF),
                                                  ],
                                                )
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: getProportionateScreenWidth(
                                                      20.0)),
                                              child: Column(
                                                children: [
                                                  Text("Forgot Password",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 18,
                                                        color: blueGrey,
                                                        fontWeight: FontWeight
                                                            .w500),
                                                  ),
                                                  SizedBox(
                                                      height: getProportionateScreenHeight(
                                                          10)),
                                                  ListTile(
                                                    title: Text(
                                                      "For resetting the password please provide username",
                                                      textAlign: TextAlign
                                                          .center,
                                                      style: GoogleFonts
                                                          .poppins(
                                                          fontSize: 14,
                                                          color: blueGrey,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: getProportionateScreenHeight(
                                                          20)),
                                                  ListTile(
                                                    title: CustomTextField(
                                                      label: "Username/Email",
                                                      controller: _usernameController,
                                                      color: lightGrey,
                                                      keyboardType: TextInputType
                                                          .text,
                                                      onChanged: (value) {
                                                        setState(() {

                                                        });
                                                      },
                                                      formFieldValidator: (
                                                          value) {
                                                        String? result;
                                                        if (value.isEmpty) {
                                                          result =
                                                          "Required Field";
                                                        }
                                                        return result;
                                                      },
                                                    ),
                                                  ),


                                                  SizedBox(
                                                    height: getProportionateScreenHeight(
                                                        20.0),),
                                                  ListTile(
                                                    title: SizedBox(
                                                      height: getProportionateScreenHeight(
                                                          50.0),
                                                      width: double.infinity,
                                                      child: CustomButton(
                                                          label: "Continue",
                                                          color: orange,
                                                          enabled: _usernameController
                                                              .text.isNotEmpty,
                                                          onPressed: () {
                                                            if (formKey
                                                                .currentState!
                                                                .validate()) {
                                                              formKey
                                                                  .currentState!
                                                                  .save();
                                                              getUserPhoneNumber();
                                                            }
                                                          }
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      )
                  ),
                  processing ? Loader(color: orange) : Container(),
                  Align(
                    alignment: Alignment.topCenter,
                    child: SlideTransition(
                      position: _offset!,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: getProportionateScreenHeight(10.0)),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            color: red,
                            borderRadius: BorderRadius.all(
                                Radius.circular(20.0))
                        ),
                        child: Text(_snackMessage,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ]
            )
        )
    );
  }
}