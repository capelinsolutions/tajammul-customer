import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:tajammul_customer_app/Components/ViewYourCartButton.dart';
import 'package:tajammul_customer_app/Models/Business.dart';
import 'package:tajammul_customer_app/Models/CartProduct.dart';
import 'package:tajammul_customer_app/Models/HiveProduct.dart';
import 'package:tajammul_customer_app/Providers/userProvider.dart';
import 'package:tajammul_customer_app/Screens/Shop/components/shop_card.dart';
import 'package:tajammul_customer_app/Screens/Shop/screens/product_details.dart';
import 'package:tajammul_customer_app/Services/HiveServices.dart';
import 'package:tajammul_customer_app/colors.dart';

import '../../../../Components/CustomSearchTextField.dart';
import '../../../../SizeConfig.dart';
import '../../Components/CustomDialog.dart';
import '../../Components/Loader.dart';
import '../../Models/Debouncer.dart';
import '../../Models/FavouriteProducts.dart';
import '../../Models/Product.dart';
import '../../Models/SearchProducts.dart';
import '../../Services/ApiCalls.dart';
import '../../Services/loginUserCredentials.dart';
import '../../UserConstant.dart';
import '../../main.dart';
import '../MyStore/Components/productList.dart';

class Body extends StatefulWidget {
  final Business? business;

  const Body({Key? key, this.business}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  final shopSearchController = TextEditingController();
  bool processing = false;
  bool _isSearching = false;
  bool expansion = false;
  List<String> _getCategoriesList = [];
  List<Product> _productList = [];
  List<SearchProducts> _searchProductList = [];
  TabController? _tabController;
  final LoginUserCredentials _credentials = LoginUserCredentials();
  String? _currentCategory;
  int _selectedIndex = 0;
  final _debouncer = Debouncer(milliseconds: 1000);
  int noOfElements = 10;
  int pageNo = 0;
  int _totalPages = 0;
  AnimationController? _controller;
  Animation<Offset>? offset;
  String _snackMessage = "";
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();
  bool isLiked = true;
  List<FavouriteProducts> favList = [];
  bool isUpdate = false;
  Box<HiveProduct>? dataBox;
  bool isExpanded = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    getMyCategories();
    dataBox = Hive.box<HiveProduct>('cart');
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    offset = Tween<Offset>(
            begin: const Offset(0.0, -2.0), end: const Offset(0.0, 0.0))
        .animate(_controller!);
    super.initState();
  }

  getProductWishList() async {
    Map<String, String>? result = await ApiCalls.getProductWishList(context.read<UserProvider>().users.userId!);
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
    setState(() {
      processing = false;
    });
  }

