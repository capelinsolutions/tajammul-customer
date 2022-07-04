import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tajammul_customer_app/Providers/userProvider.dart';

import '../../Components/CustomButton.dart';
import '../../Components/CustomDialog.dart';
import '../../Components/CustomTextField.dart';
import '../../Components/Loader.dart';
import '../../Models/CustomPopUpMenuItem.dart';
import '../../Models/users.dart';
import '../../Services/ApiCalls.dart';
import '../../Services/loginUserCredentials.dart';
import '../../SizeConfig.dart';
import '../../colors.dart';
import '../../main.dart';
import 'components/ChangePassword/change_password.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  LoginUserCredentials credentials = LoginUserCredentials();
  AnimationController? _controller;
  Animation<Offset>? _offset;
  Users? user;
  String _snackMessage = "";
  bool _isEnabled = false;
  bool _isSuccess = false;
  bool _processing = false;
  List<CustomPopUpMenuItem> items = [
    CustomPopUpMenuItem(
        iconPath: "assets/Icons/updateImageIcon.svg",
        label: "Update Photo",
        color: blueGrey)
  ];
  XFile? _image = XFile("");
  String? _deleteImage;
  MultipartFile? _multipartImage;
  String? _imagePath;

  @override
  void initState() {
    user = Provider.of<UserProvider>(context, listen: false).users;
    _imagePath = user?.imagePath;
    checkUser();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _offset = Tween<Offset>(begin: Offset(0.0, -2.0), end: Offset(0.0, 0.0))
        .animate(_controller!);
    if (_imagePath!=null && _imagePath != "") {
      items.add(CustomPopUpMenuItem(
          iconPath: "assets/Icons/delete_Icon.svg",
          label: "Remove Photo",
          color: orange));
    }
    super.initState();
  }

  //check which business user is login
  checkUser() async {

    _usernameController.text = user?.userName ?? "";
    _emailController.text = user?.email ?? "";
    _firstNameController.text = user?.name?.firstName ?? "";
    _lastNameController.text = user?.name?.lastName ?? "";
    _phoneNumberController.text = user?.phoneNumber ?? "";
  }

  //pick image from camera
  _imgFromCamera() async {
    XFile? image = (await ImagePicker().pickImage(
      imageQuality: 100,
      source: ImageSource.camera,
    ));
    if (image != null) {
      bool result = await convertToMultipartImages(image);
      if (result) {
        displaySnackMessage("Image size should not be greater than 5MB");
      } else {
        setState(() {
          _image = image;
          if(user?.imagePath != null && user?.imagePath != "" ) {
            _deleteImage = user?.imagePath;
          }
          if (items.length == 1) {
            items.add(CustomPopUpMenuItem(
                iconPath: "assets/Icons/delete_Icon.svg",
                label: "Remove Photo",
                color: orange));
          }
        });
      }
    }
    Navigator.pop(context);
  }

  //pick image from gallery
  _imgFromGallery() async {
    XFile? image = (await ImagePicker().pickImage(
      imageQuality: 100,
      source: ImageSource.gallery,
    ));
    if (image != null) {
      bool result = await convertToMultipartImages(image);
      if (result) {
        displaySnackMessage("Image size should not be greater than 5MB");
      } else {
        setState(() {
          _image = image;
          if(user?.imagePath != null && user?.imagePath != "" ) {
            _deleteImage = user?.imagePath;
          }
          if (items.length == 1) {
            items.add(CustomPopUpMenuItem(
                iconPath: "assets/Icons/delete_Icon.svg",
                label: "Remove Photo",
                color: orange));
          }
        });
      }
    }
    Navigator.pop(context);
  }

  //convert images into multipart
  Future<bool> convertToMultipartImages(XFile? image) async {

    Uint8List? byteData = File((image?.path)!).readAsBytesSync();
    MultipartFile multipartFile = MultipartFile.fromBytes(
      'shopBanner',
      byteData,
      filename: image?.path,
    );
    double sizeInMB = multipartFile.length / (1024 * 1024);
    if (sizeInMB > 6.0) {
      return true;
    }
    _multipartImage=multipartFile;
    return false;
  }

  getUserProfileUpdated() async {
    setState(() {
      _processing = true;
    });
    Map<String, String>? result = await ApiCalls.userUpdateProfile(
        context.read<UserProvider>().users.userId!,
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _phoneNumberController.text.trim(),
        _multipartImage,
        _deleteImage ?? "");
    if (result?["error"] == null) {
      Provider.of<UserProvider>(context, listen: false).setUserSettings(usersFromJson((result!["data"])!));
      setState((){
        _isEnabled = false;
      });
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
        getUserProfileUpdated();
      });
    } else {
      displaySnackMessage((result?["error"])!);
    }
    setState(() {
      _processing = false;
    });
  }

  //open camera bottom dialog
  showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        elevation: 20.0,
        barrierColor: Color(0xFF6F89B8).withOpacity(0.2),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Container(
              width: double.infinity,
              // /height: getProportionateScreenHeight(250.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                  gradient: RadialGradient(
                    radius: 2.2,
                    focal: Alignment(-0.3, -0.5),
                    colors: const [
                      Color(0xFFEFEFEF),
                      Color(0xFFFFFFFF),
                    ],
                  )),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                  height: getProportionateScreenHeight(10.0),
                ),
                SvgPicture.asset("assets/Images/Home Indicator.svg"),
                SizedBox(
                  height: getProportionateScreenHeight(10.0),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ListTile(
                          contentPadding: EdgeInsets.only(
                              left: getProportionateScreenWidth(10.0),
                              top: 0.0,
                              bottom: 0.0),
                          leading: Container(
                            width: getProportionateScreenWidth(50.0),
                            height: getProportionateScreenWidth(50.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: yellow, width: 3.0),
                            ),
                            child: Icon(Icons.camera_alt_rounded,
                                size: 30, color: iconColor),
                          ),
                          title: Text(
                            "Camera",
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: blueGrey,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () => _imgFromCamera()),
                      ListTile(
                        contentPadding: EdgeInsets.only(
                            left: getProportionateScreenWidth(10.0),
                            top: 0.0,
                            bottom: 0.0),
                        title: Divider(
                          color: Color(0xFF707070),
                          thickness: 0.3,
                        ),
                      ),
                      ListTile(
                          contentPadding: EdgeInsets.only(
                              left: getProportionateScreenWidth(10.0),
                              top: 0.0,
                              bottom: 0.0),
                          leading: Container(
                            width: getProportionateScreenWidth(50.0),
                            height: getProportionateScreenWidth(50.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: yellow, width: 3.0),
                            ),
                            child: Icon(Icons.image_rounded,
                                size: 30, color: iconColor),
                          ),
                          title: Text(
                            "Gallery",
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: blueGrey,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () => _imgFromGallery()),
                    ],
                  ),
                ),
              ]),
            ),
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    super.dispose();
  }

  //print snack message
  displaySnackMessage(String message) {
    try {
      if (mounted) {
        setState(() {
          _snackMessage = message;
          _controller?.forward();
          Future.delayed(Duration(seconds: 3), () {
            if(mounted) {
              _controller?.reverse();
            }
            _isSuccess = false;
          });
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, business, child) {
      return SafeArea(
        child: Stack(
          children: [
            AbsorbPointer(
              absorbing: _processing,
              child: Opacity(
                opacity: !_processing ? 1.0 : 0.3,
                child: Form(
                  key: _formKey,
                  child: SizedBox(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(16.0)),
                            child: Card(
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
                                        vertical:
                                        getProportionateScreenHeight(30.0)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment:Alignment.center,
                                          child: Container(
                                            height: getProportionateScreenHeight(100.0),
                                            width: getProportionateScreenWidth(100),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                gradient: RadialGradient(
                                                  radius: 1.0,
                                                  center: Alignment(-0.6, -0.7),
                                                  colors: const [
                                                    Color(0xFFEFEFEF),
                                                    Color(0xFFFFFFFF),
                                                  ],
                                                ),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: grey,
                                                      blurRadius: 9,
                                                      spreadRadius: 4,
                                                      offset: Offset(0, 6)),
                                                ]),
                                            child: Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(
                                                      getProportionateScreenWidth(1)),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(50),
                                                    child: Center(
                                                      child:(_image!=null && _image?.path != "")
                                                          ? Image.file(
                                                        File((_image?.path)!),
                                                        width: double.infinity,
                                                        fit: BoxFit.fill,
                                                      )
                                                          : (_imagePath!=null && _imagePath!="")
                                                          ? CachedNetworkImage(
                                                          width: double.infinity,
                                                          imageUrl:
                                                          "${env.config
                                                              ?.imageUrl}$_imagePath",
                                                        fit: BoxFit.fill,)
                                                          : Image.asset(
                                                        "assets/Images/background_pic_image",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  child: PopupMenuButton(
                                                    padding: const EdgeInsets.all(0.0),
                                                    offset: const Offset(-25, 25),
                                                    onSelected: (value) {
                                                      if (value == 0) {
                                                        showBottomSheet(context);
                                                      }
                                                      if (value == 1) {
                                                        setState(() {
                                                          if (_image?.path != "") {
                                                            _image=XFile("");
                                                            _deleteImage=null;
                                                            _multipartImage=null;
                                                            if(_imagePath != null && _imagePath != ""){
                                                              items.removeAt(1);
                                                            }
                                                          }
                                                          else {
                                                            _deleteImage=_imagePath;
                                                            _imagePath=null;
                                                            items.removeAt(1);
                                                          }

                                                        });
                                                      }
                                                    },
                                                    child: CircleAvatar(
                                                      radius: 15.0,
                                                      backgroundColor: blueGrey,
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: white,
                                                        size: 15.0,
                                                      ),
                                                    ),
                                                    itemBuilder: (context) =>
                                                        List.generate(
                                                            items.length,
                                                                (index) {
                                                              return PopupMenuItem(
                                                                padding: EdgeInsets.only(left: 10.0),

                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      width: 36.0,
                                                                      height: 36.0,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(50.0),
                                                                        border: Border.all(
                                                                            color: items[index].color!,
                                                                            width: 2.0),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: EdgeInsets.all(6.0),
                                                                        child: SvgPicture.asset(items[index].iconPath!,
                                                                          color: items[index].color,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                      getProportionateScreenWidth(
                                                                          10.0),
                                                                    ),
                                                                    Text(
                                                                      items[index]
                                                                          .label!,
                                                                      textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                          fontSize:
                                                                          14.0,
                                                                          color: black,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                    )
                                                                  ],
                                                                ),
                                                                value: index,
                                                              );
                                                            }),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: getProportionateScreenHeight(20.0),),
                                        Align(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            height: getProportionateScreenHeight(
                                                50.0),
                                            width: getProportionateScreenWidth(
                                                100.0),
                                            child: CustomButton(
                                                label: "Edit Profile",
                                                color: orange,
                                                fontSize: 12.0,
                                                onPressed: () {
                                                  setState(() {
                                                    _isEnabled = !_isEnabled;
                                                  });
                                                }),
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                          getProportionateScreenHeight(30.0),
                                        ),
                                        ListTile(
                                          title: CustomTextField(
                                            label: "First Name",
                                            controller: _firstNameController,
                                            color: lightGrey,
                                            enabled: _isEnabled,
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
                                            height: getProportionateScreenHeight(
                                                10.0)),
                                        ListTile(
                                          title: CustomTextField(
                                            label: "Last Name",
                                            controller: _lastNameController,
                                            color: lightGrey,
                                            enabled: _isEnabled,
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
                                            height: getProportionateScreenHeight(
                                                10.0)),
                                        ListTile(
                                          title: CustomTextField(
                                            label: "Username",
                                            controller: _usernameController,
                                            color: lightGrey,
                                            keyboardType: TextInputType.text,
                                            enabled: false,
                                          ),),
                                        SizedBox(
                                            height: getProportionateScreenHeight(
                                                10.0)),
                                        ListTile(
                                          title: CustomTextField(
                                            label: "Email",
                                            controller: _emailController,
                                            color: lightGrey,
                                            keyboardType: TextInputType.text,
                                            enabled: false,
                                          ),),
                                        SizedBox(
                                            height: getProportionateScreenHeight(
                                                10.0)),
                                        ListTile(
                                          title: CustomTextField(
                                            label: "Contact Number",
                                            controller: _phoneNumberController,
                                            color: lightGrey,
                                            keyboardType: TextInputType.text,
                                            enabled: false,
                                          ),),
                                        SizedBox(
                                            height: getProportionateScreenHeight(
                                                10.0)),

                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                ChangePassword.routeName);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                getProportionateScreenWidth(
                                                    15.0)),
                                            child: Text(
                                              "Change Password",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  decoration:
                                                  TextDecoration.underline,
                                                  color: blue,
                                                  fontWeight: FontWeight
                                                      .normal),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                          getProportionateScreenHeight(10.0),
                                        ),
                                        ListTile(
                                          title: SizedBox(
                                            height: getProportionateScreenHeight(
                                                50.0),
                                            width: double.infinity,
                                            child: CustomButton(
                                              label: "Update",
                                              color: orange,
                                              enabled: _isEnabled && (_formKey.currentState?.validate() ?? false),
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  _formKey.currentState!.save();

                                                  getUserProfileUpdated();

                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                          getProportionateScreenHeight(20.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _processing ? Loader(color: orange) : Container(),
            Align(
              alignment: Alignment.topCenter,
              child: SlideTransition(
                position: _offset!,
                child: Container(
                  margin: EdgeInsets.all(getProportionateScreenHeight(10.0)),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: red,
                      border: Border.all(color: _isSuccess ? green : red),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Text(
                    _snackMessage,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: white,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
