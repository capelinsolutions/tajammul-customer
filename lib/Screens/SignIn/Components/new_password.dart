import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../Components/CustomButton.dart';
import '../../../Components/CustomTextField.dart';
import '../../../Components/Loader.dart';
import '../../../Providers/OTPExpiredProvider.dart';
import '../../../Services/ApiCalls.dart';
import '../../../SizeConfig.dart';
import '../../../colors.dart';
import '../sign_in_main.dart';
class NewPassword extends StatefulWidget{
  final String? username;

  const NewPassword({Key? key, this.username}) : super(key: key);
  @override
  _NewPasswordState createState() => _NewPasswordState();
}
class _NewPasswordState extends State<NewPassword>{

  final TextEditingController _userPasswordController =  TextEditingController();
  final TextEditingController _userPasswordAgainController =  TextEditingController();
  bool _passwordVisible = false;
  bool _passwordAgainVisible = false;
  final formKey = GlobalKey<FormState>();
  bool processing=false;

  @override
  void initState() {
    // TODO: implement initState
    _passwordVisible = false;
    _passwordAgainVisible = false;
    super.initState();
  }


  //forgot password
  void forgotPassword() async {
    setState(() {
      processing=true;
    });

    String result = await ApiCalls.forgotPassword(_userPasswordController.text,widget.username!);
    if(result!="Password has been reset successfully") {
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
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: Stack(
              children: [
                Opacity(
                    opacity:!processing ? 1.0 : 0.3                                                                 ,
                    child: Form(
                      key: formKey,
                      child: SizedBox(
                        height: double.infinity,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: getProportionateScreenHeight(50.0),),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(40.0),),
                                  child: SvgPicture.asset("assets/Images/Logo.svg")),

                              SizedBox(height: getProportionateScreenHeight(30)),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10.0)),
                                child: Text("Tajammul is an e-commerce solution providing online grocery and services",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: blueGrey,
                                      fontWeight: FontWeight.normal),
                                ),
                              ) ,
                              SizedBox(height: getProportionateScreenHeight(10)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(16.0)),
                                child: Stack(
                                  children: [
                                    Card(
                                      elevation: 20.0,
                                      shadowColor: Color(0xFF93A7BE).withOpacity(0.3),
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child:Padding(
                                        padding: const EdgeInsets.only(top: 2.0),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                              gradient:LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors:const[
                                                  Color(0xFFF5F5F5),
                                                  Color(0xFFFFFFFF),
                                                ],
                                              )
                                          ),
                                          child:Padding(
                                            padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(20.0)),
                                            child: Column(
                                              children: [
                                                Text("Reset Password",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 18,
                                                      color: blueGrey,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                                ListTile(
                                                  title: Text("Choose a strong password.",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color: blueGrey,
                                                        fontWeight: FontWeight.normal),
                                                  ),
                                                ),
                                                SizedBox(height: getProportionateScreenHeight(20)),
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
                                                        result = "Invalid length (Min: 8, Max:20)";
                                                      }
                                                      return result;
                                                    },
                                                    onChanged: (value){
                                                      setState(() {
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
                                                  ),
                                                ),
                                                SizedBox(height: getProportionateScreenHeight(02),),
                                                ListTile(
                                                  title:CustomTextField(
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
                                                      setState(() {

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
                                                  ),
                                                ),
                                                SizedBox(height: getProportionateScreenHeight(20.0),),
                                                ListTile(
                                                  title: SizedBox(
                                                    height: getProportionateScreenHeight(50.0),
                                                    width: double.infinity,
                                                    child: CustomButton(
                                                        label: "reset",
                                                        color: orange,
                                                        enabled: formKey.currentState?.validate() ?? false,
                                                        onPressed: () {
                                                          if (formKey.currentState!.validate()) {
                                                            formKey.currentState!.save();
                                                            forgotPassword();
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
                processing ? Loader(color:orange) :Container()
              ]
          )

      ),
    );
  }
}