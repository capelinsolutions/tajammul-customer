import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tajammul_customer_app/Components/CustomButton.dart';
import 'package:tajammul_customer_app/Components/CustomTextField.dart';
import 'package:tajammul_customer_app/Components/Loader.dart';
import 'package:tajammul_customer_app/Screens/AddAddress/Components/PrivacyPolicy.dart';
import 'package:tajammul_customer_app/Services/ApiCalls.dart';
import 'package:tajammul_customer_app/colors.dart';
import '../../Components/CustomCheckBox.dart';
import '../../Models/Debouncer.dart';
import '../../SizeConfig.dart';
import 'Components/OTP.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  final TextEditingController _userPasswordAgainController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool _passwordVisible = false;
  bool _passwordAgainVisible = false;
  final formKey = GlobalKey<FormState>();
  String isUserUniqueText = "";
  String isEmailUniqueText = "";
  bool processing = false;
  final _debouncer = Debouncer(milliseconds : 500);
  bool accTermsAndConditions = false;
  @override
  void initState() {
    // TODO: implement initState
    _passwordVisible = false;
    _passwordAgainVisible = false;
    super.initState();
  }

  //check username is unique or not
  isUniqueUserCheck(String username) async {
    Map<String, String>? result = await ApiCalls.isUniqueUser(username);
    if (mounted) {
      setState(() {
        isUserUniqueText = (result?["result"])!;
      });
    }
  }


  //check email is unique or not
  isUniqueEmailCheck(String email) async {
    Map<String, String>? result = await ApiCalls.isUniqueEmail(email);
    if (mounted) {
      setState(() {
        isEmailUniqueText = (result?["result"])!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(children: [
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
                            height: getProportionateScreenHeight(50.0),
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
                                          gradient: RadialGradient(
                                            radius: 1.5,
                                            center: Alignment(-0.6, -0.6),
                                            colors: const [
                                              Color(0xFFEFEFEF),
                                              Color(0xFFFFFFFF),
                                            ],
                                          )),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                            getProportionateScreenWidth(20.0)),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Sign up",
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
                                            ListTile(
                                              title: CustomTextField(
                                                label: "First Name",
                                                controller: _firstNameController,
                                                color: lightGrey,
                                                keyboardType: TextInputType.name,
                                                formFieldValidator: (value) {
                                                  String? result;
                                                  if (value.isEmpty) {
                                                    result = "Required Field";
                                                  }
                                                  else if (!RegExp(r'^([a-zA-Z]+\s)*[a-zA-Z]*$').hasMatch(
                                                      value)) {
                                                    result = "Invalid Input";
                                                  }
                                                  else if (value.length > 25) {
                                                    result =
                                                    "Character limit exceeds";
                                                  }
                                                  return result;
                                                },
                                                onChanged: (value){
                                                  setState((){

                                                  });
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                getProportionateScreenHeight(
                                                    02)),
                                            ListTile(
                                              title: CustomTextField(
                                                label: "Last Name",
                                                controller: _lastNameController,
                                                color: lightGrey,
                                                keyboardType: TextInputType.text,
                                                formFieldValidator: (value) {
                                                  String? result;
                                                  if (value.isEmpty) {
                                                    result = "Required Field";
                                                  }
                                                  else if (!RegExp(r'^([a-zA-Z]+\s)*[a-zA-Z]*$').hasMatch(
                                                      value)) {
                                                    result = "Invalid Input";
                                                  }
                                                  else if (value.length > 25) {
                                                    result =
                                                    "Character limit exceeds";
                                                  }
                                                  return result;
                                                },
                                                onChanged: (value){
                                                  setState((){

                                                  });
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                getProportionateScreenHeight(
                                                    02)),
                                            ListTile(
                                                title: CustomTextField(
                                                  label: "Username",
                                                  controller: _username,
                                                  color: lightGrey,
                                                  keyboardType: TextInputType.text,
                                                  formFieldValidator: (value) {
                                                    String? result;
                                                    if (value.isEmpty) {
                                                      result = "Required Field";
                                                    }
                                                    else if (!RegExp(r"^[a-zA-Z0-9]([_-]?[a-zA-Z0-9]*)*$").hasMatch(value)) {
                                                      result = "Invalid Username";
                                                    }
                                                    else if (!RegExp(r"[a-zA-Z]").hasMatch(value)) {
                                                      result = "Should contain at least one alphabet";
                                                    }
                                                    else if (!RegExp(r"^.{5,20}$").hasMatch(value)) {
                                                      result = "Invalid length (Min:5, Max:20)";
                                                    }
                                                    else if (isUserUniqueText != "") {
                                                      result = isUserUniqueText;
                                                    }
                                                    return result;
                                                  },
                                                  onChanged: (value) {
                                                    if(value!="") {
                                                      _debouncer.run(()  {
                                                        isUniqueUserCheck(value.trim());
                                                      });
                                                    }
                                                  },
                                                )),
                                            SizedBox(
                                              height:
                                              getProportionateScreenHeight(02),
                                            ),
                                            ListTile(
                                              title: CustomTextField(
                                                label: "Email",
                                                controller: _email,
                                                color: lightGrey,
                                                keyboardType:
                                                TextInputType.emailAddress,
                                                formFieldValidator: (value) {
                                                  String? result;
                                                  if (value.isEmpty) {
                                                    result = "Required Field";
                                                  } else if (!RegExp(r"^([a-zA-Z0-9]+([\._-]?[a-zA-Z0-9]+)*@\w+([\.-]?\w+)*(\.\w{2,3})+)*$")
                                                      .hasMatch(value)) {
                                                    result = "Invalid Email";
                                                  }
                                                  if (isEmailUniqueText != "") {
                                                    result = isEmailUniqueText;
                                                  }
                                                  return result;
                                                },
                                                onChanged: (value) {
                                                  if(value!="") {
                                                    _debouncer.run(()  {
                                                      isUniqueEmailCheck(value.trim());
                                                    });
                                                  }
                                                },
                                              ),),
                                            SizedBox(
                                              height:
                                              getProportionateScreenHeight(02),
                                            ),
                                            ListTile(
                                                title: CustomTextField(
                                                  label: "Password",
                                                  controller: _userPasswordController,
                                                  passwordVisible: _passwordVisible,
                                                  color: lightGrey,
                                                  formFieldValidator: (value) {
                                                    String? result;
                                                    if (value.isEmpty) {
                                                      result = "Required Field";
                                                    }
                                                    else if (!RegExp(r"[a-zA-Z]|[0-9]").hasMatch(value)) {
                                                      result = "Should contain at least one alphabet or number";
                                                    }
                                                    else if (!RegExp(r"^.{8,20}$").hasMatch(value)) {
                                                      result = "Invalid length (Min:8, Max:20)";
                                                    }
                                                    return result;
                                                  },
                                                  onChanged: (value){
                                                    setState((){

                                                    });
                                                  },
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      // Based on passwordVisible state choose the icon
                                                      _passwordVisible
                                                          ? Icons.visibility
                                                          : Icons.visibility_off,
                                                      color: Color(0xFFE8E8E8)
                                                          .withOpacity(0.9),
                                                    ),
                                                    onPressed: () {
                                                      // Update the state i.e. toogle the state of passwordVisible variable
                                                      setState(() {
                                                        _passwordVisible =
                                                        !_passwordVisible;
                                                      });
                                                    },
                                                  ),
                                                )),
                                            SizedBox(
                                              height:
                                              getProportionateScreenHeight(02),
                                            ),
                                            ListTile(
                                                title: CustomTextField(
                                                  label: "Re-Enter Password",
                                                  controller:
                                                  _userPasswordAgainController,
                                                  passwordVisible:
                                                  _passwordAgainVisible,
                                                  color: lightGrey,
                                                  formFieldValidator: (value) {
                                                    String? result;
                                                    if (_userPasswordController.text != value) {
                                                      result = "Password don't match";
                                                    }
                                                    return result;
                                                  },
                                                  onChanged: (value){
                                                    setState((){

                                                    });
                                                  },
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      // Based on passwordVisible state choose the icon
                                                      _passwordAgainVisible
                                                          ? Icons.visibility
                                                          : Icons.visibility_off,
                                                      color: Color(0xFFE8E8E8)
                                                          .withOpacity(0.9),
                                                    ),
                                                    onPressed: () {
                                                      // Update the state i.e. toogle the state of passwordVisible variable
                                                      setState(() {
                                                        _passwordAgainVisible =
                                                        !_passwordAgainVisible;
                                                      });
                                                    },
                                                  ),
                                                )),

                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                              child: Row(
                                                  children:[
                                                    SizedBox(
                                                      width:getProportionateScreenWidth(40.0),
                                                      child: CustomCheckBox(
                                                        label: "",
                                                        value: accTermsAndConditions,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            accTermsAndConditions = value;
                                                          });
                                                        },
                                                        activeColor: blueGrey,
                                                        checkColor: Colors.white,
                                                      ),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text:
                                                            "Accept?  ",
                                                            style: GoogleFonts.poppins(
                                                                color: dark_grey,
                                                                fontWeight:
                                                                FontWeight.normal,
                                                                fontSize: 13),
                                                          ),
                                                          TextSpan(
                                                              text: "Terms and Conditions",
                                                              style: GoogleFonts.poppins(
                                                                  color: blue,
                                                                  fontWeight:
                                                                  FontWeight.bold,
                                                                  fontSize: 13,
                                                                  fontStyle:
                                                                  FontStyle.italic),
                                                              recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap = () {
                                                                  Navigator.pushNamed(
                                                                      context, PrivacyPolicy.routeName);
                                                                }),
                                                        ],
                                                      ),
                                                    ),
                                                  ]
                                              ),
                                            ),
                                            ListTile(
                                              title: SizedBox(
                                                height:
                                                getProportionateScreenHeight(
                                                    50.0),
                                                width: double.infinity,
                                                child: CustomButton(
                                                    label: "Create an Account",
                                                    color: orange,
                                                    enabled: accTermsAndConditions && (formKey.currentState?.validate())!,
                                                    onPressed: () async {
                                                      if (formKey.currentState!.validate()) {
                                                        formKey.currentState!.save();
                                                        Map<String, String> signUpUser = {
                                                          "username": _username.text,
                                                          "email": _email.text,
                                                          "password": _userPasswordController.text,
                                                          "fName": _firstNameController.text,
                                                          "lName": _lastNameController.text
                                                        };
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                OTP(signUpInfo: signUpUser, from: "SignUp"),),);
                                                      }
                                                    }),
                                              ),
                                            ),
                                            SizedBox(
                                              height: getProportionateScreenHeight(
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
                                                      "Already have an account? ",
                                                      style: GoogleFonts.poppins(
                                                          color: dark_grey,
                                                          fontWeight:
                                                          FontWeight.normal,
                                                          fontSize: 15),
                                                    ),
                                                    TextSpan(
                                                        text: "Sign in",
                                                        style: GoogleFonts.poppins(
                                                            color: blue,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 15,
                                                            fontStyle:
                                                            FontStyle.italic),
                                                        recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            Navigator.pop(
                                                                context);
                                                          }),
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
                )),
          ),
          processing ? Loader(color: orange) : Container()
        ]));
  }
}