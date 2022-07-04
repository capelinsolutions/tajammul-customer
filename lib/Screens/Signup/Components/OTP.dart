import 'dart:io';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import '../../../Components/CustomButton.dart';
import '../../../Components/CustomMaterialPageRoute.dart';
import '../../../Components/Loader.dart';
import '../../../Components/PhoneNumberField.dart';
import '../../../Models/Debouncer.dart';
import '../../../Providers/OTPExpiredProvider.dart';
import '../../../SizeConfig.dart';
import '../../../colors.dart';
import 'VerifyOTP.dart';

class OTP extends StatefulWidget {
  final Map<String, String>? signUpInfo;
  final String from;
  final String? phoneNumber;
  final String? username;

  const OTP(
      {Key? key,
        this.signUpInfo,
        required this.from,
        this.phoneNumber,
        this.username})
      : super(key: key);

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final TextEditingController phoneNumberController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  PhoneNumber number = PhoneNumber(isoCode: "PK");
  String? verificationId;
  String? countryCode;
  String? error;
  String? otpCode;
  int? numberLength;
  bool processing = false;
  late FocusNode? _phoneNumberFocus;

  @override
  void initState() {
    // TODO: implement initState

    countryCode = number.isoCode;
    if (widget.from == "Forgot Password") {
      numberLength = widget.phoneNumber?.length;
    }
    super.initState();
    _phoneNumberFocus=FocusNode();
  }

