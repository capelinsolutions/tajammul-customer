import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tajammul_customer_app/Providers/userProvider.dart';
import '../../../Components/CustomButton.dart';
import '../../../Components/CustomDialog.dart';
import '../../../Components/CustomTextField.dart';
import '../../../Models/AddressData.dart';
import '../../../Services/ApiCalls.dart';
import '../../../Services/loginUserCredentials.dart';
import '../../../SizeConfig.dart';
import '../../../UserConstant.dart';
import '../../../colors.dart';

class CustomAddress extends StatefulWidget{
  final Address? addressData;
  final int? index;

  const CustomAddress({Key? key, required this.addressData,this.index}) : super(key: key);

  @override
  _CustomAddressState createState() => _CustomAddressState();
}
class _CustomAddressState extends State<CustomAddress> {
  final TextEditingController floor = TextEditingController();
  final TextEditingController additionalAddress = TextEditingController();
  final TextEditingController postalCode = TextEditingController();
  LoginUserCredentials credentials = LoginUserCredentials();

  @override
  void initState() {
    if(widget.addressData?.postalCode!=null){
      postalCode.text= (widget.addressData?.postalCode)!;
    }
    super.initState();
  }

  addAddress(Address? addressData) async {
    Map<String,String>? result = await ApiCalls.addAddress(userId:context.read<UserProvider>().users.userId!,input: addressData!);
    if(result["error"] == null) {
      context.read<UserProvider>().setAddress(addressDataFromJson((result["success"])!));
      Navigator.pop(context);
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: ('Address Added'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,

          backgroundColor: orange,
          textColor: Colors.white,
          fontSize: 15.0);
    }
    else if (result["error"] == "Session Expired") {
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
        addAddress(value);
      });
    }
    else {
      Fluttertoast.showToast(
          msg: (result["error"])!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: orange,
          textColor: Colors.white,
          fontSize: 15.0
      );
    }
  }

  updateAddress(Address? addressData) async {
    Map<String,String>? result = await ApiCalls.updateAddress(userId:context.read<UserProvider>().users.userId!,input: addressData!,index: widget.index!);
    if(result["error"] == null) {
      context.read<UserProvider>().setAddress(addressDataFromJson((result["success"])!));
      Navigator.pop(context);
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: ('Address Updated'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: orange,
          textColor: Colors.white,
          fontSize: 15.0);
    }
    else if (result["error"] == "Session Expired") {
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
        updateAddress(value);
      });
    }
    else {
      Fluttertoast.showToast(
          msg: (result["error"])!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: orange,
          textColor: Colors.white,
          fontSize: 15.0
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 1.0,
        centerTitle: true,
        iconTheme: IconThemeData(
            color: blueGrey

        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,size: 20,),
        ),
        title: Text(
          widget.index == null ? "Add an Address" : "Edit Address",
          style: GoogleFonts.poppins(
              fontSize: 18,
              color: blueGrey,
              fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: SafeArea(
          child:SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: getProportionateScreenHeight(10.0)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10.0)),
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
                                  color: Color(0xFFFFFFFF),
                                ),
                                child:Padding(
                                  padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(20.0)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10.0)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:[
                                        Text("Add a New Address",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: blueGrey,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: orange,
                                          ),
                                        )
                                        ]
                                        ),
                                      ),
                                      SizedBox(height: getProportionateScreenHeight(10)),
                                      ListTile(
                                        title: Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              color: orange,
                                              size: 40,
                                            ),
                                          SizedBox(width: getProportionateScreenWidth(05.0),),
                                            Expanded(
                                              child:  Padding(
                                                padding: EdgeInsets.only(right: getProportionateScreenWidth(20.0)),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          children: <TextSpan>[
                                                        widget.addressData?.addressName!=null
                                                                ? TextSpan(
                                                              text: "${widget.addressData?.addressName} ",
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 14,
                                                                  color: blueGrey,
                                                                  fontWeight: FontWeight.bold),
                                                            )  :TextSpan(),
                                                            widget.addressData?.street!=null
                                                                ? TextSpan(
                                                              text: "${widget.addressData?.street} ",
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 14,
                                                                  color: blueGrey,
                                                                  fontWeight: FontWeight.bold),
                                                            )
                                                                :TextSpan(),
                                                            widget.addressData?.area!=null
                                                                ? TextSpan(
                                                              text: "${widget.addressData?.area} ",
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 14,
                                                                  color: blueGrey,
                                                                  fontWeight: FontWeight.bold),
                                                            )
                                                                :TextSpan(),
                                                            widget.addressData?.city!=null
                                                                ? TextSpan(
                                                              text: "${widget.addressData?.city} ",
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 14,
                                                                  color: blueGrey,
                                                                  fontWeight: FontWeight.bold),
                                                            )
                                                                :TextSpan()
                                                          ],
                                                        ),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          children: <TextSpan>[
                                                            widget.addressData?.province!=null
                                                                ? TextSpan(
                                                              text: "${widget.addressData?.province} ",
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 14,
                                                                  color: blueGrey,
                                                                  fontWeight: FontWeight.normal),
                                                            )
                                                                :TextSpan(),
                                                            widget.addressData?.country!=null
                                                                ? TextSpan(
                                                              text: "${widget.addressData?.country} ",
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 14,
                                                                  color: blueGrey,
                                                                  fontWeight: FontWeight.normal),
                                                            )
                                                                :TextSpan(),
                                                            widget.addressData?.postalCode!=null
                                                                ?TextSpan(
                                                              text: "${widget.addressData?.postalCode} ",
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 14,
                                                                  color: blueGrey,
                                                                  fontWeight: FontWeight.normal),
                                                            )
                                                                :TextSpan()

                                                          ],
                                                        ),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                          ),

                                        ]
                                        ),
                                        ),
                                      SizedBox(height: getProportionateScreenHeight(20)),
                                      ListTile(
                                        title:CustomTextField(
                                          label: "Floor/Unit #",
                                          controller: floor,
                                          color: lightGrey,
                                          isOptional: true,
                                          keyboardType:TextInputType.text,
                                        ),
                                      ),
                                      SizedBox(height: getProportionateScreenHeight(10)),
                                      ListTile(
                                        title:CustomTextField(
                                          label: "Addition Address",
                                          controller: additionalAddress,
                                          color: lightGrey,
                                          isOptional: true,
                                          keyboardType:TextInputType.text,
                                        ),
                                      ),
                                      SizedBox(height: getProportionateScreenHeight(250.0)),
                                       ListTile(
                                          title: SizedBox(
                                            height: getProportionateScreenHeight(45.0),
                                            width: double.infinity,
                                            child: CustomButton(
                                                label:  widget.index == null ? "Add Address" : "Edit Address",
                                                color: orange,
                                                onPressed: (){
                                                  if(widget.index == null){
                                                    Address? newAddress;
                                                    setState(() {
                                                      newAddress =widget.addressData;
                                                      newAddress?.residence=floor.text.trim();
                                                      newAddress?.additionalAddress=additionalAddress.text.trim();
                                                      newAddress?.postalCode=postalCode.text.trim();
                                                      newAddress?.addressType = USER_ADDIOTIONAL_ADDRESS;
                                                    });
                                                    addAddress(newAddress);
                                                  }
                                                  else{
                                                    Address? newAddress;
                                                    setState(() {
                                                      newAddress =widget.addressData;
                                                      newAddress?.residence=floor.text.trim();
                                                      newAddress?.additionalAddress=additionalAddress.text.trim();
                                                      newAddress?.postalCode=postalCode.text.trim();
                                                    });
                                                    updateAddress(newAddress);
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
              )
          )
      ),
    );
  }
}