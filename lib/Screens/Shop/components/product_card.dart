import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tajammul_customer_app/Models/HiveProduct.dart';
import 'package:tajammul_customer_app/Models/Product.dart';
import 'package:tajammul_customer_app/Services/HiveServices.dart';
import 'package:tajammul_customer_app/SizeConfig.dart';
import 'package:tajammul_customer_app/colors.dart';

class ProductCard extends StatefulWidget {
  final Product? product;
  final VoidCallback? add;
  final Function? subtract;
  final Function? addQuantity;
  final bool? isPresent;

  const ProductCard(
      {Key? key, this.product, this.add, this.isPresent, this.subtract,this.addQuantity})
      : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isPresent = false;
  Box<HiveProduct>? dataBox;

  @override
  void initState() {
    dataBox = Hive.box<HiveProduct>('cart');


    super.initState();
  }

/*  getQuantity(Product product){
    int? quantity =0;
    HiveProduct? hp;
    hp=dataBox?.getAt(0);
    for(var i in hp!.cartData!){
      if(i.productName == product.productName){
        quantity = i.quantity;
        break;
      }
    }
    return quantity;
  }*/

  @override
  Widget build(BuildContext context) {
    HiveProduct? hp;
    hp=dataBox?.getAt(0);
    for(var i in hp!.cartData!){
      if(i.productName == widget.product?.productName){
        isPresent = true;
      }
    }
    return ValueListenableBuilder(
        valueListenable: dataBox!.listenable(),
        builder: (context, Box<HiveProduct> items, _) {
          return Stack(
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
                                  '${widget.product!.discount}% Off',
                                  style: GoogleFonts.poppins(fontSize: 10, color: white),
                                )),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: getProportionateScreenWidth(140),
                          height: getProportionateScreenHeight(130),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: widget.product!.imagePaths![0] == null
                                ? Image(
                              image: AssetImage(
                                'assets/Images/no_image.jpg',
                              ),
                              fit: BoxFit.cover,
                            )
                                : Image(
                              image: NetworkImage(
                                '${widget.product!.imagePaths}',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
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
                            style: GoogleFonts.poppins(color: blueGrey, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              isPresent
                  ?Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Container(
                    padding: EdgeInsets.all(5),
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
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              if(HiveServices.getQuantity(widget.product!,items)==1){
                                setState(() {
                                  isPresent = false;
                                });
                              }

                              widget.subtract!();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              height:
                              getProportionateScreenHeight(30),
                              width: getProportionateScreenWidth(30),
                              child: SvgPicture.asset(
                                  'assets/Icons/remove.svg',
                                  width: 10),
                            )),
                        Text(
                          HiveServices.getQuantity(widget.product!,items).toString(),
                          style: GoogleFonts.poppins(
                              color: white,
                              fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                            onTap: () {
                              widget.addQuantity!();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              height:
                              getProportionateScreenHeight(30),
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
                          Text('Rs ${widget.product!.discountedPrice}',
                              style: GoogleFonts.poppins(color: orange)),
                          SizedBox(
                            width: getProportionateScreenWidth(4),
                          ),
                          widget.product!.price == 0
                              ? Container()
                              : Text('Rs ${widget.product!.price}',
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              ))
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        widget.add!();
                        //cartProvider.addProductCount(widget.productData!.quantity!);
                        //Provider.of<CartProvider>(context, listen: false).addProductCount(widget.productData!.quantity!);
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
              ),
            ],
          );
        });
  }
}