  //get otp from firebase
  void getOTP() async {
    setState(() {
      processing = true;
    });
    String? mobile =
    await getPhoneNumber(phoneNumberController.text, countryCode!);
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: mobile!,
        verificationCompleted: (PhoneAuthCredential credential) {
          setState(() {
            otpCode = credential.smsCode;
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            processing = false;
          });
          log(e.toString());
          String message = e.toString();
          Fluttertoast.showToast(
              msg: message.substring(message.indexOf(']') + 2, message.length),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: orange,
              textColor: Colors.white,
              fontSize: 11.0);
        },
        codeSent: (String verificationId, int? resendToken) {
          Future.delayed(Duration(seconds: 6), () {
            if (widget.from == "SignUp") {
              if (Platform.isIOS) {
                Navigator.of(context).push(
                  CustomMaterialPageRoute(
                    builder: (_) => VerifyOTP(
                      verificationId: verificationId,
                      phoneNumber: mobile,
                      otp: otpCode,
                      signUpInfo: widget.signUpInfo!,
                      from: widget.from,
                    ),
                    back: () {
                      Provider.of<OTPExpiredProvider>(context, listen: false).setExpiry(true);
                    },
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerifyOTP(
                      verificationId: verificationId,
                      phoneNumber: mobile,
                      otp: otpCode,
                      signUpInfo: widget.signUpInfo!,
                      from: widget.from,
                      back: () {
                        Provider.of<OTPExpiredProvider>(context, listen: false).setExpiry(true);
                      },
                    ),
                  ),
                );
              }
            } else {
              if (Platform.isIOS) {
                Navigator.of(context).push(
                  CustomMaterialPageRoute(
                    builder: (_) => VerifyOTP(
                      verificationId: verificationId,
                      phoneNumber: mobile,
                      otp: otpCode,
                      from: widget.from,
                      username: widget.username,
                    ),
                    back: () {
                      Provider.of<OTPExpiredProvider>(context, listen: false).setExpiry(true);
                    },
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerifyOTP(
                      verificationId: verificationId,
                      phoneNumber: mobile,
                      otp: otpCode,
                      from: widget.from,
                      username: widget.username,
                      back: () {
                        Provider.of<OTPExpiredProvider>(context, listen: false).setExpiry(true);
                      },
                    ),
                  ),
                );
              }
            }
            Provider.of<OTPExpiredProvider>(context, listen: false).setExpiry(false);
            setState(() {
              processing = false;
            });
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log(verificationId);
        },
        timeout: Duration(seconds: 10));
  }

  checkError(bool value) async {
    String? mobile;
    if (widget.from == "Forgot Password") {
      try {
        mobile = await getPhoneNumber(phoneNumberController.text, countryCode!);
      } catch (e) {
        log(e.toString());
      }
      setState(() {
        if (phoneNumberController.text.isEmpty) {
          error = "Required Field";
        } else if (!value) {
          error = "Invalid phone number";
        } else if (mobile != widget.phoneNumber) {
          error = "Phone number Does not match with the provided number";
        } else {
          error = null;
        }
      });
    } else {
      try {
        mobile = await getPhoneNumber(phoneNumberController.text, countryCode!);
      } catch (e) {
        log(e.toString());
      }
      setState(() {
        if (phoneNumberController.text.isEmpty) {
          error = "Required Field";
        } else if (!value) {
          error = "Invalid phone number";
        } else {
          error = null;
        }
      });
    }
  }

  //for getting the actual number from the region
  Future<String?> getPhoneNumber(String phoneNumber, String countryCode) async {
    log(phoneNumber);
    try {
      PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(
          phoneNumber, countryCode);
      return number.phoneNumber;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  @override
  void dispose() {
    _phoneNumberFocus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OTPExpiredProvider>(builder: (context, value, child) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backgroundColor,
          body: GestureDetector(
            onTap: (){
              _phoneNumberFocus?.unfocus();
            },
            child: SafeArea(
                child: Stack(children: [
                  AbsorbPointer(
                    absorbing: processing,
                    child: Opacity(
                      opacity: !processing ? 1.0 : 0.3,
                      child: SizedBox(
                        height: double.infinity,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: getProportionateScreenHeight(80.0),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(40.0),
                                  ),
                                  child: SvgPicture.asset("assets/Images/Logo.svg")),
                              SizedBox(height: getProportionateScreenHeight(30)),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(10.0)),
                                child: Text(
                                  "Tajammul is an e-commerce solution providing online grocery and services",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: blueGrey,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              SizedBox(height: getProportionateScreenHeight(10)),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(16.0)),
                                child: Stack(
                                  children: [
                                    Card(
                                      elevation: 20.0,
                                      shadowColor: Color(0xFF93A7BE).withOpacity(0.3),
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
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: const [
                                                  Color(0xFFF5F5F5),
                                                  Color(0xFFFFFFFF),
                                                ],
                                              )),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: getProportionateScreenWidth(
                                                    20.0)),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Verify Your Mobile Number",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 18,
                                                      color: blueGrey,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                                SizedBox(
                                                    height:
                                                    getProportionateScreenHeight(
                                                        20)),
                                                widget.from == "SignUp"
                                                    ? ListTile(
                                                  title: Text(
                                                    "We will send you a code for the verification purpose.  No fees will apply. ",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color: blueGrey,
                                                        fontWeight:
                                                        FontWeight.normal),
                                                  ),
                                                )
                                                    : ListTile(
                                                  title: Text(
                                                    "Confirm the phone number that you provided  in registration: •••• •••••${widget.phoneNumber?.substring(numberLength! - 2, numberLength! - 1)}${widget.phoneNumber?.substring(numberLength! - 1, numberLength!)}",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color: blueGrey,
                                                        fontWeight:
                                                        FontWeight.normal),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                    getProportionateScreenHeight(
                                                        20)),
                                                ListTile(
                                                  title: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.all(
                                                          Radius.circular(8.0),
                                                        ),
                                                        border: Border.all(
                                                            color: error != null
                                                                ? orange
                                                                : lightGrey),
                                                        color: Color(0xFFFFFFFF)),
                                                    child: PhoneNumberField(
                                                      focusNode: _phoneNumberFocus,
                                                      initialValue: number,
                                                      controller:
                                                      phoneNumberController,
                                                      label: "Enter phone number",
                                                      color: blueGrey,
                                                      onChanged: (value) {
                                                        countryCode = value.isoCode;
                                                      },
                                                      isValidate: (value) {
                                                        setState(() {});
                                                          checkError(value);
                                                      },
                                                      formFieldValidator: (value) {
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: getProportionateScreenHeight(2.0),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                      getProportionateScreenWidth(
                                                          25.0),),
                                                  child: Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Visibility(
                                                      visible: error != null
                                                          ? true
                                                          : false,
                                                      child: Text(
                                                        error ?? "",
                                                        textAlign: TextAlign.center,
                                                        style: GoogleFonts.poppins(
                                                            fontSize: 11,
                                                            color: Colors.red,
                                                            fontWeight:
                                                            FontWeight.normal),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                  getProportionateScreenHeight(
                                                      10.0),
                                                ),
                                                ListTile(
                                                  title: SizedBox(
                                                    height:
                                                    getProportionateScreenHeight(
                                                        50.0),
                                                    width: double.infinity,
                                                    child: CustomButton(
                                                        label: "Generate OTP",
                                                        color: orange,
                                                        enabled: (error==null && value.isExpired && phoneNumberController.text.isNotEmpty),
                                                        onPressed: () async {
                                                          if (error == null) {
                                                            getOTP();
                                                          }
                                                        }),
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
                    ),
                  ),
                  processing ? Loader(color: orange) : Container()
                ])),
          ));
    });
  }
}