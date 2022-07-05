
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:tajammul_customer_app/Models/Business.dart';
import 'package:tajammul_customer_app/Models/FavouriteProducts.dart';
import 'package:tajammul_customer_app/Models/HiveProduct.dart';
import 'package:tajammul_customer_app/Models/Product.dart';
import 'package:tajammul_customer_app/Providers/userProvider.dart';
import 'package:tajammul_customer_app/Services/HiveServices.dart';
import '../../../Components/CustomDialog.dart';
import '../../../Services/ApiCalls.dart';
import '../../../Services/loginUserCredentials.dart';
import '../../../SizeConfig.dart';
import '../../../colors.dart';
import '../../../main.dart';

class ProductItemsList extends StatefulWidget {
  final Product product;
  final Business business;
  final String categoryName;
  final VoidCallback refresh;
  final VoidCallback? add;
  final VoidCallback? subtract;
  final VoidCallback? addQuantity;
  final VoidCallback? onTap;
  final Function processing;
  final String? from;
  final bool? isPresent;
  List<FavouriteProducts> favList;
  bool isUpdate;

  ProductItemsList(
      {Key? key,
      required this.product,
      required this.business,
      required this.categoryName,
      required this.favList,
      required this.refresh,
      required this.processing,
      this.from,
      required this.isUpdate,
      required this.add,
      this.subtract,
      this.addQuantity,
        this.onTap,
      this.isPresent})
      : super(key: key);

  @override
  _ProductItemsListState createState() => _ProductItemsListState();
}

class _ProductItemsListState extends State<ProductItemsList> {
  final LoginUserCredentials _credentials = LoginUserCredentials();
  bool isPresent = false;
  bool isLiked = false;
  String? wishList;
  bool processing = false;
  Box<HiveProduct>? dataBox;

  @override
  void initState() {
    dataBox = Hive.box<HiveProduct>('cart');

    super.initState();
  }

