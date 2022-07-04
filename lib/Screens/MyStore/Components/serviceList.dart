import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tajammul_customer_app/Models/Service.dart';
import '../../../Services/loginUserCredentials.dart';
import '../../../SizeConfig.dart';
import '../../../UserConstant.dart';
import '../../../colors.dart';
import '../../../main.dart';

class ServiceItemsList extends StatefulWidget {
  final Service service;
  final VoidCallback refresh;
  final Function processing;
  final VoidCallback? onTap;

  const ServiceItemsList({
    Key? key,
    required this.service,
    required this.refresh,
    required this.processing,
    required this.onTap
  }) : super(key: key);

  @override
  _ProductItemsListState createState() => _ProductItemsListState();
}

class _ProductItemsListState extends State<ServiceItemsList> {
  LoginUserCredentials credentials = LoginUserCredentials();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.service.status);
    return AbsorbPointer(
      absorbing: (widget.service.status == STATUS_PRODUCT_AVAILABLE) ? false : true,
      child: Opacity(
        opacity: (widget.service.status == STATUS_PRODUCT_AVAILABLE) ? 1.0 : 0.3,
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
                        color: grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 0))
                  ],
                ),
                child: Column(
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
                            child: widget.service.discount!=null ? Text(
                          '${widget.service.discount}% Off',
                          style: GoogleFonts.poppins(fontSize: 10, color: white),
                        ) : Text(
                              '0% Off',
                              style: GoogleFonts.poppins(fontSize: 10, color: white),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(140),
                      height: getProportionateScreenHeight(130),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child:(widget.service.listImagePath !=null && (widget.service.listImagePath!.isNotEmpty))
                            ? CachedNetworkImage(
                          imageUrl: "${env.config?.imageUrl}${(widget.service.listImagePath![0])}",
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
                                  '${widget.service.serviceName}',
                                  style: GoogleFonts.poppins(
                                      color: blueGrey, fontWeight: FontWeight.bold),
                                ),
                                widget.service.description != null ? Text(
                                  '${widget.service.description}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: GoogleFonts.poppins(
                                      fontSize: 10, color: blueGrey),
                                ) : Container(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: (widget.service.discountedPrice == null || widget.service.discountedPrice == 0) ? Text(
                        'Rs ${widget.service.price}',
                        style: GoogleFonts.poppins(
                          color: orange
                        ),
                      ): Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rs ${widget.service.discountedPrice}',
                                  style: GoogleFonts.poppins(color: orange)),
                          SizedBox(
                            width: getProportionateScreenWidth(4),
                          ),
                          Text(
                                  'Rs ${widget.service.price}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                )
                        ],
                      ),
                    ),
                    Padding(
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
                            boxShadow: [
                              BoxShadow(
                                  color: grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(-2, -2))
                            ]),
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: white,
                            size: 18,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
