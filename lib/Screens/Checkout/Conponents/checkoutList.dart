import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Models/CartProduct.dart';
import '../../../SizeConfig.dart';
import '../../../UserConstant.dart';
import '../../../colors.dart';
import '../../../main.dart';

class CheckoutItemsList extends StatefulWidget {
  final CartProduct product;
  final VoidCallback remove;
  final VoidCallback add;
  final VoidCallback subtract;

  const CheckoutItemsList({
    Key? key,
    required this.product,
    required this.remove,
    required this.add,
    required this.subtract,
  }) : super(key: key);


  @override
  _CheckoutItemsListState createState() => _CheckoutItemsListState();
}

class _CheckoutItemsListState extends State<CheckoutItemsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7.0),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          border: widget.product.errorType != STATUS_PRODUCT_AVAILABLE && widget.product.errorType != null
              ? Border.all(color: red, width: 1.0)
              : Border.all(color: Colors.transparent, width: 0.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: getProportionateScreenWidth(80.0),
                height: getProportionateScreenHeight(80.0),
                child: Card(
                    margin: const EdgeInsets.all(0.0),
                    elevation: 10.0,
                    shadowColor: Color(0xFF93A7BE).withOpacity(0.3),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: (widget.product.listImagePath !=null && (widget.product.listImagePath?.isNotEmpty)!)
                          ? CachedNetworkImage(
                        imageUrl: "${env.config?.imageUrl}${(widget.product.listImagePath![0])}",
                        fit: BoxFit.fill,
                      )
                          :Image.asset(
                        "assets/Images/background_pic_image",
                        fit: BoxFit.fill,
                      ),
                    )),
              ),
              SizedBox(
                width: getProportionateScreenWidth(10.0),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.productName ?? "",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: blueGrey,
                              fontWeight: FontWeight.w700),
                        ),

                        InkWell(
                          onTap: () {
                            widget.remove();
                          },
                          child:
                          Container(
                            padding: EdgeInsets.all(6.0),
                            width: getProportionateScreenHeight(25.0),
                            height: getProportionateScreenHeight(25.0),
                            child: SvgPicture.asset(
                              "assets/Icons/cartCross.svg",
                              color: red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(35.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Rs. ${widget.product.price ?? ""}",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: blueGrey,
                                  fontWeight: FontWeight.w700),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    widget.add();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(0.0),
                                    margin: const EdgeInsets.all(0.0),
                                    width: 20.0,
                                    height: 20.0,
                                    child: Card(
                                      margin: const EdgeInsets.all(0.0),
                                      elevation: 10.0,
                                      shadowColor:
                                      Color(0xFF93A7BE).withOpacity(0.3),
                                      color: blueGrey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(50.0),
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/Icons/addIcon.svg",
                                          width:
                                          getProportionateScreenWidth(10.0),
                                          color: grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: getProportionateScreenWidth(10.0),),
                                Text(
                                  widget.product.quantity.toString(),
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: blueGrey,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(width: getProportionateScreenWidth(10.0),),

                                InkWell(
                                  onTap: () {
                                    widget.subtract();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(0.0),
                                    margin: const EdgeInsets.all(0.0),
                                    width: 20.0,
                                    height: 20.0,
                                    child: Card(
                                      margin: const EdgeInsets.all(0.0),
                                      elevation: 10.0,
                                      shadowColor:
                                      Color(0xFF93A7BE).withOpacity(0.3),
                                      color: grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(50.0),
                                        side: BorderSide(
                                            color: blueGrey,
                                            width: 2.0),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: SvgPicture.asset(
                                            "assets/Icons/myStoreSubtract.svg",
                                            width: getProportionateScreenWidth(
                                                18.0),
                                            fit: BoxFit.fill,
                                            color: blueGrey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(2.0),
                    ),
                    widget.product.discountedPrice != null? RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Discounted price:",
                            style: GoogleFonts.poppins(
                                color: blueGrey,
                                fontWeight: FontWeight.normal,
                                fontSize: 11),
                          ),
                          TextSpan(
                            text:
                            " ${widget.product.discountedPrice ?? 0}",
                            style: GoogleFonts.poppins(
                                color: orange,
                                fontWeight: FontWeight.normal,
                                fontSize: 11),
                          )
                        ],
                      ),
                    ) : SizedBox(height: 0.0,width: 0.0,),
                    SizedBox(height: getProportionateScreenHeight(10.0),),
                    Align(
                        alignment: Alignment.centerRight,
                        child:
                        widget.product.errorType != null ? widget.product.errorType == STATUS_PRODUCT_UNAVAILABLE
                            ? Text(
                          "Product is not available kindly remove it",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                              fontSize: 08,
                              color: red,
                              fontWeight: FontWeight.w500),
                        )
                            : widget.product.errorType == STATUS_PRODUCT_INVALID_QUANTITY
                            ? Text(
                          "${widget.product.previousQuantity} items are not available, Kindly add the available stock",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                              fontSize: 08,
                              color: red,
                              fontWeight: FontWeight.w500),
                        )
                            : widget.product.errorType == STATUS_PRODUCT_OUT_OF_STOCK
                            ?Text(
                          "Product is out of stock kindly remove it",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                              fontSize: 08,
                              color: red,
                              fontWeight: FontWeight.w500),
                        )
                            : widget.product.errorType == STATUS_PRODUCT_PRICE_VALUE_CHANGED
                        ? Text(
                          "Price has been changed!",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                              fontSize: 08,
                              color: red,
                              fontWeight: FontWeight.w500),
                        )
                            : widget.product.errorType == STATUS_SHOP_CLOSED
                            ? Text(
                          "Shop has been Closed! Please remove items or wait for reopening",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                              fontSize: 08,
                              color: red,
                              fontWeight: FontWeight.w500),
                        )
                            :SizedBox(height: 0.0, width: 0.0,)
                            : SizedBox(height: 0.0, width: 0.0,)

                    ),
                    SizedBox(height: getProportionateScreenHeight(5.0),),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}