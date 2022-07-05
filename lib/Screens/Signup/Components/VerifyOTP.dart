import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import '../../../Components/CustomButton.dart';
import '../../../Components/Loader.dart';
import '../../../Providers/OTPExpiredProvider.dart';
import '../../../Services/ApiCalls.dart';
import '../../../SizeConfig.dart';
import '../../../colors.dart';
import '../../SignIn/Components/new_password.dart';
import '../../SignIn/sign_in_main.dart';
class VerifyOTP extends StatefulWidget{
  final String? otp;
  final String? phoneNumber;
  final String from;
  final String? username;
  final String? verificationId;
  final Map<String,String>? signUpInfo;
  final VoidCallback? back;
  const VerifyOTP({Key? key, this.otp, this.verificationId, this.phoneNumber, this.signUpInfo, required this.from, this.username, this.back}) : super(key: key);


  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}
class _VerifyOTPState extends State<VerifyOTP> {

  final TextEditingController otpController =  TextEditingController();
  String? inputOTP;
  late FocusNode? _pinPutFocusNode ;
  final formKey = GlobalKey<FormState>();
  bool processing=false;
  String? verificationId;
  CountdownTimerController? controller;
  int? endTime;
  @override
  void initState() {
    // TODO: implement initState

    if(widget.otp !=null) {
      inputOTP = widget.otp;
      otpController.text = inputOTP!;
    }
    verificationId = widget.verificationId;
    endTime = DateTime.now().millisecondsSinceEpoch + 1005 * 60;
    controller = CountdownTimerController(endTime: endTime!);
    Future.delayed(Duration(minutes: 1), () {
      if(mounted) {
        Provider.of<OTPExpiredProvider>(context, listen: false).setExpiry(true);
      }
    });
    _pinPutFocusNode= FocusNode();
    super.initState();
  }


