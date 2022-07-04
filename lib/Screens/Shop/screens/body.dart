import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tajammul_customer_app/Components/CustomAddToCartButton.dart';
import 'package:tajammul_customer_app/Components/CustomButton.dart';
import 'package:tajammul_customer_app/Models/Business.dart';
import 'package:tajammul_customer_app/Models/CartProduct.dart';
import 'package:tajammul_customer_app/Models/HiveProduct.dart';
import 'package:tajammul_customer_app/Models/Product.dart';
import 'package:tajammul_customer_app/Services/HiveServices.dart';
import '../../../../../Screens/Dashboard/body.dart';
import '../../../../../SizeConfig.dart';
import '../../../../../colors.dart';
import '../../../UserConstant.dart';
import '../../../main.dart';

class Body extends StatefulWidget {
  final Product? product;
  final Business? business;
  const Body({Key? key, this.product, this.business}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  List<InfoComponents> slider = [
    InfoComponents(
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROA8QBdELzSJmUg1PRD27NKEgUhZ6xc4RJCLOgUMfE7RvyyjLC__390ooRa4BF8ZLS6CQ&usqp=CAU"),
    InfoComponents(
      image:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROA8QBdELzSJmUg1PRD27NKEgUhZ6xc4RJCLOgUMfE7RvyyjLC__390ooRa4BF8ZLS6CQ&usqp=CAU",
    ),
    InfoComponents(
        image:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROA8QBdELzSJmUg1PRD27NKEgUhZ6xc4RJCLOgUMfE7RvyyjLC__390ooRa4BF8ZLS6CQ&usqp=CAU"),
  ];
  int activeIndex = 0;
  int count = 0;
  bool isTapped = false;
  bool processing = false;
  String _snackMessage = "";
  Box<HiveProduct>? dataBox;

  AnimationController? _controller;
  Animation<Offset>? offset;

  displaySnackMessage(String message) {
    if (mounted) {
      setState(() {
        processing = false;
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
    super.initState();
    dataBox = Hive.box<HiveProduct>('cart');
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    offset = Tween<Offset>(
            begin: const Offset(0.0, -2.0), end: const Offset(0.0, 0.0))
        .animate(_controller!);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: dataBox!.listenable(),
          builder: (context, Box<HiveProduct> items, _) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Container(
                    height: getProportionateScreenHeight(180),
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: grey.withOpacity(.7),
                              blurRadius: 5,
                              offset: Offset(0, 3))
                        ]),
                    child: CarouselSlider.builder(
                      itemCount: widget.product!.listImagePath == null
                          ? slider.length
                          : widget.product!.listImagePath!.length,
                      options: CarouselOptions(
                          pauseAutoPlayInFiniteScroll: false,
                          height: getProportionateScreenHeight(180.0),
                          scrollDirection: Axis.horizontal,
                          autoPlay: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          enableInfiniteScroll: true,
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              activeIndex = index;
                            });
                          }),
                      itemBuilder: (context, index, realIndex) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: (widget.product?.listImagePath != null &&
                                  (widget.product?.listImagePath?.isNotEmpty)!)
                              ? CachedNetworkImage(
                                  width: getProportionateScreenWidth(250.0),
                                  height: double.infinity,
                                  imageUrl:
                                      "${env.config?.imageUrl}${(widget.product?.listImagePath?[index])}",
                                  fit: BoxFit.fill,
                                )
                              : Image.asset(
                                  "assets/Images/background_pic_image",
                                  fit: BoxFit.fill,
                                ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(15),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AnimatedSmoothIndicator(
                      activeIndex: activeIndex, // PageController
                      count: widget.product!.listImagePath == null
                          ? slider.length
                          : widget.product!.listImagePath!.length,
                      effect: ColorTransitionEffect(
                          activeDotColor: orange,
                          dotWidth: 10,
                          dotHeight: 10), // your preferred effect
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(25),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 10.0,
                      shadowColor: Color(0xFF93A7BE).withOpacity(0.3),
                      margin: EdgeInsets.symmetric(
                          vertical: getProportionateScreenWidth(10.0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border:
                              Border.all(color: Color(0xFFEFEFEF), width: 0.1),
                          gradient: RadialGradient(
                            radius: 1.0,
                            center: Alignment(-0.6, -0.7),
                            colors: const [
                              Color(0xFFEFEFEF),
                              Color(0xFFFFFFFF),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.product!.productName}',
                              style: GoogleFonts.poppins(
                                  color: blueGrey, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${widget.product!.description}",
                              style: GoogleFonts.poppins(
                                  color: blueGrey, fontSize: 10),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(5),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Rs ${widget.product?.discountedPrice ?? widget.product?.price}',
                                    style: GoogleFonts.poppins(color: orange)),
                                SizedBox(
                                  width: getProportionateScreenWidth(4),
                                ),
                                (widget.product?.discountedPrice != null &&
                                        widget.product?.discountedPrice != 0)
                                    ? Text('Rs ${widget.product?.price}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ))
                                    : SizedBox(
                                        height: 0.0,
                                        width: 0.0,
                                      )
                              ],
                            ),
                            Divider(
                              color: orange,
                              thickness: 1.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${widget.business!.businessInfo!.name}',
                                  style: GoogleFonts.poppins(
                                      color: blueGrey,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('4.0',
                                    style: GoogleFonts.poppins(
                                        color: blueGrey, fontSize: 12)),
                                SizedBox(
                                  width: 5,
                                ),
                                SvgPicture.asset(
                                  "assets/Icons/rating_stars.svg",
                                  height: 12,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('(1,080)',
                                    style: GoogleFonts.poppins(
                                        color: blueGrey, fontSize: 12)),
                              ],
                            ),
                            Expanded(child: Container()),
                            SizedBox(
                                width: double.infinity,
                                child: HiveServices.getQuantity(
                                            widget.product!, items)! <
                                        1
                                    ? CustomButton(
                                        label: 'Add to cart',
                                        onPressed: () {
                                          setState(() {
                                            isTapped = true;
                                          });
                                          List<CartProduct>? cartList =
                                              items.getAt(0)?.cartData;
                                          bool isFound = false;
                                          int? cartItemIndex;
                                          int? quantity;
                                          if (cartList!.isEmpty) {
                                            HiveServices.setBusiness(
                                                widget.business!, items);
                                          }
                                          if (items
                                                  .getAt(0)
                                                  ?.business!
                                                  .businessId ==
                                              widget.business!.businessId) {
                                            for (int i = 0;
                                                i < cartList.length;
                                                i++) {
                                              if (cartList[i].productName ==
                                                  widget.product?.productName) {
                                                cartItemIndex = i;
                                                quantity = cartList[i].quantity;
                                                isFound = true;
                                                break;
                                              }
                                            }
                                            if (widget.product?.status !=
                                                STATUS_PRODUCT_UNAVAILABLE) {
                                              if (!isFound) {
                                                if ((widget
                                                        .product?.quantity)! >
                                                    0) {
                                                  CartProduct cartProduct =
                                                      CartProduct(
                                                          price: widget
                                                              .product?.price,
                                                          productName: widget
                                                              .product
                                                              ?.productName,
                                                          discount: widget.product
                                                              ?.discount,
                                                          discountedPrice: widget
                                                              .product
                                                              ?.discountedPrice,
                                                          listImagePath: widget
                                                              .product
                                                              ?.listImagePath,
                                                          updatedStock: widget
                                                              .product
                                                              ?.quantity,
                                                          quantity: 1);
                                                  HiveServices.setCategory(
                                                      items
                                                          .getAt(0)!
                                                          .currentCategory!,
                                                      items);
                                                  HiveServices.addProduct(
                                                      cartProduct,
                                                      items
                                                          .getAt(0)!
                                                          .currentCategory!,
                                                      items);
                                                  HiveServices.addCategory(
                                                      items
                                                          .getAt(0)!
                                                          .currentCategory!,
                                                      items);
                                                } else {
                                                  displaySnackMessage(
                                                      "Product is out of stock");
                                                }
                                              } else {
                                                if (quantity! <=
                                                    (widget
                                                        .product?.quantity)!) {
                                                  HiveServices.addQuantity(
                                                      cartItemIndex!, items);
                                                  HiveServices.setCategory(
                                                      items
                                                          .getAt(0)!
                                                          .currentCategory!,
                                                      items);
                                                  HiveServices.addCategory(
                                                      items
                                                          .getAt(0)!
                                                          .currentCategory!,
                                                      items);
                                                } else {
                                                  displaySnackMessage(
                                                      "You can't add more");
                                                }
                                              }
                                            } else {
                                              displaySnackMessage(
                                                  "You Can't Add Unavailable Product");
                                            }
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "You can't add product from different shop. Remove items first!",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: orange,
                                                textColor: Colors.white,
                                                fontSize: 15.0);
                                          }
                                        },
                                        color: orange,
                                      )
                                    : CustomAddToCartButton(
                                        label: HiveServices.getQuantity(
                                                widget.product!, items)
                                            .toString(),
                                        subtract: () {
                                          int? cartItemIndex;
                                          for (int i = 0;
                                              i <
                                                  items
                                                      .getAt(0)!
                                                      .cartData!
                                                      .length;
                                              i++) {
                                            if (items
                                                    .getAt(0)!
                                                    .cartData![i]
                                                    .productName ==
                                                widget.product?.productName) {
                                              cartItemIndex = i;
                                              break;
                                            }
                                          }
                                          if ((items
                                                  .getAt(0)!
                                                  .cartData?[cartItemIndex!]
                                                  .quantity)! <=
                                              (items
                                                  .getAt(0)!
                                                  .cartData?[cartItemIndex!]
                                                  .updatedStock)!) {
                                            HiveServices.setCategory(
                                                items
                                                    .getAt(0)!
                                                    .currentCategory!,
                                                items);
                                            HiveServices.subtractQuantity(
                                                cartItemIndex!,
                                                items
                                                    .getAt(0)!
                                                    .currentCategory!,
                                                items);
                                          } else {
                                            displaySnackMessage(
                                                "You can't add more");
                                          }
                                        },
                                        addQuantity: () {
                                          int? cartItemIndex;
                                          for (int i = 0;
                                              i <
                                                  items
                                                      .getAt(0)!
                                                      .cartData!
                                                      .length;
                                              i++) {
                                            if (items
                                                    .getAt(0)!
                                                    .cartData![i]
                                                    .productName ==
                                                widget.product?.productName) {
                                              cartItemIndex = i;
                                              break;
                                            }
                                          }
                                          if ((items
                                                  .getAt(0)!
                                                  .cartData?[cartItemIndex!]
                                                  .quantity)! <
                                              (items
                                                  .getAt(0)!
                                                  .cartData?[cartItemIndex!]
                                                  .updatedStock)!) {
                                            HiveServices.addQuantity(
                                                cartItemIndex!, items);
                                          } else {
                                            displaySnackMessage(
                                                "You can't add more");
                                          }
                                        },
                                        color: orange,
                                      ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
  }
}
