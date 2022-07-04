import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:tajammul_customer_app/Models/HiveProduct.dart';
import 'package:tajammul_customer_app/Tabs/tabs_main.dart';
import '../../Components/CustomButton.dart';
import '../../Components/CustomTextField.dart';
import '../../Components/Loader.dart';
import '../../Services/ApiCalls.dart';
import '../../Services/PushNotification.dart';
import '../../Services/loginUserCredentials.dart';
import '../../SizeConfig.dart';
import '../../colors.dart';
import '../Signup/signup_main.dart';
import 'Components/forgot_password.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  LoginUserCredentials credentials = LoginUserCredentials();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool processing = false;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  //sign in user
  void signInUser() async {
    setState(() {
      processing = true;
    });
    String result = await ApiCalls.signInUser(_usernameController.text.trim(), _userPasswordController.text);
    if (result != "Successfully Login") {
      Fluttertoast.showToast(
          msg: result,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: orange,
          textColor: Colors.white,
          fontSize: 15.0);
      setState(() {
        processing = false;
      });
    } else {
      PushNotificationService service = PushNotificationService(FirebaseMessaging.instance);
      bool result = await service.initialise();
      if(result){
        Box box;
        box = await Hive.openBox<HiveProduct>('cart');
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(
            context,
            TabsScreen.routeName,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          AbsorbPointer(
            absorbing: processing,
            child: Opacity(
              opacity: !processing ? 1.0 : 0.3,
              child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Form(
                  key: formKey,
                  child: SizedBox(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: getProportionateScreenHeight(50.0),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(40.0),
                            ),
                            child: SvgPicture.asset("assets/Images/Logo.svg"),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(50.0),
                            ),
                            child: Text(
                              "Sign in to your account and get access to every store",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: blueGrey,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(16.0),
                            ),
                            child: Stack(
                              children: [
                                Card(
                                  elevation: 20.0,
                                  shadowColor:
                                      const Color(0xFF93A7BE).withOpacity(0.3),
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                        gradient: RadialGradient(
                                          radius: 1.5,
                                          center: Alignment(-0.6, -0.6),
                                          colors: [
                                            Color(0xFFEFEFEF),
                                            Color(0xFFFFFFFF),
                                          ],
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical:
                                              getProportionateScreenWidth(20.0),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Sign in",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 18,
                                                  color: blueGrey,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      20),
                                            ),
                                            ListTile(
                                              title: CustomTextField(
                                                label: "Username/Email",
                                                controller: _usernameController,
                                                color: lightGrey,
                                                enabled: true,
                                                keyboardType:
                                                    TextInputType.text,
                                                formFieldValidator: (value) {
                                                  String? result;
                                                  if (value.isEmpty) {
                                                    result = "Required Field";
                                                  }
                                                  return result;
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            ListTile(
                                              title: CustomTextField(
                                                label: "Password",
                                                controller:
                                                    _userPasswordController,
                                                passwordVisible:
                                                    _passwordVisible,
                                                color: lightGrey,
                                                enabled: true,
                                                formFieldValidator: (value) {
                                                  String? result;
                                                  if (value.isEmpty) {
                                                    result = "Required Field";
                                                  } else if (value.length >
                                                      16) {
                                                    result =
                                                        "Password should be less than 16 characters long";
                                                  } else if (value.length < 6) {
                                                    result =
                                                        "Password must be at least 6 characters long";
                                                  }
                                                  return result;
                                                },
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    // Based on passwordVisible state choose the icon
                                                    _passwordVisible
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color:
                                                        const Color(0xFFE8E8E8)
                                                            .withOpacity(0.9),
                                                  ),
                                                  onPressed: () {
                                                    // Update the state i.e. toogle the state of passwordVisible variable
                                                    setState(
                                                      () {
                                                        _passwordVisible =
                                                            !_passwordVisible;
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      5.0),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ForgotPassword(),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  right:
                                                      getProportionateScreenHeight(
                                                          18.0),
                                                ),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    "Forgot Password",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color: blue,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      20.0),
                                            ),
                                            ListTile(
                                              title: SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        45.0),
                                                width: double.infinity,
                                                child: CustomButton(
                                                  label: "Sign in",
                                                  color: orange,
                                                  onPressed: () {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      formKey.currentState!
                                                          .save();
                                                      signInUser();
                                                    }
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      20.0),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 30, right: 30),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          "Don't have an account? ",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: dark_grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 15),
                                                    ),
                                                    TextSpan(
                                                      text: "Sign up ",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  SignUpScreen
                                                                      .routeName);
                                                            },
                                                    ),
                                                  ],
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
                ),
              ),
            ),
          ),
          processing ? const Loader(color: orange) : Container()
        ],
      ),
    );
  }
}
