import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tajammul_customer_app/Components/CustomButton.dart';
import 'package:tajammul_customer_app/Components/CustomDialog.dart';
import 'package:tajammul_customer_app/Components/CustomTextField.dart';
import 'package:tajammul_customer_app/Screens/SignIn/Components/forgot_password.dart';
import 'package:tajammul_customer_app/Services/loginUserCredentials.dart';
import '../../../../Components/Loader.dart';
import '../../../../Services/ApiCalls.dart';
import '../../../../SizeConfig.dart';
import '../../../../colors.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {

  final _formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordAgainController = TextEditingController();
  bool processing=false;
  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _newPasswordAgainVisible = false;
  LoginUserCredentials credentials = LoginUserCredentials();

  //forgot password
  void changePassword() async {
    setState(() {
      processing=true;
    });

    Map<String,String?>? result = await ApiCalls.changePassword(_newPasswordController.text,oldPasswordController.text);
    if((result?.containsKey("success"))!) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
                onWillPop: () async => false,
                child: CustomDialog(
                  message: "The password has been set.",
                  firstLabelButton: "OK",
                  onFirstPressed: () async {
                    Navigator.pop(context, true);
                    Navigator.pop(context, true);
                  },
                  imagePath: 'assets/Images/update.svg',
                ));
          });
    }
    else if (result?["error"] == "Session Expired") {
      await credentials.getCurrentUser();
      showDialog(context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
                onWillPop: () async => false,
                child: CustomDialog(message: "The Session Has Been Expired!",
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
                )
            );
          }).then((value) async{
        changePassword();
      });
    }
    else {
      Fluttertoast.showToast(
          msg: (result?["error"])!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: orange,
          textColor: Colors.white,
          fontSize: 15.0
      );
      setState(() {
        processing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Opacity(
            opacity:!processing ? 1.0 : 0.3,
            child: Form(
              key: _formKey,
              child: Card(
                elevation: 10.0,
                shadowColor: Color(0xFF93A7BE).withOpacity(0.3),
                margin: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(10.0),horizontal: getProportionateScreenWidth(10)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      gradient: RadialGradient(

                        center: Alignment(-0.6, -0.7),
                        colors: const [
                          Color(0xFFEFEFEF),
                          Color(0xFFFFFFFF),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10),vertical: getProportionateScreenHeight(40.0)),
                      child: Column(
                        children: [
                          SvgPicture.asset('assets/Images/changePassword.svg'),
                          SizedBox(height: getProportionateScreenHeight(40),),
                          CustomTextField(
                            controller: oldPasswordController,
                            label: 'Enter Old Password',
                            color: lightGrey,
                            enabled: true,
                            isOptional: true,
                            passwordVisible: _oldPasswordVisible,
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
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _oldPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color:  const Color(0xFFE8E8E8).withOpacity(0.9),
                              ),
                              onPressed: () {
                                setState(() {
                                  _oldPasswordVisible = !_oldPasswordVisible;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(30),),
                          CustomTextField(
                            label: "Password",
                            controller: _newPasswordController,
                            passwordVisible: _newPasswordVisible,
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
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _newPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color(0xFFE8E8E8)
                                    .withOpacity(0.9),
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _newPasswordVisible = !_newPasswordVisible;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(30),),
                          CustomTextField(
                            label: "Re-Enter Password",
                            controller: _newPasswordAgainController,
                            passwordVisible: _newPasswordAgainVisible,
                            color: lightGrey,
                            formFieldValidator: (value) {
                              String? result;
                              if (_newPasswordController.text != value) {
                                result = "Password don't match";
                              }
                              return result;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _newPasswordAgainVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color(0xFFE8E8E8)
                                    .withOpacity(0.9),
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _newPasswordAgainVisible = !_newPasswordAgainVisible;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(30),),

                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                                },
                                style: TextButton.styleFrom(padding: EdgeInsets.zero), child: Text('Forgot Password',style: GoogleFonts.poppins(color: blue,fontWeight: FontWeight.w500),)),
                          ),
                          SizedBox(height: getProportionateScreenHeight(10.0),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: getProportionateScreenWidth(130),
                                child: CustomButton(
                                  label: 'Cancel',
                                  onPressed: ()=>Navigator.pop(context),
                                  color: orange,
                                ),
                              ),
                              SizedBox(width: getProportionateScreenWidth(20),),
                              SizedBox(
                                width: getProportionateScreenWidth(130),
                                child: CustomButton(
                                  label: 'Update',
                                  onPressed: (){
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      changePassword();
                                    }
                                    FocusScope.of(context).unfocus();
                                  },
                                  color: green,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        processing ? const Loader(color:orange) :Container()
      ],
    );
  }
}