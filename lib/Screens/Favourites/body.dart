import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tajammul_customer_app/Services/HiveServices.dart';
import '../../Components/CustomAddToCartButton.dart';
import '../../Components/CustomDialog.dart';
import '../../Models/CartProduct.dart';
import '../../Models/FavouriteProducts.dart';
import '../../Models/HiveProduct.dart';
import '../../Providers/userProvider.dart';
import '../../Services/ApiCalls.dart';
import '../../Services/loginUserCredentials.dart';
import '../../SizeConfig.dart';
import '../../UserConstant.dart';
import '../../colors.dart';
import '../../main.dart';
import '../Shop/screens/product_details.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  final LoginUserCredentials _credentials = LoginUserCredentials();
  List<FavouriteProducts> favList = [];
  String _snackMessage = "";

  AnimationController? _controller;
  Animation<Offset>? offset;
  Box<HiveProduct>? dataBox;

  displaySnackMessage(String message) {
    if (mounted) {
      setState(() {
        //processing = false;
        _snackMessage = message;
      });
      _controller?.forward();
      Future.delayed(Duration(seconds: 3), () {
        _controller?.reverse();
      });
    }
  }

  @override
  void initState() {
    getProductWishList();
    dataBox = Hive.box<HiveProduct>('cart');
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    offset = Tween<Offset>(
            begin: const Offset(0.0, -2.0), end: const Offset(0.0, 0.0))
        .animate(_controller!);
    super.initState();
  }

  getProductWishList() async {
    Map<String, String>? result = await ApiCalls.getProductWishList(
        context.read<UserProvider>().users.userId!);
    if (result?["error"] == null) {
      setState(() {
        favList = favouriteProductFromJson((result?["success"])!);
      });
    } else if (result?["error"] == "Session Expired") {
      await _credentials.getCurrentUser();
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
                    await _credentials.getCurrentUser();
                    String result = await ApiCalls.signInUser(
                        _credentials.getUsername()!,
                        _credentials.getPassword()!);
                    if (result == "Successfully Login") {
                      Navigator.pop(context, true);
                    }
                  },
                  imagePath: 'assets/Images/loginAgain.svg',
                ));
          }).then((value) async {
        getProductWishList();
      });
    } else {
      Fluttertoast.showToast(
          msg: (result?["error"])!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: orange,
          textColor: Colors.white,
          fontSize: 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: dataBox!.listenable(),
        builder: (context, Box<HiveProduct> items, _){
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Card(
                  elevation: 10.0,
                  shadowColor: Color(0xFF93A7BE).withOpacity(0.3),
                  margin: EdgeInsets.symmetric(
                      vertical: getProportionateScreenWidth(20.0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Color(0xFFEFEFEF), width: 0.1),
                      gradient: RadialGradient(
                        radius: 1.0,
                        center: Alignment(-0.6, -0.7),
                        colors: const [
                          Color(0xFFEFEFEF),
                          Color(0xFFFFFFFF),
                        ],
                      ),
                    ),
                    child: favList.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/Icons/heart_fill.svg",
                                color: blueGrey,
                                width: 20.0,
                              ),
                              SizedBox(
                                height:
                                getProportionateScreenHeight(20.0),
                              ),
                              Text(
                                "You do not have any Favourite Products yet",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: blueGrey,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "You can add some of it from shops",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: blueGrey.withOpacity(0.5),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                        : ListView.separated(
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: favList.length,
                        padding: const EdgeInsets.all(0.0),
                        itemBuilder: (context, index) {
                          var data = favList[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDetails(
                                        product: data.product,
                                        business: data.business,
                                      )));
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Stack(
                                    alignment: Alignment.topLeft,
                                    children: <Widget>[
                                      SizedBox(
                                        width: getProportionateScreenWidth(130.0),
                                        height:
                                        getProportionateScreenHeight(130.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(12.0),
                                            ),
                                            child: Padding(
                                                padding:
                                                const EdgeInsets.all(10.0),
                                                child: Material(
                                                  elevation: 10,
                                                  borderRadius:
                                                  BorderRadius.circular(12.0),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(15),
                                                    child: (data.product?.listImagePath !=null && (data.product?.listImagePath?.isNotEmpty)!)
                                                        ? CachedNetworkImage(
                                                      imageUrl: "${env.config?.imageUrl}${(data.product?.listImagePath?[0])}",
                                                      fit: BoxFit.fill,
                                                    )
                                                        :SvgPicture.asset("assets/Icons/avatar.svg")
                                                  )
                                                ))),
                                      ),
                                      Container(
                                          height: getProportionateScreenWidth(35),
                                          width: getProportionateScreenHeight(35),
                                          decoration: BoxDecoration(
                                            color: orange,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.favorite,
                                            size: 18,
                                            color: white,
                                          ))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10.0),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${data.product!.productName}',
                                        style: GoogleFonts.poppins(
                                            color: blueGrey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${data.product!.description}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: GoogleFonts.poppins(
                                            fontSize: 10, color: blueGrey),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Rs ${data.product!.discountedPrice}',
                                            style: GoogleFonts.poppins(
                                                color: orange),
                                          ),
                                          SizedBox(
                                            width: getProportionateScreenWidth(4),
                                          ),
                                          data.product!.price == 0
                                              ? Container()
                                              : Text(
                                            'Rs ${data.product!.price}',
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              decoration: TextDecoration
                                                  .lineThrough,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Align(
                                          alignment: Alignment.bottomRight,
                                          child: HiveServices.getQuantity(data.product!,items)! < 1
                                                ? InkWell(
                                              onTap: () {
                                                List<CartProduct>?cartList = items.getAt(0)!.cartData;
                                                bool isFound = false;
                                                int? cartItemIndex;
                                                int? quantity;
                                                if (cartList!.isEmpty) {
                                                  HiveServices.setBusiness(data.business, items);
                                                }
                                                if (items.getAt(0)!.business!.businessId == data.business!.businessId) {
                                                      for (int i = 0; i < cartList.length; i++) {
                                                        if (cartList[i].productName == data.product!.productName) {
                                                          cartItemIndex = i;
                                                          quantity = cartList[i].quantity;
                                                          isFound = true;
                                                          break;
                                                        }
                                                      }
                                                      if (data.product!.status != STATUS_PRODUCT_UNAVAILABLE) {
                                                        if (!isFound) {
                                                          if ((data.product!.quantity)! > 0) {
                                                            CartProduct cartProduct = CartProduct(
                                                                price: data.product!.price,
                                                                productName: data.product!.productName,
                                                                discount: data.product!.discount,
                                                                discountedPrice: data.product!.discountedPrice,
                                                                listImagePath: data.product!.listImagePath,
                                                                updatedStock: data.product!.quantity,
                                                                quantity: 1);
                                                            HiveProduct? hp = items.getAt(0);
                                                            HiveServices.addProduct(cartProduct, (hp?.currentCategory)!, items);
                                                            HiveServices.addCategory((hp?.currentCategory)!, items);
                                                          } else {
                                                            displaySnackMessage(
                                                                "Product is out of stock");
                                                          }
                                                        } else {
                                                          if (quantity! <= (data.product!.quantity)!) {
                                                            HiveProduct? hp = items.getAt(0);
                                                            HiveServices.addQuantity(cartItemIndex!, items);
                                                            HiveServices.addCategory((hp?.currentCategory)!, items);
                                                          } else {
                                                            displaySnackMessage(
                                                                "You can't add more");
                                                          }
                                                        }
                                                      } else {
                                                        displaySnackMessage(
                                                            "You Can't Add Unavailable Product");
                                                      }
                                                    }else{
                                                      Fluttertoast.showToast(
                                                          msg: "You can't add product from different shop. Remove items first!",
                                                          toastLength: Toast.LENGTH_LONG,
                                                          gravity: ToastGravity.BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor: orange,
                                                          textColor: Colors.white,
                                                          fontSize: 15.0);
                                                    }
                                              },
                                              child: SvgPicture.asset(
                                                "assets/Images/cartImage.svg",
                                                width: 40.0,
                                              ),
                                            )
                                                : SizedBox(
                                              width:
                                              getProportionateScreenWidth(
                                                  120),
                                              height:
                                              getProportionateScreenHeight(
                                                  50),
                                              child: CustomAddToCartButton(
                                                label: HiveServices.getQuantity(data.product!,items).toString(),
                                                subtract: () {
                                                  int? cartItemIndex;
                                                  HiveProduct? hp = items.getAt(0);
                                                  for (int i = 0; i < hp!.cartData!.length; i++) {
                                                    if (hp.cartData![i].productName == data.product!.productName) {
                                                      cartItemIndex = i;
                                                      break;
                                                    }
                                                  }
                                                  if ((hp.cartData?[cartItemIndex!].quantity)! <= (hp.cartData?[cartItemIndex!].updatedStock)!) {
                                                    HiveServices.setCategory(hp.currentCategory!, items);
                                                    HiveServices.subtractQuantity(cartItemIndex!, (hp.currentCategory)!, items);
                                                  } else {
                                                    displaySnackMessage("You can't add more");
                                                  }
                                                },
                                                addQuantity: () {
                                                  int? cartItemIndex;
                                                  HiveProduct? hp = items.getAt(0);
                                                  for (int i = 0; i < hp!.cartData!.length; i++) {
                                                    if (hp.cartData![i].productName == data.product!.productName) {
                                                      cartItemIndex = i;
                                                      break;
                                                    }
                                                  }
                                                  if ((hp.cartData?[cartItemIndex!].quantity)! < (hp.cartData?[cartItemIndex!].updatedStock)!) {
                                                    HiveServices.addQuantity(cartItemIndex!, items);
                                                  } else {
                                                    displaySnackMessage(
                                                        "You can't add more");
                                                  }
                                                },
                                                color: orange,
                                              ),
                                            )
                                          )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10.0),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SlideTransition(
                      position: offset!,
                      child: Container(
                        margin:
                        EdgeInsets.only(top: getProportionateScreenHeight(10.0)),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            color: Colors.red,
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
                ),
              ),
            ],
          );
        });
  }
}