  addProductInWishList() async {
    setState(() {
      processing = true;
    });
    Map<String, String>? result = await ApiCalls.addProductInWishList(
        widget.business,
        context.read<UserProvider>().users.userId!,
        widget.product,
      widget.categoryName);
    if (result?["error"] == null) {
      setState(() {
        isLiked = true;
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
        addProductInWishList();
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
    setState(() {
      processing = false;
    });
  }

  deleteProductFromWishList() async {
    setState(() {
      processing = true;
    });
    Map<String, String>? result = await ApiCalls.deleteProductFromWishList(
        widget.business,
        context.read<UserProvider>().users.userId!,
        widget.product);
    if (result?["error"] == null) {
      setState(() {
        isLiked = false;
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
        deleteProductFromWishList();
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
    setState(() {
      processing = false;
    });
  }

  bool loadWishList() {
    bool isLiked = false;
    for (var i in widget.favList) {
      if (i.product?.productName == widget.product.productName) {
        isLiked = true;
        break;
      }
      isLiked = false;
    }
    return isLiked;
  }


  @override
  Widget build(BuildContext context) {
    setState((){
      isPresent = false;
    });
    HiveProduct? hp;
    hp=dataBox?.getAt(0);
    for (var i in hp!.cartData!) {
      if (i.productName == widget.product.productName) {
        if(i.quantity! > 0) {
          isPresent = true;
        }
      }
    }
    return ValueListenableBuilder(
        valueListenable: dataBox!.listenable(),
        builder: (context, Box<HiveProduct> items, _){
          return AbsorbPointer(
            absorbing: (widget.product.quantity)! > 0 ? false : true,
            child: Opacity(
              opacity: (widget.product.quantity)! > 0 ? 1.0 : 0.3,
              child: InkWell(
                onTap: widget.onTap,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 4,
                              offset: Offset(0, 3))
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  height: getProportionateScreenHeight(20),
                                  width: getProportionateScreenWidth(55),
                                  decoration: BoxDecoration(
                                    color: orange,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(3)),
                                  ),
                                  child: Center(
                                      child: Text(
                                        '${widget.product.discount ?? 0}% Off',
                                        style:
                                        GoogleFonts.poppins(fontSize: 10, color: white),
                                      )),
                                ),
                              ),
                              Visibility(
                                visible: !processing,
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: InkWell(
                                    onTap: () async {
                                      if (widget.isUpdate) {
                                        if (!isLiked) {
                                          addProductInWishList();
                                        } else {
                                          deleteProductFromWishList();
                                        }
                                      } else {
                                        if (!loadWishList()) {
                                          addProductInWishList();
                                        } else {
                                          deleteProductFromWishList();
                                        }
                                      }
                                      setState(() {
                                        widget.isUpdate = true;
                                      });
                                    },
                                    child: Container(
                                      height: getProportionateScreenHeight(30),
                                      width: getProportionateScreenWidth(30),
                                      decoration: BoxDecoration(
                                          color: yellow.withOpacity(.23),
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child:
                                        (widget.isUpdate ? isLiked : loadWishList())
                                            ? SvgPicture.asset(
                                          "assets/Icons/heart_fill.svg",
                                          width: 13,
                                        )
                                            : SvgPicture.asset(
                                          "assets/Icons/heart.svg",
                                          width: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: getProportionateScreenWidth(140),
                            height: getProportionateScreenHeight(130),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: (widget.product.listImagePath !=null && (widget.product.listImagePath?.isNotEmpty)!)
                                  ? CachedNetworkImage(
                                imageUrl: "${env.config?.imageUrl}${(widget.product.listImagePath?[0])}",
                                fit: BoxFit.fill,
                              )
                                  :Image.asset(
                                "assets/Images/background_pic_image",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${widget.product.productName}',
                                        style: GoogleFonts.poppins(
                                            color: blueGrey, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${widget.product.description}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: GoogleFonts.poppins(
                                            fontSize: 10, color: blueGrey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    (widget.product.quantity ?? 0) < 1
                        ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Rs ${widget.product.discountedPrice ?? widget.product.price}',
                                    style: GoogleFonts.poppins(color: orange)),
                                SizedBox(
                                  width: getProportionateScreenWidth(4),
                                ),
                                (widget.product.discountedPrice != null && widget.product.discountedPrice != 0)
                                    ? Text('Rs ${widget.product.price}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough,
                                    ))
                                    :SizedBox(height: 0.0,width: 0.0,)
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              widget.add!();
                              setState(() {
                                isPresent = true;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Container(
                                height: getProportionateScreenHeight(35),
                                width: getProportionateScreenWidth(35),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: orange,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      "assets/Icons/addIcon.svg",
                                      width: 10,
                                      color: orange,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                        : isPresent
                        ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: orange,
                            boxShadow: [
                              BoxShadow(
                                  color: grey.withOpacity(.4),
                                  blurRadius: 5,
                                  offset: Offset(0, -3))
                            ],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () {
                                    widget.subtract!();
                                    if (HiveServices.getQuantity(widget.product,items)! > 0) {
                                      setState(() {
                                        isPresent = false;
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    height: getProportionateScreenHeight(30),
                                    width: getProportionateScreenWidth(30),
                                    child: SvgPicture.asset(
                                        'assets/Icons/remove.svg',
                                        width: 10),
                                  )),
                              Text(
                                HiveServices.getQuantity(widget.product,items).toString(),
                                style: GoogleFonts.poppins(
                                    color: white, fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                  onTap: () {
                                    widget.addQuantity!();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    height: getProportionateScreenHeight(30),
                                    width: getProportionateScreenWidth(30),
                                    child: SvgPicture.asset(
                                        'assets/Icons/addIcon.svg'),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    )
                        : Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Rs ${widget.product.discountedPrice ?? widget.product.price}',
                                    style: GoogleFonts.poppins(color: orange)),
                                SizedBox(
                                  width: getProportionateScreenWidth(4),
                                ),
                                (widget.product.discountedPrice != null && widget.product.discountedPrice != 0)
                                    ? Text('Rs ${widget.product.price}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough,
                                    ))
                                    :SizedBox(height: 0.0,width: 0.0,)
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              widget.add!();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Container(
                                height: getProportionateScreenHeight(35),
                                width: getProportionateScreenWidth(35),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: orange,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      "assets/Icons/addIcon.svg",
                                      width: 10,
                                      color: orange,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });


  }
}
