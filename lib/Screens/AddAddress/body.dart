import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import '../../Components/CustomButton.dart';
import '../../Components/CustomSearchTextField.dart';
import '../../Models/AddressData.dart';
import '../../Models/Debouncer.dart';
import '../../Models/Places.dart';
import '../../Models/PlacesDetails.dart';
import '../../Services/ApiCalls.dart';
import '../../SizeConfig.dart';
import 'package:location/location.dart';

import '../../colors.dart';
import 'Components/CustomAddress.dart';
class Body extends StatefulWidget{
  final Address? address;
  final int? index;

  const Body({Key? key, this.address, this.index}) : super(key: key);



  @override
  _BodyState createState() => _BodyState();
}
class _BodyState extends State<Body> with TickerProviderStateMixin{
  final TextEditingController locationController = TextEditingController();
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  final ScrollController _placesListScrollController = ScrollController();

  AnimationController? _controller;
  Animation<Offset>? _offset;
  String _snackMessage = "";
  GoogleMapController? newGoogleMapController;
  bool enabled = false;
  LocationData? currentPosition;
  Set<Marker> markers = {};

  Address? address;
  String? _lastInputValue;
  final _debouncer = Debouncer(milliseconds: 1000);
  List<Places> _places=[];
  bool _visibleSearch=false;
  var location = loc.Location();
  PlacesDetails? placesDetails;
  @override
  void initState() {
    // TODO: implement initState
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _offset = Tween<Offset>(begin: Offset(0.0, -2.0), end: Offset(0.0, 0.0))
        .animate(_controller!);
    super.initState();
  }