  getMyCategories() async {
      setState(() {
        processing = true;
      });
      Map<String, List<String>?>? result = await ApiCalls.getCategoriesByBusiness(widget.business!.businessId!);
      if (result?["error"] == null) {
        setState(() {
          _getCategoriesList = (result?["success"])!;
        });
        if (_getCategoriesList.isNotEmpty) {
          setState((){
            _tabController = TabController(length: _getCategoriesList.length, vsync: this);
            _currentCategory = _getCategoriesList[_selectedIndex];
          });
          getProductsByCategoryInBusiness(_getCategoriesList[_selectedIndex], pageNo);
        }
      } else if (result?["error"]?[0] == "Session Expired") {
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
          getMyCategories();
        });
      } else {
        Fluttertoast.showToast(
            msg: (result?["error"]?[0])!,
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

  getProductsByCategoryInBusiness(String categoryName, int pageNo) async {
    Map<String, String>? result =
        await ApiCalls.getProductsByCategoryInBusiness(
            widget.business!.businessId!, categoryName, pageNo, noOfElements);
    if (result?["error"] == null) {
      setState(() {
        _productList = productFromJson((result?["success"])!);
        _totalPages = int.parse((result?["totalPages"])!);
        this.pageNo++;
      });
      getProductWishList();
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
        getProductsByCategoryInBusiness(categoryName, pageNo);
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

  getLoadMoreProductsByCategoryInBusiness(String categoryName, int pageNo) async {
    Map<String, String>? result =
        await ApiCalls.getProductsByCategoryInBusiness(
            widget.business!.businessId!, categoryName, pageNo, noOfElements);
    if (result?["error"] == null) {
      setState(() {
        _productList.addAll(productFromJson((result?["success"])!));
        _totalPages = int.parse((result?["totalPages"])!);
        this.pageNo++;
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
        getLoadMoreProductsByCategoryInBusiness(categoryName, pageNo);
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

  getSearchProductsInBusiness(String productName) async {
    setState(() {
      processing = true;
    });
    Map<String, String>? result = await ApiCalls.getSearchProductsInBusiness(
        widget.business!.businessId!, productName);
    if (result?["error"] == null) {
      setState(() {
        _searchProductList = searchProductsFromJson((result?["success"])!);
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
        getSearchProductsInBusiness(productName);
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

  //reset
  reset() {
    setState(() {
      _selectedIndex = 0;
      pageNo = 0;
      _totalPages = 0;
      _getCategoriesList = [];
      _productList = [];
      _currentCategory = "";
      _searchProductList = [];
      _tabController = TabController(length: 0, vsync: this);
    });
  }

  void expandedCall() {
    setState((){
      isExpanded= true;
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeOut,);
    });
  }

  void contractedCall() {
    setState((){
      isExpanded= false;
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeOut,);
    });
  }

  //print snack message
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

  getCartTray() {
    setState(() {
      key.currentState?.expand();
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        key.currentState?.contract();
      });
    });
  }

  @override
  void dispose() {
    shopSearchController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dataBox!.listenable(),
      builder: (context, Box<HiveProduct> items, _){
        return ExpandableBottomSheet(
          onIsContractedCallback: () {
            contractedCall();
          },
          onIsExtendedCallback: () {
            expandedCall();
          },
          persistentHeader: items.getAt(0)!.cartData!.isNotEmpty
              ? Container(
            height: getProportionateScreenHeight(30),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              color: backgroundColor,
            ),
            child: Container(

              height: getProportionateScreenHeight(50),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Color(0xFFEFEFEF), width: 0.1),
                gradient: RadialGradient(
                  radius: 1.0,
                  center: Alignment(-0.6, -0.7),
                  colors: const [
                    Color(0xFFF5F5F5),
                    Color(0xFFFFFFFF),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: grey.withOpacity(0.2),
                    spreadRadius: 4,
                    blurRadius: 8,
                    offset: Offset(0, -15),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(15),
                  ),
                  SvgPicture.asset('assets/Icons/Home Indicator.svg'),
                ],
              ),
            ),
          )
              : Container(),
          animationDurationExtend: Duration(milliseconds: 500),
          animationDurationContract: Duration(milliseconds: 250),
          animationCurveExpand: Curves.bounceOut,
          animationCurveContract: Curves.ease,
          expandableContent: items.getAt(0)!.cartData!.isNotEmpty
              ? Container(
            height: getProportionateScreenHeight(80),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              color: backgroundColor,
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Container(
                height: getProportionateScreenHeight(80),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Color(0xFFEFEFEF), width: 0.1),
                  gradient: RadialGradient(
                    radius: 1.0,
                    center: Alignment(-0.6, -0.7),
                    colors: const [
                      Color(0xFFF5F5F5),
                      Color(0xFFFFFFFF),
                    ],
                  ),
                ),
                child: SizedBox(
                  height: getProportionateScreenHeight(60),
                  child: ViewYourCartButton(),
                ),
              ),
            ),
          )
              : SizedBox(height: 0.0,width: 0.0,),
          background: Stack(
            children: [
              AbsorbPointer(
                absorbing: processing,
                child: Opacity(
                  opacity: processing? 0.3 :1.0,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        height: getProportionateScreenHeight(200),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0xFFEFEFEF), width: 0.1),
                          boxShadow: const [
                            BoxShadow(
                              color: grey,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          child: (widget.business?.businessInfo?.listImagePath !=null && (widget.business?.businessInfo?.listImagePath?.isNotEmpty)!)
                              ? CachedNetworkImage(
                            imageUrl: "${env.config?.imageUrl}${(widget.business!.businessInfo!.listImagePath![0])}",
                            fit: BoxFit.fill,
                          )
                              :Image.asset(
                            "assets/Images/background_pic_image",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                        top: getProportionateScreenHeight(50),
                        left: getProportionateScreenWidth(15),
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: getProportionateScreenHeight(30),
                            width: getProportionateScreenWidth(30),
                            decoration: BoxDecoration(
                                color: yellowOpacity, shape: BoxShape.circle),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/Icons/back_arrow.svg",
                                width: 8,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: getProportionateScreenHeight(120),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(35),
                            width: getProportionateScreenWidth(270),
                            child: CustomSearchTextField(
                              controller: shopSearchController,
                              label: 'Search by Products',
                              onFieldSubmitted: (value){
                                setState(() {
                                  contractedCall();
                                });
                              },
                              onChanged: (value) {
                                reset();
                                if (value != "") {
                                  _debouncer.run(() {
                                    getSearchProductsInBusiness(value);
                                  });
                                  setState(() {
                                    _isSearching = true;
                                  });
                                } else {
                                  setState(() {
                                    reset();
                                    _isSearching = false;
                                  });
                                  getMyCategories();
                                }
                              },
                              onTap: (){
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                          SizedBox(
                            width: getProportionateScreenWidth(270),
                            child: ShopCard(
                              business: widget.business,
                            ),
                          ),
                          !_isSearching
                              ? SizedBox(
                            height: getProportionateScreenHeight(10),
                          )
                              : SizedBox(
                            width: 0.0,
                            height: 0.0,
                          ),
                          !_isSearching
                              ? TabBar(
                            tabs: [
                              for (int i = 0; i < _getCategoriesList.length; i++)
                                SizedBox(
                                  height:
                                  getProportionateScreenHeight(22.0),
                                  child: Tab(
                                    iconMargin: EdgeInsets.all(0.0),
                                    text: _getCategoriesList[i],
                                  ),
                                ),
                            ],
                            labelColor: blueGrey,
                            unselectedLabelColor: blueGrey,
                            labelStyle: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            unselectedLabelStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                color: blueGrey,
                                fontWeight: FontWeight.normal),
                            indicatorSize: TabBarIndicatorSize.label,
                            labelPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 0.0),
                            padding: EdgeInsets.all(0.0),
                            indicatorWeight: 3.0,
                            overlayColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                            indicatorPadding: EdgeInsets.all(0.0),
                            isScrollable: true,
                            indicatorColor: yellow,
                            automaticIndicatorColorAdjustment: false,
                            controller: _tabController,
                            onTap: (value) {
                              _selectedIndex = value;
                              _currentCategory = _getCategoriesList[value];
                              pageNo = 0;
                              _totalPages = 0;
                              getProductsByCategoryInBusiness(_currentCategory!, pageNo);
                              getProductWishList();
                              isUpdate = false;
                            },
                          )
                              : SizedBox(
                            width: 0.0,
                            height: 0.0,
                          ),
                          !_isSearching
                              ? (_getCategoriesList.isEmpty || _productList.isEmpty) ? SizedBox(
                            height: getProportionateScreenHeight(300),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/Icons/search_icon.svg",
                                  color: blueGrey,
                                  width: 20.0,
                                ),
                                SizedBox(
                                  height:
                                  getProportionateScreenHeight(20.0),
                                ),
                                Text(
                                  "This category have no products yet",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: blueGrey,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "It will soon to be uploaded",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: blueGrey.withOpacity(0.5),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ) :Expanded(
                            child: GestureDetector(
                              onHorizontalDragEnd: (DragEndDetails details) {
                                if (details.velocity.pixelsPerSecond.dx < 0.0) {
                                  if (_selectedIndex < _getCategoriesList.length - 1) {
                                    _selectedIndex = _selectedIndex + 1;
                                    pageNo = 0;
                                    _totalPages = 0;
                                    _currentCategory = _getCategoriesList[_selectedIndex];
                                    HiveServices.setCategory(_currentCategory!, items);
                                    getProductsByCategoryInBusiness(_currentCategory!, pageNo);
                                    _tabController?.animateTo(_selectedIndex);
                                    getProductWishList();
                                    isUpdate = false;
                                  }
                                } else {
                                  if (_selectedIndex > 0) {
                                    _selectedIndex = _selectedIndex - 1;
                                    pageNo = 0;
                                    _totalPages = 0;
                                    _currentCategory = _getCategoriesList[_selectedIndex];
                                    HiveServices.setCategory(_currentCategory!, items);
                                    getProductsByCategoryInBusiness(_currentCategory!, pageNo);
                                    _tabController?.animateTo(_selectedIndex);
                                    getProductWishList();
                                    isUpdate = false;
                                  }
                                }
                              },
                              child: LazyLoadScrollView(
                                scrollOffset: 100,
                                scrollDirection: Axis.vertical,
                                onEndOfPage: () {
                                  if (pageNo < _totalPages) {
                                    getLoadMoreProductsByCategoryInBusiness(_currentCategory!, pageNo);
                                  }
                                },
                                child: GridView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                    top: 10,
                                    right: 15,
                                    bottom: 10,
                                  ),
                                  shrinkWrap: true,
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1 / 1.6,
                                    mainAxisSpacing: 15,
                                    crossAxisSpacing: 10,
                                  ),
                                  itemCount: _productList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(product: _productList[index],business: widget.business,)));
                                        HiveServices.setCategory(_currentCategory!, items);
                                      },
                                      child: ProductItemsList(
                                        product: _productList[index],
                                        business: widget.business!,
                                        favList: favList,
                                        isUpdate: isUpdate,
                                        categoryName: _currentCategory!,
                                        refresh: () {
                                          pageNo = 0;
                                          getProductsByCategoryInBusiness(_currentCategory!, pageNo);
                                          HiveServices.setCategory(_currentCategory!, items);
                                        },
                                        processing: (value) {
                                          setState(() {
                                            processing = value;
                                          });
                                        },
                                        add: () {
                                          List<CartProduct>? cartList = items.getAt(0)?.cartData;
                                          bool isFound = false;
                                          int? cartItemIndex;
                                          int? quantity;
                                          if(cartList!.isEmpty){
                                            HiveServices.setBusiness(widget.business!, items);
                                          }
                                          if(items.getAt(0)?.business!.businessId == widget.business!.businessId) {
                                            for (int i = 0; i < cartList.length; i++) {
                                              if (cartList[i].productName == _productList[index].productName) {
                                                cartItemIndex = i;
                                                quantity = cartList[i].quantity;
                                                isFound = true;
                                                break;
                                              }
                                            }
                                            if (_productList[index].status == STATUS_PRODUCT_AVAILABLE) {
                                              if ((_productList[index].quantity)! > 0) {
                                                if (!isFound) {
                                                  CartProduct cartProduct = CartProduct(
                                                      price: _productList[index]
                                                          .price,
                                                      productName: _productList[index]
                                                          .productName,
                                                      discount: _productList[index]
                                                          .discount,
                                                      discountedPrice: _productList[index]
                                                          .discountedPrice,
                                                      listImagePath: _productList[index].listImagePath,
                                                      updatedStock: _productList[index]
                                                          .quantity,
                                                      quantity: 1);
                                                  HiveServices.setCategory(_currentCategory!, items);
                                                  HiveServices.addProduct(cartProduct, _currentCategory!,items);
                                                  HiveServices.addCategory(_currentCategory!,items);
                                                  getCartTray();
                                                } else {
                                                  if (quantity! <= (_productList[index].quantity)!) {
                                                    HiveServices.addQuantity(cartItemIndex!, items);
                                                    HiveServices.setCategory(_currentCategory!, items);
                                                    HiveServices.addCategory(_currentCategory!, items);
                                                    getCartTray();
                                                  } else {
                                                    displaySnackMessage(
                                                        "You can't add more");
                                                  }
                                                }
                                                setState(() {
                                                  expansion = true;
                                                });
                                              } else {
                                                displaySnackMessage(
                                                    "Product is out of stock");
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
                                        addQuantity: () {
                                          int? cartItemIndex;
                                          for (int i = 0; i < items.getAt(0)!.cartData!.length; i++) {
                                            if (items.getAt(0)!.cartData![i].productName == _productList[index].productName) {
                                              cartItemIndex = i;
                                              break;
                                            }
                                          }
                                          if ((items.getAt(0)!.cartData?[cartItemIndex!].quantity)! < (items.getAt(0)!.cartData?[cartItemIndex!].updatedStock)!) {
                                            HiveServices.addQuantity(cartItemIndex!, items);
                                            getCartTray();
                                          } else {
                                            displaySnackMessage(
                                                "You can't add more");
                                          }
                                        },
                                        subtract: () {
                                          int? cartItemIndex;
                                          for (int i = 0; i < items.getAt(0)!.cartData!.length; i++) {
                                            if (items.getAt(0)!.cartData![i].productName == _productList[index].productName) {
                                              cartItemIndex = i;
                                              break;
                                            }
                                          }
                                          if ((items.getAt(0)!.cartData?[cartItemIndex!].quantity)! <= (items.getAt(0)!.cartData?[cartItemIndex!].updatedStock)!) {
                                            HiveServices.setCategory(_currentCategory!, items);
                                            HiveServices.subtractQuantity(cartItemIndex!, _currentCategory!, items);
                                          } else {
                                            displaySnackMessage("You can't add more");
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                              : _searchProductList.isEmpty ? SizedBox(
                            height: getProportionateScreenHeight(300),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/Icons/search_icon.svg",
                                  color: blueGrey,
                                  width: 20.0,
                                ),
                                SizedBox(
                                  height:
                                  getProportionateScreenHeight(20.0),
                                ),
                                Text(
                                  "This category have no products yet",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: blueGrey,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "It will soon to be uploaded",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: blueGrey.withOpacity(0.5),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ) :Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _searchProductList.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder:
                                    (BuildContext context, int upperIndex) {
                                  return GridView.builder(
                                      controller: _scrollController,
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        bottom: 10,
                                      ),
                                      shrinkWrap: true,
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 1 / 1.55,
                                        mainAxisSpacing: 15,
                                        crossAxisSpacing: 10,
                                      ),
                                      scrollDirection: Axis.vertical,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: _searchProductList[upperIndex].products?.length,
                                      itemBuilder: (BuildContext context,
                                          int lowerIndex) {
                                        return InkWell(
                                          onTap: (){
                                            FocusScope.of(context).unfocus();
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(product: _searchProductList[upperIndex].products![lowerIndex],business: widget.business,)));
                                          },
                                          child: ProductItemsList(
                                            favList: favList,
                                            business: widget.business!,
                                            isUpdate: isUpdate,
                                            product: _searchProductList[upperIndex].products![lowerIndex],
                                            categoryName: _searchProductList[upperIndex].category!.categoryName!,
                                            refresh: () {
                                              getSearchProductsInBusiness(shopSearchController.text);
                                            },
                                            processing: (value) {
                                              setState(() {
                                                processing = value;
                                              });
                                            },
                                            add: () {
                                              List<CartProduct>? cartList = items.getAt(0)!.cartData;
                                              bool isFound = false;
                                              int? cartItemIndex;
                                              int? quantity;
                                              for (int i = 0; i < cartList!.length; i++) {
                                                if (cartList[i].productName == _searchProductList[upperIndex].products![lowerIndex].productName) {
                                                  cartItemIndex = i;
                                                  quantity = cartList[i].quantity;
                                                  isFound = true;
                                                  break;
                                                }
                                              }
                                              if (_searchProductList[upperIndex].products![lowerIndex].status == STATUS_PRODUCT_AVAILABLE) {
                                                if (!isFound) {
                                                  if ((_searchProductList[upperIndex].products![lowerIndex].quantity)! > 0) {
                                                    CartProduct cartProduct = CartProduct(
                                                        price: _searchProductList[upperIndex].products![lowerIndex].price,
                                                        productName: _searchProductList[upperIndex].products![lowerIndex].productName,
                                                        discount: _searchProductList[upperIndex].products![lowerIndex].discount,
                                                        discountedPrice: _searchProductList[upperIndex].products![lowerIndex].discountedPrice,
                                                        imagePaths: _searchProductList[upperIndex].products![lowerIndex].imagePaths,
                                                        updatedStock: _searchProductList[upperIndex].products![lowerIndex].quantity,
                                                        quantity: 1);
                                                    HiveServices.setCategory(_currentCategory!, items);
                                                    HiveServices.addProduct(cartProduct, _currentCategory!,items);
                                                    HiveServices.addCategory(_currentCategory!,items);
                                                    getCartTray();
                                                  } else {
                                                    displaySnackMessage(
                                                        "Product is out of stock");
                                                  }
                                                } else {
                                                  if (quantity! < (_searchProductList[upperIndex].products![lowerIndex].quantity)!) {
                                                    HiveServices.addQuantity(cartItemIndex!, items);
                                                    HiveServices.setCategory(_currentCategory!, items);
                                                    HiveServices.addCategory(_currentCategory!, items);
                                                    getCartTray();
                                                  } else {
                                                    displaySnackMessage(
                                                        "You can't add more");
                                                  }
                                                }
                                              } else {
                                                displaySnackMessage(
                                                    "You Can't Add Unavailable Product");
                                              }
                                              setState(() {
                                                expansion = true;
                                              });
                                            },
                                            addQuantity: () {
                                              int? cartItemIndex;
                                              for (int i = 0; i < items.getAt(0)!.cartData!.length; i++) {
                                                if (items.getAt(0)!.cartData![i].productName == _searchProductList[upperIndex].products![lowerIndex].productName) {
                                                  cartItemIndex = i;
                                                  break;
                                                }
                                              }
                                              if ((items.getAt(0)!.cartData?[cartItemIndex!].quantity)! < (items.getAt(0)!.cartData?[cartItemIndex!].updatedStock)!) {
                                                HiveServices.addQuantity(cartItemIndex!, items);
                                                getCartTray();
                                              } else {
                                                displaySnackMessage(
                                                    "You can't add more");
                                              }
                                            },
                                            subtract: () {
                                              int? cartItemIndex;
                                              for (int i = 0; i < items.getAt(0)!.cartData!.length; i++) {
                                                if (items.getAt(0)!.cartData![i].productName == _searchProductList[upperIndex].products![lowerIndex].productName) {
                                                  cartItemIndex = i;
                                                  break;
                                                }
                                              }
                                              if ((items.getAt(0)!.cartData?[cartItemIndex!].quantity)! < (items.getAt(0)!.cartData?[cartItemIndex!].updatedStock)!) {
                                                HiveServices.setCategory(_currentCategory!, items);
                                                HiveServices.subtractQuantity(cartItemIndex!, _currentCategory!, items);
                                              } else {
                                                displaySnackMessage(
                                                    "You can't add more");
                                              }
                                            },
                                          ),
                                        );
                                      });
                                }),
                          ),
                          isExpanded? SizedBox(height: getProportionateScreenHeight(80),) : SizedBox(height: 0.0,width: 0.0,),
                          items.getAt(0)!.cartData!.isNotEmpty
                              ? SizedBox(
                            height: getProportionateScreenHeight(30),
                          )
                              : Container()
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              processing ? Loader(color: orange) : SizedBox(width: 0.0, height: 0.0),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SlideTransition(
                      position: offset!,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: getProportionateScreenHeight(10.0),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
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
          ),
        );},
    );
  }
}
