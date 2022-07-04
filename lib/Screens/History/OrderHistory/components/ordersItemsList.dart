
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Models/Order.dart';
import '../../../../SizeConfig.dart';
import '../../../../colors.dart';

class OrderItemsList extends StatefulWidget {
  final Order order;
  final Function refresh;

  const OrderItemsList({
    Key? key,
    required this.order, required this.refresh,
  }) : super(key: key);

  @override
  _OrderItemsListState createState() => _OrderItemsListState();
}
class _OrderItemsListState extends State<OrderItemsList> {

  double infoHeight =90;
  bool isInfoBoxOpen = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      shadowColor: Color(0xFF93A7BE).withOpacity(0.3),
      margin: EdgeInsets.symmetric(
          vertical: getProportionateScreenWidth(10.0)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            gradient: RadialGradient(
              radius: 1.0,
              center: Alignment(-0.6, -0.7),
              colors: const [
                Color(0xFFEFEFEF),
                Color(0xFFFFFFFF),
              ],
            ),
          ),
          child: AnimatedSize(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 500),
            child: SizedBox(
              width: double.infinity,
              height: infoHeight,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isInfoBoxOpen =  !isInfoBoxOpen;
                          if (isInfoBoxOpen) {
                            infoHeight =
                                getProportionateScreenHeight(
                                    310.0);
                          } else {
                            infoHeight =
                                getProportionateScreenHeight(
                                    90.0);
                          }
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                            getProportionateScreenWidth(
                                10.0),
                            vertical:
                            getProportionateScreenHeight(
                                10.0)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children:[
                                        Text(
                                          "Order ID: ",
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              color: blueGrey,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "${widget.order.orderId.toString()} ",
                                          textAlign: TextAlign.start,
                                          //overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              color: blueGrey,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ]
                                  ),
                                  !isInfoBoxOpen
                                      ? Icon(
                                    Icons
                                        .keyboard_arrow_down_rounded,
                                    color:
                                    blueGrey,
                                  )
                                      : Icon(
                                    Icons
                                        .keyboard_arrow_up_rounded,
                                    color:
                                    blueGrey,
                                  )
                                ]),
                            Row(
                              children: [
                                widget.order.business?.users?[0].imagePath == "" ? CircleAvatar(
                                  radius: getProportionateScreenWidth(20),
                                  backgroundImage:
                                  AssetImage("assets/Images/no_image.jpg"),
                                  backgroundColor: Colors.transparent,
                                ) :CircleAvatar(
                                  radius: getProportionateScreenWidth(20),
                                  backgroundImage:
                                  NetworkImage("${widget.order.business?.users?[0].imagePath}"),
                                  backgroundColor: Colors.transparent,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        children:[
                                          Text(
                                            widget.order.business?.users?[0].name?.firstName ?? " ",
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: blueGrey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(" "),
                                          Text(
                                            widget.order.business?.users?[0].name?.lastName ?? " ",
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: blueGrey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ]
                                    ),
                                    Text(
                                      widget.order.business?.businessInfo?.name ?? "",
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: orange,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(
                          horizontal:
                          getProportionateScreenWidth(
                              15.0)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: getProportionateScreenHeight(170),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.order.orderDetails?.productCartItems?.length,
                                itemBuilder: (context,index){
                                  var items = widget.order.orderDetails?.productCartItems?[index];
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Divider(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${index + 1}",style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: blueGrey,
                                              fontWeight: FontWeight.w700),),
                                          SizedBox(width: getProportionateScreenWidth(15),),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${items?.productName}",style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: blueGrey,
                                                    fontWeight: FontWeight.w600),),
                                                SizedBox(height: 10,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("Quantity",style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: black,
                                                        fontWeight: FontWeight.w700),),
                                                    Text("${items?.quantity}",style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      color: orange,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("Price",style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: black,
                                                        fontWeight: FontWeight.w700),),
                                                    Text("Rs. ${items?.price}",style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: orange,
                                                        fontWeight: FontWeight.w500,
                                                    ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("Discount",style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: black,
                                                        fontWeight: FontWeight.w700),),
                                                    Text("Rs. ${(items?.price)! - (items?.discountedPrice ?? items?.price)!}",
                                                      style: GoogleFonts.poppins(
                                                          fontSize: 12,
                                                          color: orange,
                                                          fontWeight: FontWeight.w500),),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("Total",style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: black,
                                                        fontWeight: FontWeight.w700),),
                                                    Text("Rs. ${items?.discountedPrice}",style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      color: orange,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  );
                                }),
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total',style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: orange,
                                  fontWeight: FontWeight.w500),),
                              Text(
                                "Rs. ${widget.order.orderDetails?.totalAmount.toString()}",
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: orange,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