  Future<bool> _checkLocationPermissions() async {
    bool serviceEnabled = false;
    PermissionStatus permission;
    bool permissionCheck = false;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        _checkLocationPermissions();
      } else {
        permission = await location.hasPermission();
        if (permission == PermissionStatus.denied) {
          permission = await location.requestPermission();
          if (permission == PermissionStatus.denied) {
            _checkLocationPermissions();
            permissionCheck = false;
          }
        }
        if (permission == PermissionStatus.deniedForever) {
          Fluttertoast.showToast(
              msg:
              "Location permissions are permanently denied, please open app settings to active location permissions.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: orange,
              textColor: Colors.white,
              fontSize: 15.0);
          permissionCheck = false;
        }
        permissionCheck = true;
      }
    } else {
      permission = await location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await location.requestPermission();
        if (permission == PermissionStatus.denied) {
          _checkLocationPermissions();
          permissionCheck = false;
        }
      }
      if (permission == PermissionStatus.deniedForever) {
        Fluttertoast.showToast(
            msg:
            "Location permissions are permanently denied, please open app settings to active location permissions.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: orange,
            textColor: Colors.white,
            fontSize: 15.0);
        permissionCheck = false;
      }
      permissionCheck = true;
    }
    return permissionCheck;
  }

  //get current location of user
  getCurrentLocation() async {
    bool isLocationEnabled = await _checkLocationPermissions();
    if (isLocationEnabled) {
      LocationData position = await location.getLocation();
      currentPosition = position;

      LatLng latLngPosition = LatLng(position.latitude!, position.longitude!);
      address = await getAddress(latLngPosition);
      if(address!=null) {
        //change position of map on current address
        changePosition();
      }

    }
  }

  //current location marker
  setCurrentMarker(LatLng latLngPosition) {
    setState(() {
      markers.add(
          Marker(
            flat: true,
            markerId: MarkerId("1"),
            draggable: false,
            consumeTapEvents: true,
            position: latLngPosition,
            icon:
            BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),
          ));
    });
  }

  //change position
  changePosition()  {
    LatLng latLng = LatLng(double.parse((address?.latitude)!),double.parse((address?.longitude)!));
    CameraPosition cameraPosition = CameraPosition(
        target: latLng, zoom: 15.0);
    newGoogleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition));
    setCurrentMarker(latLng);
    setState(() {
      enabled = true;
    });
  }

  //get places on search in text field
  getSearchPlaces(String text) async{
    String result = await ApiCalls.getPlacesBySearch(text,"pk",(address?.latitude)!,(address?.longitude)!,100000);
    if (result != "Something went wrong please try again") {
      setState(() {
        _places = placesFromJson(result);
        if(_places.isNotEmpty){
          _visibleSearch=true;
        }
      });
    }
    else {
      displaySnackMessage(result);
    }
  }

  //get place detail by id when lat lng changed
  Future<Address?> getAddress (LatLng latLng) async{
    String result = await ApiCalls.getAddressFromLatLng(latLng.latitude,latLng.longitude);
    if (result != "Something went wrong please try again") {

      PlacesDetails placesDetails = placesDetailsFromJson(result);
      address = setAddress(placesDetails);
      return address;
    }
    else {
      displaySnackMessage(result);
    }
    return null;
  }

  //set address to address object
  Address setAddress(PlacesDetails placesDetails){
    Address? address = Address();
    for (var addComp in placesDetails.addressComponents ?? []) {
      if ((addComp.types?.contains("plus-code") ?? false) || (addComp.types?.contains("street_number") ?? false)) {
        address.street = addComp.longName;
      }
      if ((addComp.types?.contains("premise") ?? false)) {
        String additionalStreet = address.street ?? "";
        additionalStreet += "${addComp.longName} ";
        address.street = additionalStreet;
      }
      if ((addComp.types?.contains("subpremise") ?? false)) {
        String additionalStreet = address.street ?? "";
        additionalStreet += "${addComp.longName} ";
        address.street = additionalStreet;
      }
      if ((addComp.types?.contains("route") ?? false)) {
        String additionalStreet = address.street ?? "";
        additionalStreet += " ${addComp.longName} ";
        address.street = additionalStreet;
      }
      if ((addComp.types?.contains("neighborhood") ?? false)) {
        String additionalStreet = address.street ?? "";
        additionalStreet += " ${addComp.longName} ";
        address.street = additionalStreet;
      }
      if ((addComp.types?.contains("sublocality") ?? false) && (addComp.types?.contains("sublocality_level_1") ?? false)) {
        address.area = addComp.longName;
      }
      if (addComp.types?.contains("administrative_area_level_1") ?? false) {
        address.province = addComp.longName;
      }
      if (addComp.types?.contains("locality") ?? false) {
        address.city = addComp.longName;
      }
      if (addComp.types?.contains("country") ?? false) {
        address.country = addComp.longName;
      }
      if (addComp.types?.contains("postal_code") ?? false) {
        address.postalCode = addComp.longName;
      }
    }
    address.longitude = placesDetails.geometry?.location?.lng.toString();
    address.latitude = placesDetails.geometry?.location?.lat.toString();
    address.formatedAddress =placesDetails.formattedAddress;
    address.addressName = placesDetails.name?? "";
    return address;
  }

  //get place detail by id when tap on particular search places
  getPlaces(String placeId) async{
    String result = await ApiCalls.getPlacesDetail(placeId);
    if (result != "Something went wrong please try again") {
      PlacesDetails placesDetails = placesDetailsFromJson(result);
      address = setAddress(placesDetails);
      LatLng latLng = LatLng((placesDetails.geometry?.location?.lat)!,(placesDetails.geometry?.location?.lng)!);
      changePosition();
    }
    else {
      displaySnackMessage(result);
    }
  }

  //print message
  displaySnackMessage(String message) {
    try {
      setState(() {
        _snackMessage = message;
      });
      _controller?.forward();
      Future.delayed(Duration(seconds: 2), () {
        _controller?.reverse();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  //reset search variabels
  reset(){
    setState((){
      _visibleSearch=false;
      _places=[];
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    newGoogleMapController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){

        //close search drop down when outside tap
        reset();
      },
      child: SafeArea(
          child:Stack(
              children:[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10.0),vertical: getProportionateScreenHeight(10.0)),
                  child: Column(
                    children: [
                      Expanded(
                        child:  Card(
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
                                padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(10.0),horizontal: getProportionateScreenWidth(10.0)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Select a Location",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: blueGrey,
                                          fontWeight: FontWeight.bold),
                                    ),

                                    SizedBox(height: getProportionateScreenHeight(05)),
                                    SizedBox(
                                      height: getProportionateScreenHeight(50.0),
                                      child: Card(
                                        elevation: 15.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6.0),
                                        ),
                                        shadowColor: Color(0xFF93A7BE).withOpacity(0.3),
                                        child: CustomSearchTextField(
                                            controller: locationController,
                                            label: "Search By Location",
                                            onChanged: (value) {

                                              //prevent API to hit on dismissed keyboard
                                              if (_lastInputValue != value) {


                                                // if value not null then call
                                                if (value != "") {

                                                  //wait user to write then get data
                                                  _debouncer.run(() {
                                                    getSearchPlaces(value.trim());
                                                  });

                                                } else {
                                                  //wait user to clear all text then reset
                                                  _debouncer.run(() {
                                                    reset();
                                                  });
                                                }
                                              }
                                              _lastInputValue = value;
                                            }
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getProportionateScreenHeight(10)),
                                    Expanded(
                                      child: AbsorbPointer(
                                        absorbing: _visibleSearch,
                                        child: Stack(
                                            children:[
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(13.0)
                                                ),
                                                child: GoogleMap(
                                                  mapType: MapType.normal,
                                                  myLocationButtonEnabled: false,
                                                  myLocationEnabled: true,
                                                  zoomControlsEnabled: false,
                                                  zoomGesturesEnabled: true,
                                                  markers: markers,
                                                  onTap: (latlng) async {
                                                    address = await getAddress(latlng);
                                                    if(address!=null) {
                                                      //change position of map on current address
                                                      changePosition();
                                                    }
                                                  },
                                                  initialCameraPosition: CameraPosition(target: LatLng(30.3753,69.3451),zoom: 10.0),
                                                  onMapCreated: (GoogleMapController controller) async {
                                                    _controllerGoogleMap.complete(controller);
                                                    newGoogleMapController = controller;
                                                    if(widget.address!=null) {
                                                      LatLng latLng = LatLng(double.parse((widget.address?.latitude)!),double.parse((widget.address?.longitude)!));
                                                      address = await getAddress(latLng);
                                                      if(address!=null) {
                                                        //change position of map on current address
                                                        changePosition();
                                                      }
                                                    }
                                                    else {
                                                      getCurrentLocation();
                                                    }
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding:const EdgeInsets.all(10.0),
                                                child: Align(
                                                  alignment: Alignment.bottomRight,
                                                  child: FloatingActionButton(onPressed: (){
                                                    getCurrentLocation();
                                                  },
                                                    backgroundColor: Color(0xFFFFFFFF).withOpacity(0.7),

                                                    child: Icon(
                                                      Icons.my_location,
                                                      color: orange,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              enabled
                                                  ?Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5.0),vertical: getProportionateScreenHeight(5.0)),
                                                  child: Card(
                                                      elevation: 20.0,
                                                      shadowColor: Color(0xFF93A7BE).withOpacity(0.3),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20.0),
                                                      ),
                                                      child:Padding(
                                                        padding: EdgeInsets.all(10.0),
                                                        child:
                                                        Column(
                                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              RichText(
                                                                textAlign: TextAlign.center,
                                                                text: TextSpan(
                                                                  children: <TextSpan>[
                                                                    address?.addressName!=null
                                                                        ? TextSpan(
                                                                      text: "${address?.addressName} ",
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize: 14,
                                                                          color: blueGrey,
                                                                          fontWeight: FontWeight.bold),
                                                                    )  :TextSpan(),
                                                                    address?.street!=null
                                                                        ? TextSpan(
                                                                      text: "${address?.street} ",
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize: 14,
                                                                          color: blueGrey,
                                                                          fontWeight: FontWeight.bold),
                                                                    )
                                                                        :TextSpan(),
                                                                    address?.area!=null
                                                                        ? TextSpan(
                                                                      text: "${address?.area} ",
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize: 14,
                                                                          color: blueGrey,
                                                                          fontWeight: FontWeight.bold),
                                                                    )
                                                                        :TextSpan(),
                                                                    address?.city!=null
                                                                        ? TextSpan(
                                                                      text: "${address?.city} ",
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
                                                                textAlign: TextAlign.center,
                                                                text: TextSpan(
                                                                  children: <TextSpan>[
                                                                    address?.province!=null
                                                                        ? TextSpan(
                                                                      text: "${address?.province} ",
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize: 14,
                                                                          color: blueGrey,
                                                                          fontWeight: FontWeight.normal),
                                                                    )
                                                                        :TextSpan(),
                                                                    address?.country!=null
                                                                        ? TextSpan(
                                                                      text: "${address?.country} ",
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize: 14,
                                                                          color: blueGrey,
                                                                          fontWeight: FontWeight.normal),
                                                                    )
                                                                        :TextSpan(),
                                                                    address?.postalCode!=null
                                                                        ?TextSpan(
                                                                      text: "${address?.postalCode} ",
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
                                                      )
                                                  )
                                              )
                                                  :Container()

                                            ]
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
                      ListTile(
                        title: SizedBox(
                          height: getProportionateScreenHeight(50.0),
                          width: double.infinity,
                          child: CustomButton(
                              label: "Confirm",
                              enabled: enabled,
                              color: orange,
                              onPressed: (){
                                if(widget.index !=null){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CustomAddress(addressData: address,index: widget.index)));
                                }else{
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CustomAddress(addressData: address,)));
                                }
                              }
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                    visible: _visibleSearch,
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(30.0),
                            vertical: getProportionateScreenHeight(110.0)),
                        child: Card(
                          margin: EdgeInsets.all(0.0),
                          elevation: 5.0,
                          shadowColor: Color(0xFF93A7BE).withOpacity(0.3),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0)),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0)),
                            ),
                            child: _places.isNotEmpty
                                ? Scrollbar(
                              thumbVisibility: true,
                              radius: Radius.circular(20.0),
                              controller: _placesListScrollController,
                              child: ListView.separated(
                                  separatorBuilder: (BuildContext context, int index) => Divider(
                                    color:
                                    Color(0xFF707070),
                                    thickness: 0.5,
                                  ),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  controller: _placesListScrollController,
                                  padding: const EdgeInsets.all(10.0),
                                  itemCount: _places.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          getPlaces(_places[index].placeId!);
                                          reset();

                                        });
                                      },
                                      child:  Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:[
                                            Text(
                                              (_places[index].structuredFormatting?.mainText)!,
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.poppins(
                                                  fontSize: getProportionateScreenWidth(14),
                                                  color: blueGrey,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 1.0,),
                                            Text(
                                              _places[index].description!,
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.poppins(
                                                  fontSize: getProportionateScreenWidth(13),
                                                  color: lightGrey,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ]
                                      ),
                                    );
                                  }),
                            )
                                : SizedBox(
                              height: getProportionateScreenHeight(200.0),
                              child: Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/Icons/search_icon.svg",
                                        color: blueGrey,
                                        width: 20.0,
                                      ),
                                      Text(
                                        "Zero Searches",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: blueGrey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "You haven't search any thing yet",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: blueGrey.withOpacity(0.5),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ))),
                Align(
                  alignment: Alignment.topCenter,
                  child: SlideTransition(
                    position: _offset!,
                    child: Container(
                      margin:
                      EdgeInsets.only(top: getProportionateScreenHeight(10.0)),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          color: red,
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
                ),
              ]
          )

      ),
    );
  }


}