  //get otp from firebase
  void getOTP() async {
    setState(() {
      processing=true;
      inputOTP=null;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber!,
        verificationCompleted: (PhoneAuthCredential credential) {
          setState(() {
            inputOTP=credential.smsCode;
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            processing=false;
          });
          String message = e.toString();
          Fluttertoast.showToast(
              msg:message.substring(message.indexOf('/')+1,message.indexOf("]")),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: orange,
              textColor: Colors.white,
              fontSize: 11.0
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          Future.delayed(Duration(seconds: 08),(){
            Provider.of<OTPExpiredProvider>(context,listen: false).setExpiry(false);
            setState(() {
              this.verificationId=verificationId;
              otpController.text = inputOTP ?? "";
              processing=false;
              endTime = DateTime.now().millisecondsSinceEpoch + 1002 * 60;
              controller = CountdownTimerController(endTime: endTime!);
              _pinPutFocusNode?.unfocus();
            });

            Future.delayed(Duration(minutes: 1), () {
              if(mounted) {
                Provider.of<OTPExpiredProvider>(context, listen: false).setExpiry(true);
              }
            });
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log(verificationId);
        },
        timeout: Duration(seconds: 10)
    );

  }

//create User
  void createUser() async {
    setState(() {
      processing=true;
    });
    var userInfo= widget.signUpInfo!;

    String result = await ApiCalls.createUser(userInfo["username"]!,userInfo["email"]!,userInfo["password"]!,userInfo["fName"]!,userInfo["lName"]!,widget.phoneNumber!);
    if(result!="Created") {
      Fluttertoast.showToast(
          msg: result,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: orange,
          textColor: Colors.white,
          fontSize: 15.0
      );
    }
    else{
      //otp expired when account has been created
      Provider.of<OTPExpiredProvider>(context, listen: false).setExpiry(true);
      Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (route) => false);
    }
    setState(() {
      processing = false;
    });
  }

  @override
  void dispose() {
    _pinPutFocusNode?.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    BoxDecoration decoration=BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Color(0xFFFFFFFF),
        border: Border.all(color: lightGrey,width: 1)
    );
    return Consumer<OTPExpiredProvider>(
        builder: (context, value, child)
        {
          return WillPopScope(
            onWillPop: ()  async {
              if(!Platform.isIOS){
                widget.back!();
              }
              return true;
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: backgroundColor,
              body: GestureDetector(
                onTap: () {
                  _pinPutFocusNode?.unfocus();
                },
                child: SafeArea(
                    child: Stack(
                        children: [
                          AbsorbPointer(
                            absorbing: processing,
                            child: Opacity(
                              opacity: !processing ? 1.0 : 0.3,
                              child: Form(
                                key: formKey,
                                child: SizedBox(
                                  height: double.infinity,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: getProportionateScreenHeight(80.0),),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: getProportionateScreenWidth(
                                                  40.0),),
                                            child: SvgPicture.asset(
                                                "assets/Images/Logo.svg")),

                                        SizedBox(
                                            height: getProportionateScreenHeight(30)),

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
                                        SizedBox(
                                            height: getProportionateScreenHeight(10)),
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
                                                          Text(
                                                            "Verify Your Mobile Number",
                                                            textAlign: TextAlign.center,
                                                            style: GoogleFonts.poppins(
                                                                fontSize: 18,
                                                                color: blueGrey,
                                                                fontWeight: FontWeight
                                                                    .w500),
                                                          ),

                                                          SizedBox(
                                                              height: getProportionateScreenHeight(
                                                                  20)),

                                                          ListTile(
                                                            title: Text(
                                                              "${(widget.otp?.length ??
                                                                  6)} Digit pin has been sent to your phone number. enter it below to continue",
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
                                                              title: PinPut(
                                                                  fieldsCount: (widget.otp?.length ??
                                                                      6),
                                                                  controller: otpController,
                                                                  enabled: true,
                                                                  focusNode: _pinPutFocusNode,
                                                                  animationDuration: Duration(
                                                                      milliseconds: 100),
                                                                  keyboardType: TextInputType
                                                                      .number,
                                                                  followingFieldDecoration: decoration,
                                                                  disabledDecoration: decoration,
                                                                  selectedFieldDecoration: decoration,
                                                                  submittedFieldDecoration: decoration,
                                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                  autofocus: false,
                                                                  checkClipboard: false,
                                                                  enableInteractiveSelection: false,
                                                                  withCursor: false,
                                                                  fieldsAlignment: MainAxisAlignment
                                                                      .spaceBetween,
                                                                  onChanged: (value) {
                                                                    setState(() {
                                                                      inputOTP = value;
                                                                    });
                                                                  }
                                                              )
                                                          ),


                                                          SizedBox(
                                                            height: getProportionateScreenHeight(
                                                                10.0),),
                                                          ListTile(
                                                            title: SizedBox(
                                                              height: getProportionateScreenHeight(
                                                                  50.0),
                                                              width: double.infinity,
                                                              child: CustomButton(
                                                                  label: "Verify",
                                                                  enabled: ((inputOTP != null ? ((inputOTP?.length)! < (widget.otp?.length ?? 6) ? false : true) : false) && otpController.text.isNotEmpty),
                                                                  color: orange,
                                                                  onPressed: () async {
                                                                    if (!value.isExpired) {
                                                                      try {
                                                                        PhoneAuthCredential credential = PhoneAuthProvider.credential(
                                                                            verificationId: verificationId!,
                                                                            smsCode: otpController.text);
                                                                        await FirebaseAuth.instance.signInWithCredential(credential);
                                                                        if (widget.from == "SignUp") {
                                                                          createUser();
                                                                        }
                                                                        else {

                                                                          //otp expired when matched
                                                                          Provider.of<OTPExpiredProvider>(context, listen: false).setExpiry(true);


                                                                          Navigator.pushReplacement(context, MaterialPageRoute(
                                                                              builder: (
                                                                                  context) =>
                                                                                  NewPassword(username: widget.username,)));
                                                                        }
                                                                      }
                                                                      catch (e) {
                                                                        log(e.toString());
                                                                        String message = e.toString();
                                                                        Fluttertoast.showToast(
                                                                            msg: message.substring(
                                                                                message.indexOf(
                                                                                    '/') +
                                                                                    1,
                                                                                message
                                                                                    .indexOf(
                                                                                    "]")),
                                                                            toastLength: Toast
                                                                                .LENGTH_SHORT,
                                                                            gravity: ToastGravity
                                                                                .BOTTOM,
                                                                            timeInSecForIosWeb: 1,
                                                                            backgroundColor: orange,
                                                                            textColor: Colors
                                                                                .white,
                                                                            fontSize: 15.0
                                                                        );
                                                                        setState((){
                                                                          otpController.text="";
                                                                          inputOTP=null;
                                                                        });
                                                                        _pinPutFocusNode?.unfocus();
                                                                      }
                                                                    }
                                                                    else {
                                                                      Fluttertoast
                                                                          .showToast(
                                                                          msg: "The SMS code has expired. Please re-send the verification code to try again.",
                                                                          toastLength: Toast.LENGTH_SHORT,
                                                                          gravity: ToastGravity.BOTTOM,
                                                                          timeInSecForIosWeb: 1,
                                                                          backgroundColor: orange,
                                                                          textColor: Colors
                                                                              .white,
                                                                          fontSize: 15.0
                                                                      );
                                                                      setState((){
                                                                        otpController.text="";
                                                                        inputOTP=null;
                                                                      });
                                                                      _pinPutFocusNode?.unfocus();
                                                                    }
                                                                  }
                                                              ),
                                                            ),
                                                          ),

                                                          SizedBox(
                                                            height: getProportionateScreenHeight(
                                                                20.0),),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .only(left: 30,
                                                                right: 30),
                                                            child: Row (
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children:[
                                                                  AbsorbPointer(
                                                                    absorbing: !value.isExpired,
                                                                    child: Opacity(
                                                                      opacity: value.isExpired
                                                                          ? 1.0
                                                                          : 0.5,
                                                                      child:  RichText(
                                                                        text: TextSpan(
                                                                          children: <
                                                                              TextSpan>[
                                                                            TextSpan(
                                                                              text: "Didn’t receive it?  ",
                                                                              style: GoogleFonts
                                                                                  .poppins(
                                                                                  color: dark_grey,
                                                                                  fontWeight: FontWeight
                                                                                      .normal,
                                                                                  fontSize: 15),
                                                                            ),

                                                                            TextSpan(
                                                                                text: "Resend ",

                                                                                style: GoogleFonts
                                                                                    .poppins(
                                                                                    color: blue,
                                                                                    fontWeight: FontWeight
                                                                                        .bold,
                                                                                    fontSize: 15,
                                                                                    fontStyle: FontStyle
                                                                                        .italic),
                                                                                recognizer: TapGestureRecognizer()
                                                                                  ..onTap = () {
                                                                                    getOTP();
                                                                                  }),
                                                                          ],

                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  CountdownTimer(
                                                                    controller: controller,
                                                                    widgetBuilder: (BuildContext context, currentRemainingTime){
                                                                      return Text(
                                                                        "${(currentRemainingTime?.min?.toString().length ==1 ? "0"+currentRemainingTime!.min.toString() : currentRemainingTime?.min) ?? "00"} : ${(currentRemainingTime?.sec?.toString().length==1 ? "0"+currentRemainingTime!.sec.toString() : currentRemainingTime?.sec) ?? "00"}",
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                            fontSize: 15,
                                                                            color: orange,
                                                                            fontWeight: FontWeight.bold),
                                                                      );
                                                                    },
                                                                    endTime: endTime,
                                                                  ),
                                                                ]
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
                          ),
                          processing ? Loader(color: orange) : Container()
                        ]
                    )
                ),
              ),
            ),
          );
        }
    );
  }
}