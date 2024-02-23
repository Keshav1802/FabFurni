import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:keshav_s_application2/presentation/cart_screen/cart_screen.dart';
import 'package:keshav_s_application2/presentation/filter_screen/filter_screen.dart';
import 'package:keshav_s_application2/presentation/product_detail_screen/QuantityBottomSheet.dart';
import 'package:keshav_s_application2/presentation/product_detail_screen/models/AddWishlist.dart';
import 'package:keshav_s_application2/presentation/product_detail_screen/models/AddtoCart.dart';
import 'package:keshav_s_application2/presentation/product_detail_screen/product_detail_screen.dart';
import 'package:keshav_s_application2/presentation/search_screen/search_screen.dart';
import 'package:keshav_s_application2/presentation/select_product_screen/models/ProductList.dart' as products;
import 'package:keshav_s_application2/presentation/sort_by_bottomsheet/controller/sort_by_controller.dart';
import 'package:keshav_s_application2/presentation/sort_by_bottomsheet/sort_by_bottomsheet.dart';
import 'package:keshav_s_application2/presentation/store_screen/models/StoreModel.dart';
import 'package:keshav_s_application2/presentation/whislist_screen/whislist_screen.dart';
import 'package:keshav_s_application2/screenwithoutlogin/productdetailscreen1.dart';
import 'package:keshav_s_application2/screenwithoutlogin/searchscreen1.dart';
import 'package:light_modal_bottom_sheet/light_modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../core/utils/appConstant.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:keshav_s_application2/core/app_export.dart';
import 'package:keshav_s_application2/widgets/app_bar/appbar_image.dart';
import 'package:keshav_s_application2/widgets/app_bar/appbar_subtitle_5.dart';
import 'package:keshav_s_application2/widgets/app_bar/appbar_subtitle_6.dart';
import 'package:keshav_s_application2/widgets/app_bar/custom_app_bar.dart';

import 'dart:convert';

import 'package:dio/dio.dart' as dio;

import '../presentation/log_in_screen/log_in_screen.dart';

class productlisrafterclickonbanner1 extends StatefulWidget {
  // Data data;
  // StoreData category;
  String keyword_id;
  String categoryId;
  String subCategoryId;
  String brandId;

  productlisrafterclickonbanner1(this.keyword_id,this.categoryId,this.subCategoryId,this.brandId);
  @override
  State<productlisrafterclickonbanner1> createState() => _productlisrafterclickonbanner1State();
}

class _productlisrafterclickonbanner1State extends State<productlisrafterclickonbanner1> {

  Future<products.ProductList> ?product;
  List<products.ProductListData> productlist = [];
  var sortBy = '';
  final ScrollController _controller = ScrollController();
  /*Filter*/
  String selectedItemFilterSize = '';
  var selectedPaymentMethod;
  final List<String> filterSortByItem = [
    'High to Low',
    'Low to High',
    'A to Z',
    'Z to A',
    'Newest First',
    'Oldest First',
  ];

  //double _startValue = 0.0;
  //double _endValue = 500.0;
  RangeValues _currentRangeValues = const RangeValues(1, 10000);
  String sort_column = "";
  String sort_order = "";
  String setPriceMinValue = "", setPriceMaxValue = "";
  Future<products.ProductList> getProduct() async {
    Map data = {
      // 'user_id': widget.data.id,
      "category_id":widget.categoryId,
      "sub_category_id":widget.subCategoryId,
      "keyword_id":widget.keyword_id,
      "brand_id":widget.brandId,
      "city_id":"",
      "sort":sortBy
    };
    //encode Map to JSON
    print('REQ --> '+json.encode(data).toString());
    var body = json.encode(data);
    var response =
    await dio.Dio().post("https://fabfurni.com/api/Webservice/productList",
        options: dio.Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "*/*",
          },
        ),
        data: body);
    var jsonObject = jsonDecode(response.toString());
    if (response.statusCode == 200) {
      print(jsonObject);

      if (products.ProductList.fromJson(jsonObject).status == "true") {
        // print(orders.MyOrdersModel.fromJson(jsonObject).data.first.products.first.image);

        return products.ProductList.fromJson(jsonObject);

        // inviteList.sort((a, b) => a.id.compareTo(b.id));
      }else if (products.ProductList.fromJson(jsonObject).status == "false") {
        Fluttertoast.showToast(
            msg: products.ProductList.fromJson(jsonObject).message!.capitalizeFirst!,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.redAccent,
            textColor: Colors.black,
            fontSize: 14.0);
        setState(() {
          productlist.clear();
        });
        /*Timer(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });*/

      }
      else if(products.ProductList.fromJson(jsonObject).data == null){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            jsonObject['message'] + ' Please check after sometime.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ));
      }
      else {
        throw Exception('Failed to load');
      }
    } else {
      throw Exception('Failed to load');
    }
    return jsonObject;
  }

  @override
  void initState() {
    clearFilter();
    product = getProduct();
    product!.then((value) {
      setState(() {
        productlist = value.data!;
      });
    });

    super.initState();
  }

  void clearFilter(){
    AppConstant.selectedIndex= 0;
    AppConstant.selectedIndexCategory = -1;
    AppConstant.selectedIndexCategoryId = '';

    AppConstant.selectedIndexSubCategory = -1;
    AppConstant.selectedIndexSubCategoryId = '';

    AppConstant.selectedIndexKeyword = -1;
    AppConstant.selectedIndexKeywordId = '';

    AppConstant.selectedIndexBrand = -1;
    AppConstant.selectedIndexBrandId = '';
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            appBar: CustomAppBar(
                height: getVerticalSize(90),
                leadingWidth: 41,
                leading: AppbarImage(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    height: getVerticalSize(15),
                    width: getHorizontalSize(9),
                    svgPath: ImageConstant.imgArrowleft,
                    margin: getMargin(left: 20, top: 34, bottom: 42)),
                // title: AppbarSubtitle2(
                //     text: widget.category_name,
                //     margin: getMargin(left: 19, top: 34, bottom: 42)),
                // AppbarImage(
                //     height: getVerticalSize(32),
                //     width: getHorizontalSize(106),
                //     imagePath: ImageConstant.imgFinallogo03,
                //     margin: getMargin(left: 13, top: 44, bottom: 15)),
                actions: [
                  AppbarImage(
                      height: getSize(21),
                      width: getSize(21),
                      svgPath: ImageConstant.imgSearch,
                      margin:
                      getMargin(left: 12, top: 0, right: 10, bottom: 10),
                      onTap: (){
                        //Get.toNamed(AppRoutes.searchScreen);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchScreen1(widget.keyword_id),
                        ));
                      }),
                  Container(
                      height: getVerticalSize(23),
                      width: getHorizontalSize(27),
                      margin:
                      getMargin(left: 20, top: 0, right: 10, bottom: 15),
                      child: Stack(alignment: Alignment.topRight, children: [
                        AppbarImage(
                            height: getVerticalSize(21),
                            width: getHorizontalSize(21),
                            svgPath: ImageConstant.imgLocation,
                            margin: getMargin(top: 5, right: 6),
                            onTap: (){
                              pushNewScreen(
                                context,
                                screen: LogInScreen(),
                                withNavBar:
                                false, // OPTIONAL VALUE. True by default.
                                pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                              );
                              // Navigator.of(context).pushReplacement(MaterialPageRoute(
                              //   builder: (context) => LogInScreen(),
                              // ));
                              // pushNewScreen(
                              //   context,
                              //   screen: WhislistScreen(widget.data),
                              //   withNavBar:
                              //   false, // OPTIONAL VALUE. True by default.
                              //   pageTransitionAnimation:
                              //   PageTransitionAnimation.cupertino,
                              // );
                            }),
                        // AppbarSubtitle6(
                        //     text: "lbl_2".tr,
                        //     margin: getMargin(left: 17, bottom: 13))
                      ])),
                  Container(
                      height: getVerticalSize(24),
                      width: getHorizontalSize(29),
                      margin: getMargin(left: 14, top: 0, right: 31,bottom: 15),
                      child: Stack(alignment: Alignment.topRight, children: [
                        AppbarImage(
                            onTap: () {
                              pushNewScreen(
                                context,
                                screen: LogInScreen(),
                                withNavBar:
                                false, // OPTIONAL VALUE. True by default.
                                pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                              );
                              // Navigator.of(context).pushReplacement(MaterialPageRoute(
                              //   builder: (context) => LogInScreen(),
                              // ));
                              // pushNewScreen(
                              //   context,
                              //   screen: CartScreen(widget.data),
                              //   withNavBar:
                              //   false, // OPTIONAL VALUE. True by default.
                              //   pageTransitionAnimation:
                              //   PageTransitionAnimation.cupertino,
                              // );
                              // Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) => CartScreen(widget.data),
                              // ));
                            },
                            height: getVerticalSize(20),
                            width: getHorizontalSize(23),
                            svgPath: ImageConstant.imgCart,
                            margin: getMargin(top: 4, right: 6)),
                        // AppbarSubtitle6(
                        //     text: CartScreen.count.toString(),
                        //     margin: getMargin(left: 17, bottom: 13))
                      ]))
                ],
                styleType: Style.bgShadowBlack90033),
            body: RefreshIndicator(
              color: Colors.purple,
              onRefresh: ()async{
                product = getProduct();
                product!.then((value) {
                  setState(() {
                    productlist = value.data!;
                  });
                });
              },
              child: Column(
                children: [
                  Container(
                      width: Get.width,
                      decoration: AppDecoration.outlineBlack9003f,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: (){
                                _showsortbyBottomSheet(context);
                              },
                              child: Container(
                                width: Get.width/2.1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomImageView(
                                        svgPath: ImageConstant.imgVectorBlack900,
                                        height: getVerticalSize(16),
                                        width: getHorizontalSize(12),
                                        margin: getMargin(
                                            left: 2, top: 13, bottom: 12)),
                                    Padding(
                                        padding: getPadding(
                                            left: 17, top: 12, bottom: 11),
                                        child: Text("lbl_sort".tr,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtRobotoMedium14)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                                height: getVerticalSize(41),
                                child: VerticalDivider(
                                    width: getHorizontalSize(1),
                                    thickness: getVerticalSize(1),
                                    color: ColorConstant.gray40002)),
                            InkWell(
                              onTap: (){
                                //Get.toNamed(AppRoutes.filterScreen);
                                //dialogFilter();
                                _showFilterBottomSheet(context);
                              },
                              child: Container(
                                width: Get.width/2.1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomImageView(
                                        svgPath: ImageConstant.imgFilter,
                                        height: getSize(16),
                                        width: getSize(16),
                                        margin: getMargin(top: 13, bottom: 12)),
                                    Padding(
                                        padding: getPadding(
                                            left: 17, top: 12, bottom: 11),
                                        child: Text("lbl_filter".tr,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtRobotoMedium14))
                                  ],
                                ),
                              ),
                            )
                          ])),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: productlist.length,
                          itemBuilder: (context, index) {
                            return Container(
                                width: double.maxFinite,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Container(
                                                height: getVerticalSize(206),
                                                width: getHorizontalSize(412),
                                                margin: getMargin(top: 8),
                                                child: Stack(
                                                    alignment:
                                                    Alignment.topCenter,
                                                    children: [
                                                      CustomImageView(
                                                          url:
                                                          productlist[index].image!,
                                                          height:
                                                          getVerticalSize(
                                                              206),
                                                          width:
                                                          getHorizontalSize(
                                                              412),
                                                          alignment:
                                                          Alignment.center,
                                                          onTap: () {
                                                            Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => ProductDetailScreen1(productlist[index].id!),
                                                            ));
                                                          }),
                                                      Align(
                                                          alignment: Alignment
                                                              .topCenter,
                                                          child: Padding(
                                                              padding:
                                                              getPadding(
                                                                  bottom:
                                                                  190),
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                        width: getHorizontalSize(
                                                                            60),
                                                                        margin: getMargin(
                                                                            bottom:
                                                                            1),
                                                                        padding: getPadding(
                                                                            left:
                                                                            20,
                                                                            top:
                                                                            1,
                                                                            right:
                                                                            20,
                                                                            bottom:
                                                                            1),
                                                                        decoration: AppDecoration.txtOutlineBlack9003f.copyWith(
                                                                            borderRadius: BorderRadiusStyle
                                                                                .txtCustomBorderBR20),
                                                                        child: Text(
                                                                            "lbl_new"
                                                                                .tr,
                                                                            overflow:
                                                                            TextOverflow.ellipsis,
                                                                            textAlign: TextAlign.left,
                                                                            style: AppStyle.txtRobotoMedium9)),
                                                                    Container(
                                                                        width: getHorizontalSize(
                                                                            60),
                                                                        padding: getPadding(
                                                                            left:
                                                                            9,
                                                                            top:
                                                                            2,
                                                                            right:
                                                                            9,
                                                                            bottom:
                                                                            2),
                                                                        decoration: AppDecoration.txtOutlineBlack9003f1.copyWith(
                                                                            borderRadius: BorderRadiusStyle
                                                                                .txtCustomBorderBL20),
                                                                        child: Text(
                                                                            "lbl_30_off2"
                                                                                .tr,
                                                                            overflow:
                                                                            TextOverflow.ellipsis,
                                                                            textAlign: TextAlign.left,
                                                                            style: AppStyle.txtRobotoMedium9))
                                                                  ])))
                                                    ])),
                                            Padding(
                                                padding: getPadding(
                                                    left: 8, top: 8, right: 8),
                                                child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Container(
                                                          width:300,
                                                          padding: getPadding(
                                                              bottom: 3),
                                                          child: Text(
                                                              productlist[index].name!,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              textAlign:
                                                              TextAlign
                                                                  .left,
                                                              style: AppStyle
                                                                  .txtRobotoRegular18)),
                                                      Spacer(),
                                                      CustomImageView(
                                                          svgPath: ImageConstant
                                                              .imgCut,
                                                          height:
                                                          getVerticalSize(
                                                              11),
                                                          width:
                                                          getHorizontalSize(
                                                              7),
                                                          margin: getMargin(
                                                              top: 3,
                                                              bottom: 4)),
                                                      Padding(
                                                          padding: getPadding(
                                                              left: 4, top: 3,right: 4),
                                                          child: Text(
                                                              productlist[index].salePrice!,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              textAlign:
                                                              TextAlign
                                                                  .left,
                                                              style: AppStyle
                                                                  .txtRobotoMedium12Purple900))
                                                    ])),
                                            Padding(
                                                padding: getPadding(
                                                    left: 8, top: 2, right: 8),
                                                child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Text(
                                                          productlist[index].categoryName!+" by "+productlist[index].brandName!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                          TextAlign.left,
                                                          style: AppStyle
                                                              .txtRobotoRegular12Purple700),
                                                      Spacer(),
                                                      CustomImageView(
                                                          svgPath: ImageConstant
                                                              .imgVectorGray500,
                                                          height:
                                                          getVerticalSize(
                                                              8),
                                                          width:
                                                          getHorizontalSize(
                                                              5),
                                                          margin: getMargin(
                                                              top: 1,
                                                              bottom: 3)),
                                                      Container(
                                                          height:
                                                          getVerticalSize(
                                                              12),
                                                          width:
                                                          getHorizontalSize(
                                                              32),
                                                          margin: getMargin(
                                                              left: 3),
                                                          child: Stack(
                                                              alignment:
                                                              Alignment
                                                                  .center,
                                                              children: [
                                                                Align(
                                                                    alignment:
                                                                    Alignment
                                                                        .center,
                                                                    child: Text(
                                                                        productlist[index].mrpPrice!,
                                                                        overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                        textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                        style: AppStyle
                                                                            .txtRobotoMedium10Gray500)),
                                                                Align(
                                                                    alignment:
                                                                    Alignment
                                                                        .center,
                                                                    child: SizedBox(
                                                                        width: getHorizontalSize(
                                                                            32),
                                                                        child: Divider(
                                                                            height:
                                                                            getVerticalSize(1),
                                                                            thickness: getVerticalSize(1),
                                                                            color: ColorConstant.gray500)))
                                                              ]))
                                                    ])),
                                            Padding(
                                                padding: getPadding(
                                                    left: 8,
                                                    top: 11,
                                                    right: 12),
                                                child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                    children: [
                                                      Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                                "msg_limited_time_offer"
                                                                    .tr,
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                                textAlign:
                                                                TextAlign
                                                                    .left,
                                                                style: AppStyle
                                                                    .txtRobotoRegular10Black900),
                                                            Padding(
                                                                padding:
                                                                getPadding(
                                                                    top: 8),
                                                                child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                    children: [
                                                                      Text(
                                                                          "lbl_ships_in_1_day"
                                                                              .tr,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          textAlign: TextAlign
                                                                              .left,
                                                                          style:
                                                                          AppStyle.txtRobotoMedium10Black900),
                                                                      CustomImageView(
                                                                          svgPath: ImageConstant
                                                                              .imgCar,
                                                                          height: getVerticalSize(
                                                                              10),
                                                                          width: getHorizontalSize(
                                                                              13),
                                                                          margin: getMargin(
                                                                              left: 9,
                                                                              bottom: 1))
                                                                    ]))
                                                          ]),
                                                      Spacer(),
                                                      CustomImageView(
                                                          onTap: (){
                                                            pushNewScreen(
                                                              context,
                                                              screen: LogInScreen(),
                                                              withNavBar:
                                                              false, // OPTIONAL VALUE. True by default.
                                                              pageTransitionAnimation:
                                                              PageTransitionAnimation.cupertino,
                                                            );
                                                            // Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                            //   builder: (context) => LogInScreen(),
                                                            // ));
                                                            // addtowishlist(productlist[index].id);
                                                          },
                                                          svgPath: ImageConstant
                                                              .imgLocation,
                                                          height:
                                                          getVerticalSize(
                                                              18),
                                                          width:
                                                          getHorizontalSize(
                                                              21),
                                                          margin: getMargin(
                                                              top: 10,
                                                              bottom: 3)),
                                                      CustomImageView(
                                                          onTap: (){
                                                            pushNewScreen(
                                                              context,
                                                              screen: LogInScreen(),
                                                              withNavBar:
                                                              false, // OPTIONAL VALUE. True by default.
                                                              pageTransitionAnimation:
                                                              PageTransitionAnimation.cupertino,
                                                            );
                                                            // Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                            //   builder: (context) => LogInScreen(),
                                                            // ));
                                                            // _showQuantityBottomSheet(context,productlist[index].id);
                                                          },
                                                          svgPath: ImageConstant
                                                              .imgCart,
                                                          height:
                                                          getVerticalSize(
                                                              20),
                                                          width:
                                                          getHorizontalSize(
                                                              23),
                                                          margin: getMargin(
                                                              left: 35,
                                                              top: 9,
                                                              bottom: 2))
                                                    ])),
                                            Padding(
                                                padding: getPadding(top: 16),
                                                child: Divider(
                                                    height: getVerticalSize(5),
                                                    thickness:
                                                    getVerticalSize(5),
                                                    color: ColorConstant
                                                        .purple50)),
                                          ],
                                        ),
                                      ),
                                      // Container(
                                      //     height: getVerticalSize(206),
                                      //     width: getHorizontalSize(412),
                                      //     margin: getMargin(top: 5),
                                      //     child:
                                      //     Stack(alignment: Alignment.topCenter, children: [
                                      //       CustomImageView(
                                      //           imagePath: ImageConstant.imgImage14,
                                      //           height: getVerticalSize(206),
                                      //           width: getHorizontalSize(412),
                                      //           alignment: Alignment.center),
                                      //       Align(
                                      //           alignment: Alignment.topCenter,
                                      //           child: Padding(
                                      //               padding: getPadding(bottom: 190),
                                      //               child: Row(
                                      //                   mainAxisAlignment:
                                      //                   MainAxisAlignment.spaceBetween,
                                      //                   children: [
                                      //                     Container(
                                      //                         width: getHorizontalSize(60),
                                      //                         margin: getMargin(bottom: 1),
                                      //                         padding: getPadding(
                                      //                             left: 20,
                                      //                             top: 1,
                                      //                             right: 20,
                                      //                             bottom: 1),
                                      //                         decoration: AppDecoration
                                      //                             .txtOutlineBlack9003f
                                      //                             .copyWith(
                                      //                             borderRadius:
                                      //                             BorderRadiusStyle
                                      //                                 .txtCustomBorderBR20),
                                      //                         child: Text("lbl_new".tr,
                                      //                             overflow:
                                      //                             TextOverflow.ellipsis,
                                      //                             textAlign: TextAlign.left,
                                      //                             style: AppStyle
                                      //                                 .txtRobotoMedium9)),
                                      //                     Container(
                                      //                         width: getHorizontalSize(60),
                                      //                         padding: getPadding(
                                      //                             left: 9,
                                      //                             top: 2,
                                      //                             right: 9,
                                      //                             bottom: 2),
                                      //                         decoration: AppDecoration
                                      //                             .txtOutlineBlack9003f1
                                      //                             .copyWith(
                                      //                             borderRadius:
                                      //                             BorderRadiusStyle
                                      //                                 .txtCustomBorderBL20),
                                      //                         child: Text("lbl_30_off2".tr,
                                      //                             overflow:
                                      //                             TextOverflow.ellipsis,
                                      //                             textAlign: TextAlign.left,
                                      //                             style: AppStyle
                                      //                                 .txtRobotoMedium9))
                                      //                   ])))
                                      //     ])),
                                      // Padding(
                                      //     padding: getPadding(left: 8, top: 8, right: 8),
                                      //     child: Row(
                                      //         mainAxisAlignment: MainAxisAlignment.center,
                                      //         crossAxisAlignment: CrossAxisAlignment.start,
                                      //         children: [
                                      //           Padding(
                                      //               padding: getPadding(bottom: 3),
                                      //               child: Text("msg_fabiola_2_seater2".tr,
                                      //                   overflow: TextOverflow.ellipsis,
                                      //                   textAlign: TextAlign.left,
                                      //                   style: AppStyle
                                      //                       .txtRobotoRegular12Black900)),
                                      //           Spacer(),
                                      //           CustomImageView(
                                      //               svgPath: ImageConstant.imgCut,
                                      //               height: getVerticalSize(11),
                                      //               width: getHorizontalSize(7),
                                      //               margin: getMargin(top: 3, bottom: 4)),
                                      //           Padding(
                                      //               padding: getPadding(left: 4, top: 3),
                                      //               child: Text("lbl_49_999".tr,
                                      //                   overflow: TextOverflow.ellipsis,
                                      //                   textAlign: TextAlign.left,
                                      //                   style: AppStyle
                                      //                       .txtRobotoMedium12Purple900))
                                      //         ])),
                                      // Padding(
                                      //     padding: getPadding(left: 8, top: 2, right: 8),
                                      //     child: Row(
                                      //         mainAxisAlignment: MainAxisAlignment.center,
                                      //         children: [
                                      //           Text("msg_casacraft_by_fabfurni".tr,
                                      //               overflow: TextOverflow.ellipsis,
                                      //               textAlign: TextAlign.left,
                                      //               style:
                                      //               AppStyle.txtRobotoRegular10Purple9001),
                                      //           Spacer(),
                                      //           CustomImageView(
                                      //               svgPath: ImageConstant.imgVectorGray500,
                                      //               height: getVerticalSize(8),
                                      //               width: getHorizontalSize(5),
                                      //               margin: getMargin(top: 1, bottom: 3)),
                                      //           Container(
                                      //               height: getVerticalSize(12),
                                      //               width: getHorizontalSize(32),
                                      //               margin: getMargin(left: 3),
                                      //               child: Stack(
                                      //                   alignment: Alignment.center,
                                      //                   children: [
                                      //                     Align(
                                      //                         alignment: Alignment.center,
                                      //                         child: Text("lbl_99_999".tr,
                                      //                             overflow:
                                      //                             TextOverflow.ellipsis,
                                      //                             textAlign: TextAlign.left,
                                      //                             style: AppStyle
                                      //                                 .txtRobotoMedium10Gray500)),
                                      //                     Align(
                                      //                         alignment: Alignment.center,
                                      //                         child: SizedBox(
                                      //                             width: getHorizontalSize(32),
                                      //                             child: Divider(
                                      //                                 height:
                                      //                                 getVerticalSize(1),
                                      //                                 thickness:
                                      //                                 getVerticalSize(1),
                                      //                                 color: ColorConstant
                                      //                                     .gray500)))
                                      //                   ]))
                                      //         ])),
                                      // Padding(
                                      //     padding: getPadding(left: 8, top: 11, right: 12),
                                      //     child: Row(
                                      //         mainAxisAlignment: MainAxisAlignment.center,
                                      //         crossAxisAlignment: CrossAxisAlignment.end,
                                      //         children: [
                                      //           Column(
                                      //               mainAxisAlignment: MainAxisAlignment.start,
                                      //               children: [
                                      //                 Text("msg_limited_time_offer".tr,
                                      //                     overflow: TextOverflow.ellipsis,
                                      //                     textAlign: TextAlign.left,
                                      //                     style: AppStyle
                                      //                         .txtRobotoRegular10Black900),
                                      //                 Padding(
                                      //                     padding: getPadding(top: 8),
                                      //                     child: Row(
                                      //                         mainAxisAlignment:
                                      //                         MainAxisAlignment.center,
                                      //                         children: [
                                      //                           Text("lbl_ships_in_1_day".tr,
                                      //                               overflow:
                                      //                               TextOverflow.ellipsis,
                                      //                               textAlign: TextAlign.left,
                                      //                               style: AppStyle
                                      //                                   .txtRobotoMedium10Black900),
                                      //                           CustomImageView(
                                      //                               svgPath:
                                      //                               ImageConstant.imgCar,
                                      //                               height: getVerticalSize(10),
                                      //                               width:
                                      //                               getHorizontalSize(13),
                                      //                               margin: getMargin(
                                      //                                   left: 9, bottom: 1))
                                      //                         ]))
                                      //               ]),
                                      //           Spacer(),
                                      //           CustomImageView(
                                      //               svgPath: ImageConstant.imgLocation,
                                      //               height: getVerticalSize(18),
                                      //               width: getHorizontalSize(21),
                                      //               margin: getMargin(top: 10, bottom: 3)),
                                      //           CustomImageView(
                                      //               svgPath: ImageConstant.imgCart,
                                      //               height: getVerticalSize(20),
                                      //               width: getHorizontalSize(23),
                                      //               margin:
                                      //               getMargin(left: 35, top: 9, bottom: 2))
                                      //         ])),
                                      // Padding(
                                      //     padding: getPadding(top: 16),
                                      //     child: Divider(
                                      //         height: getVerticalSize(5),
                                      //         thickness: getVerticalSize(5),
                                      //         color: ColorConstant.purple50)),
                                      // Container(
                                      //     height: getVerticalSize(206),
                                      //     width: getHorizontalSize(412),
                                      //     margin: getMargin(top: 5),
                                      //     child: Stack(alignment: Alignment.center, children: [
                                      //       Align(
                                      //           alignment: Alignment.topCenter,
                                      //           child: Container(
                                      //               margin:
                                      //                   getMargin(left: 6, top: 45, right: 6),
                                      //               padding: getPadding(
                                      //                   left: 41, top: 6, right: 41, bottom: 6),
                                      //               decoration: BoxDecoration(
                                      //                   image: DecorationImage(
                                      //                       image: fs.Svg(
                                      //                           ImageConstant.imgGroup203),
                                      //                       fit: BoxFit.cover)),
                                      //               child: Column(
                                      //                   mainAxisSize: MainAxisSize.min,
                                      //                   mainAxisAlignment:
                                      //                       MainAxisAlignment.end,
                                      //                   children: [
                                      //                     CustomImageView(
                                      //                         svgPath: ImageConstant.imgGroup2,
                                      //                         height: getVerticalSize(47),
                                      //                         width: getHorizontalSize(315),
                                      //                         margin: getMargin(top: 11)),
                                      //                     Padding(
                                      //                         padding: getPadding(
                                      //                             left: 7, top: 4, right: 4),
                                      //                         child: Row(
                                      //                             mainAxisAlignment:
                                      //                                 MainAxisAlignment
                                      //                                     .spaceBetween,
                                      //                             children: [
                                      //                               Text("lbl_home".tr,
                                      //                                   overflow: TextOverflow
                                      //                                       .ellipsis,
                                      //                                   textAlign:
                                      //                                       TextAlign.left,
                                      //                                   style: AppStyle
                                      //                                       .txtRobotoMedium8Purple900),
                                      //                               Text("lbl_store".tr,
                                      //                                   overflow: TextOverflow
                                      //                                       .ellipsis,
                                      //                                   textAlign:
                                      //                                       TextAlign.left,
                                      //                                   style: AppStyle
                                      //                                       .txtRobotoMedium8),
                                      //                               Text("lbl_profile".tr,
                                      //                                   overflow: TextOverflow
                                      //                                       .ellipsis,
                                      //                                   textAlign:
                                      //                                       TextAlign.left,
                                      //                                   style: AppStyle
                                      //                                       .txtRobotoMedium8)
                                      //                             ]))
                                      //                   ]))),
                                      //       Align(
                                      //           alignment: Alignment.center,
                                      //           child: Container(
                                      //               height: getVerticalSize(206),
                                      //               width: getHorizontalSize(412),
                                      //               child: Stack(
                                      //                   alignment: Alignment.topCenter,
                                      //                   children: [
                                      //                     CustomImageView(
                                      //                         imagePath:
                                      //                             ImageConstant.imgImage14,
                                      //                         height: getVerticalSize(206),
                                      //                         width: getHorizontalSize(412),
                                      //                         alignment: Alignment.center),
                                      //                     Align(
                                      //                         alignment: Alignment.topCenter,
                                      //                         child: Column(
                                      //                             mainAxisSize:
                                      //                                 MainAxisSize.min,
                                      //                             mainAxisAlignment:
                                      //                                 MainAxisAlignment.start,
                                      //                             children: [
                                      //                               Row(
                                      //                                   mainAxisAlignment:
                                      //                                       MainAxisAlignment
                                      //                                           .spaceBetween,
                                      //                                   children: [
                                      //                                     Container(
                                      //                                         width:
                                      //                                             getHorizontalSize(
                                      //                                                 60),
                                      //                                         margin:
                                      //                                             getMargin(
                                      //                                                 bottom:
                                      //                                                     1),
                                      //                                         padding:
                                      //                                             getPadding(
                                      //                                                 left: 20,
                                      //                                                 top: 1,
                                      //                                                 right: 20,
                                      //                                                 bottom:
                                      //                                                     1),
                                      //                                         decoration: AppDecoration
                                      //                                             .txtOutlineBlack9003f
                                      //                                             .copyWith(
                                      //                                                 borderRadius:
                                      //                                                     BorderRadiusStyle
                                      //                                                         .txtCustomBorderBR20),
                                      //                                         child: Text(
                                      //                                             "lbl_new".tr,
                                      //                                             overflow:
                                      //                                                 TextOverflow
                                      //                                                     .ellipsis,
                                      //                                             textAlign:
                                      //                                                 TextAlign
                                      //                                                     .left,
                                      //                                             style: AppStyle
                                      //                                                 .txtRobotoMedium9)),
                                      //                                     Container(
                                      //                                         width:
                                      //                                             getHorizontalSize(
                                      //                                                 60),
                                      //                                         padding:
                                      //                                             getPadding(
                                      //                                                 left: 9,
                                      //                                                 top: 2,
                                      //                                                 right: 9,
                                      //                                                 bottom:
                                      //                                                     2),
                                      //                                         decoration: AppDecoration
                                      //                                             .txtOutlineBlack9003f1
                                      //                                             .copyWith(
                                      //                                                 borderRadius:
                                      //                                                     BorderRadiusStyle
                                      //                                                         .txtCustomBorderBL20),
                                      //                                         child: Text(
                                      //                                             "lbl_30_off2"
                                      //                                                 .tr,
                                      //                                             overflow:
                                      //                                                 TextOverflow
                                      //                                                     .ellipsis,
                                      //                                             textAlign:
                                      //                                                 TextAlign
                                      //                                                     .left,
                                      //                                             style: AppStyle
                                      //                                                 .txtRobotoMedium9))
                                      //                                   ]),
                                      //                               Container(
                                      //                                   margin: getMargin(
                                      //                                       left: 6,
                                      //                                       top: 29,
                                      //                                       right: 6),
                                      //                                   padding: getPadding(
                                      //                                       left: 41,
                                      //                                       top: 6,
                                      //                                       right: 41,
                                      //                                       bottom: 6),
                                      //                                   decoration: BoxDecoration(
                                      //                                       image: DecorationImage(
                                      //                                           image: fs.Svg(
                                      //                                               ImageConstant
                                      //                                                   .imgGroup203),
                                      //                                           fit: BoxFit
                                      //                                               .cover)),
                                      //                                   child: Column(
                                      //                                       mainAxisAlignment:
                                      //                                           MainAxisAlignment
                                      //                                               .end,
                                      //                                       children: [
                                      //                                         CustomImageView(
                                      //                                             svgPath:
                                      //                                                 ImageConstant
                                      //                                                     .imgGroup2Purple900,
                                      //                                             height:
                                      //                                                 getVerticalSize(
                                      //                                                     47),
                                      //                                             width:
                                      //                                                 getHorizontalSize(
                                      //                                                     315),
                                      //                                             margin:
                                      //                                                 getMargin(
                                      //                                                     top:
                                      //                                                         11)),
                                      //                                         Padding(
                                      //                                             padding:
                                      //                                                 getPadding(
                                      //                                                     left:
                                      //                                                         7,
                                      //                                                     top:
                                      //                                                         4,
                                      //                                                     right:
                                      //                                                         4),
                                      //                                             child: Row(
                                      //                                                 mainAxisAlignment:
                                      //                                                     MainAxisAlignment
                                      //                                                         .spaceBetween,
                                      //                                                 children: [
                                      //                                                   Text(
                                      //                                                       "lbl_home"
                                      //                                                           .tr,
                                      //                                                       overflow:
                                      //                                                           TextOverflow.ellipsis,
                                      //                                                       textAlign: TextAlign.left,
                                      //                                                       style: AppStyle.txtRobotoMedium8),
                                      //                                                   Text(
                                      //                                                       "lbl_store"
                                      //                                                           .tr,
                                      //                                                       overflow:
                                      //                                                           TextOverflow.ellipsis,
                                      //                                                       textAlign: TextAlign.left,
                                      //                                                       style: AppStyle.txtRobotoMedium8Purple900),
                                      //                                                   Text(
                                      //                                                       "lbl_profile"
                                      //                                                           .tr,
                                      //                                                       overflow:
                                      //                                                           TextOverflow.ellipsis,
                                      //                                                       textAlign: TextAlign.left,
                                      //                                                       style: AppStyle.txtRobotoMedium8)
                                      //                                                 ]))
                                      //                                       ]))
                                      //                             ]))
                                      //                   ])))
                                      //     ])),
                                      // Padding(
                                      //     padding: getPadding(left: 8, top: 8, right: 8),
                                      //     child: Row(
                                      //         mainAxisAlignment: MainAxisAlignment.center,
                                      //         crossAxisAlignment: CrossAxisAlignment.end,
                                      //         children: [
                                      //           Padding(
                                      //               padding: getPadding(bottom: 4),
                                      //               child: Text("msg_fabiola_2_seater2".tr,
                                      //                   overflow: TextOverflow.ellipsis,
                                      //                   textAlign: TextAlign.left,
                                      //                   style: AppStyle
                                      //                       .txtRobotoRegular12Black9001)),
                                      //           Spacer(),
                                      //           CustomImageView(
                                      //               svgPath: ImageConstant.imgCut,
                                      //               height: getVerticalSize(11),
                                      //               width: getHorizontalSize(7),
                                      //               margin: getMargin(top: 4, bottom: 3)),
                                      //           Padding(
                                      //               padding: getPadding(left: 4, top: 4),
                                      //               child: Text("lbl_49_999".tr,
                                      //                   overflow: TextOverflow.ellipsis,
                                      //                   textAlign: TextAlign.left,
                                      //                   style: AppStyle
                                      //                       .txtRobotoMedium12Purple9001))
                                      //         ])),
                                      // Padding(
                                      //     padding: getPadding(left: 8, top: 3, right: 8),
                                      //     child: Row(
                                      //         mainAxisAlignment: MainAxisAlignment.center,
                                      //         children: [
                                      //           Padding(
                                      //               padding: getPadding(bottom: 1),
                                      //               child: Text("msg_casacraft_by_fabfurni".tr,
                                      //                   overflow: TextOverflow.ellipsis,
                                      //                   textAlign: TextAlign.left,
                                      //                   style: AppStyle
                                      //                       .txtRobotoRegular10Purple900)),
                                      //           Spacer(),
                                      //           CustomImageView(
                                      //               svgPath: ImageConstant.imgVectorGray500,
                                      //               height: getVerticalSize(8),
                                      //               width: getHorizontalSize(5),
                                      //               margin: getMargin(top: 2, bottom: 3)),
                                      //           Container(
                                      //               height: getVerticalSize(12),
                                      //               width: getHorizontalSize(32),
                                      //               margin: getMargin(left: 3, top: 1),
                                      //               child: Stack(
                                      //                   alignment: Alignment.bottomCenter,
                                      //                   children: [
                                      //                     Align(
                                      //                         alignment: Alignment.center,
                                      //                         child: Text("lbl_99_999".tr,
                                      //                             overflow:
                                      //                                 TextOverflow.ellipsis,
                                      //                             textAlign: TextAlign.left,
                                      //                             style: AppStyle
                                      //                                 .txtRobotoMedium10Gray5001)),
                                      //                     Align(
                                      //                         alignment: Alignment.bottomCenter,
                                      //                         child: Padding(
                                      //                             padding:
                                      //                                 getPadding(bottom: 5),
                                      //                             child: SizedBox(
                                      //                                 width:
                                      //                                     getHorizontalSize(32),
                                      //                                 child: Divider(
                                      //                                     height:
                                      //                                         getVerticalSize(
                                      //                                             1),
                                      //                                     thickness:
                                      //                                         getVerticalSize(
                                      //                                             1),
                                      //                                     color: ColorConstant
                                      //                                         .gray500))))
                                      //                   ]))
                                      //         ])),
                                      // Padding(
                                      //     padding: getPadding(left: 8, top: 12, right: 12),
                                      //     child: Row(
                                      //         mainAxisAlignment: MainAxisAlignment.center,
                                      //         crossAxisAlignment: CrossAxisAlignment.end,
                                      //         children: [
                                      //           Column(
                                      //               mainAxisAlignment: MainAxisAlignment.start,
                                      //               children: [
                                      //                 Text("msg_limited_time_offer".tr,
                                      //                     overflow: TextOverflow.ellipsis,
                                      //                     textAlign: TextAlign.left,
                                      //                     style: AppStyle
                                      //                         .txtRobotoRegular10Black9001),
                                      //                 Padding(
                                      //                     padding: getPadding(top: 7),
                                      //                     child: Row(
                                      //                         mainAxisAlignment:
                                      //                             MainAxisAlignment.center,
                                      //                         children: [
                                      //                           Text("lbl_ships_in_1_day".tr,
                                      //                               overflow:
                                      //                                   TextOverflow.ellipsis,
                                      //                               textAlign: TextAlign.left,
                                      //                               style: AppStyle
                                      //                                   .txtRobotoMedium10Black9001),
                                      //                           CustomImageView(
                                      //                               svgPath:
                                      //                                   ImageConstant.imgCar,
                                      //                               height: getVerticalSize(10),
                                      //                               width:
                                      //                                   getHorizontalSize(13),
                                      //                               margin: getMargin(
                                      //                                   left: 9,
                                      //                                   top: 1,
                                      //                                   bottom: 1))
                                      //                         ]))
                                      //               ]),
                                      //           Spacer(),
                                      //           // CustomImageView(
                                      //           //     svgPath: ImageConstant.imgLocation,
                                      //           //     height: getVerticalSize(18),
                                      //           //     width: getHorizontalSize(21),
                                      //           //     margin: getMargin(top: 10, bottom: 3)),
                                      //           // CustomImageView(
                                      //           //     svgPath: ImageConstant.imgCart,
                                      //           //     height: getVerticalSize(20),
                                      //           //     width: getHorizontalSize(23),
                                      //           //     margin:
                                      //           //         getMargin(left: 35, top: 9, bottom: 2))
                                      //         ])),
                                      // Padding(
                                      //     padding: getPadding(top: 17),
                                      //     child: Divider(
                                      //         height: getVerticalSize(5),
                                      //         thickness: getVerticalSize(5),
                                      //         color: ColorConstant.purple50))
                                    ]));
                          }),
                    ),
                  )
                ],
              ),
            )));
  }
  dialogFilter() {
    Size size = MediaQuery.of(context).size;
    Get.bottomSheet(
      StatefulBuilder(builder: (context, setState) {
        return SafeArea(
          child: Container(
              height: size.height * 0.6,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.52,
                    child: ListView(
                      children: <Widget>[
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                "FILTER PRODUCTS",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                    fontFamily: 'anekgujarati',
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: IconButton(
                                alignment: Alignment.topRight,
                                onPressed: () async {
                                  if (Get.isBottomSheetOpen ?? false) {
                                    Get.back();
                                  }
                                },
                                icon: Icon(
                                  Icons.close_rounded,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                        new Divider(
                          color: Colors.grey[300],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 40,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Sort By",
                                  style: (TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GridView.builder(
                                controller: _controller,
                                physics: ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: filterSortByItem.length,
                                shrinkWrap: true,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 2 / 0.5,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 0),
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: RadioListTile(
                                              title: Text(
                                                filterSortByItem[index],
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                              ),
                                              value: filterSortByItem[index],
                                              groupValue: selectedPaymentMethod,
                                              onChanged: (value) =>
                                                  setState(() {
                                                    selectedPaymentMethod =
                                                        value;
                                                  })),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Sort By Price",
                                  style: (TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RangeSlider(
                              values: _currentRangeValues,
                              max: 10000,
                              divisions: 200,
                              labels: RangeLabels(
                                _currentRangeValues.start
                                    .round()
                                    .toString(),
                                _currentRangeValues.end
                                    .round()
                                    .toString(),
                              ),
                              onChanged: (RangeValues values) {
                                setState(() {
                                  _currentRangeValues = values;
                                });
                              },
                            ),
                            Container(
                              margin:
                              EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: [
                                  Text(
                                    '\u{20B9} ${(_currentRangeValues.start.toStringAsFixed(2))}/-',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    '\u{20B9} ${(_currentRangeValues.end.toStringAsFixed(2))}/-',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      //height: 70,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (Get.isBottomSheetOpen ?? false) {
                                            Get.back();
                                            sort_column = '';
                                            sort_order = '';
                                            setPriceMinValue = '';
                                            setPriceMaxValue = '';
                                            selectedPaymentMethod = '';
                                            _currentRangeValues =
                                            const RangeValues(1, 10000);
                                            //callAPI();
                                          }
                                        },
                                        child: Text(
                                          "Clear all".toUpperCase(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.blueGrey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 8.0),
                                      //height: 70,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (selectedPaymentMethod ==
                                              'High to Low') {
                                            sort_column = "sell_price";
                                            sort_order = "desc";
                                          } else if (selectedPaymentMethod ==
                                              'Low to High') {
                                            sort_column = "sell_price";
                                            sort_order = "asc";
                                          } else if (selectedPaymentMethod ==
                                              'A to Z') {
                                            sort_column = "name";
                                            sort_order = "asc";
                                          } else if (selectedPaymentMethod ==
                                              'Z to A') {
                                            sort_column = "name";
                                            sort_order = "desc";
                                          } else if (selectedPaymentMethod ==
                                              'Newest First') {
                                            sort_column = "id";
                                            sort_order = "desc";
                                          } else if (selectedPaymentMethod ==
                                              'Oldest First') {
                                            sort_column = "id";
                                            sort_order = "asc";
                                          }
                                          setPriceMinValue = _currentRangeValues
                                              .start
                                              .toInt()
                                              .toString();

                                          setPriceMaxValue = _currentRangeValues
                                              .end
                                              .toInt()
                                              .toString();
                                          Get.back();
                                          //callAPI();
                                        },
                                        child: Text(
                                          "Apply".toUpperCase(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.cyan,
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
                  ),
                ],
              )),
        );
      }),
      isScrollControlled: true,

      //barrierColor: Colors.red[50],
      //isDismissible: false,
    );
  }
  // Future<AddWishlist> addtowishlist(String product_id) async {
  //   Map data = {
  //     'user_id': widget.data.id,
  //     'product_id':product_id,
  //   };
  //   //encode Map to JSON
  //   var body = json.encode(data);
  //   var response =
  //   await dio.Dio().post("https://fabfurni.com/api/Webservice/addWishlist",
  //       options: dio.Options(
  //         headers: {
  //           "Content-Type": "application/json",
  //           "Accept": "*/*",
  //         },
  //       ),
  //       data: body);
  //   var jsonObject = jsonDecode(response.toString());
  //   if (response.statusCode == 200) {
  //     print(jsonObject);
  //
  //     if (AddWishlist.fromJson(jsonObject).status == "true") {
  //       // print(orders.MyOrdersModel.fromJson(jsonObject).data.first.products.first.image);
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           duration: Duration(seconds: 1),
  //           behavior: SnackBarBehavior.floating,
  //           margin: EdgeInsets.only(bottom: 10.0),
  //           content: Text("Added to Wishlist "+AddWishlist.fromJson(jsonObject).message+"ly",style: TextStyle(color: Colors.black),),
  //           backgroundColor: Colors.greenAccent));
  //
  //       return AddWishlist.fromJson(jsonObject);
  //
  //       // inviteList.sort((a, b) => a.id.compareTo(b.id));
  //     }else if (AddWishlist.fromJson(jsonObject).status == "false") {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           duration: Duration(seconds: 2),
  //           behavior: SnackBarBehavior.floating,
  //           margin: EdgeInsets.only(bottom: 10.0),
  //           content: Text(AddWishlist.fromJson(jsonObject).message.capitalizeFirst),
  //           backgroundColor: Colors.redAccent));
  //
  //     }
  //     else if(AddWishlist.fromJson(jsonObject).data == null){
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         duration: Duration(seconds: 3),
  //         behavior: SnackBarBehavior.floating,
  //         margin: EdgeInsets.only(bottom: 10.0),
  //         content: Text(
  //           jsonObject['message'] + ' Please check after sometime.',
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         backgroundColor: Colors.redAccent,
  //       ));
  //     }
  //     else {
  //       throw Exception('Failed to load');
  //     }
  //   } else {
  //     throw Exception('Failed to load');
  //   }
  //   return jsonObject;
  // }
  // Future<AddtoCart> addtocart(String qty,String product_id) async {
  //   Map data = {
  //     'user_id': widget.data.id,
  //     'product_id':product_id,
  //     'qty':qty,
  //   };
  //   //encode Map to JSON
  //   var body = json.encode(data);
  //   var response =
  //   await dio.Dio().post("https://fabfurni.com/api/Webservice/addtoCart",
  //       options: dio.Options(
  //         headers: {
  //           "Content-Type": "application/json",
  //           "Accept": "*/*",
  //         },
  //       ),
  //       data: body);
  //   var jsonObject = jsonDecode(response.toString());
  //   if (response.statusCode == 200) {
  //     print(jsonObject);
  //
  //     if (AddtoCart.fromJson(jsonObject).status == "true") {
  //       // print(orders.MyOrdersModel.fromJson(jsonObject).data.first.products.first.image);
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           duration: Duration(seconds: 3),
  //           behavior: SnackBarBehavior.floating,
  //           margin: EdgeInsets.only(bottom: 10.0),
  //           content: Text("Added to Cart "+AddtoCart.fromJson(jsonObject).message+"ly",style: TextStyle(color: Colors.black),),
  //           backgroundColor: Colors.greenAccent));
  //
  //       return AddtoCart.fromJson(jsonObject);
  //
  //       // inviteList.sort((a, b) => a.id.compareTo(b.id));
  //     }else if (AddtoCart.fromJson(jsonObject).status == "false") {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           duration: Duration(seconds: 3),
  //           behavior: SnackBarBehavior.floating,
  //           margin: EdgeInsets.only(bottom: 10.0),
  //           content: Text(AddtoCart.fromJson(jsonObject).message.capitalizeFirst),
  //           backgroundColor: Colors.redAccent));
  //
  //     }
  //     else if(AddtoCart.fromJson(jsonObject).data == null){
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         duration: Duration(seconds: 3),
  //         behavior: SnackBarBehavior.floating,
  //         margin: EdgeInsets.only(bottom: 10.0),
  //         content: Text(
  //           jsonObject['message'] + ' Please check after sometime.',
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         backgroundColor: Colors.redAccent,
  //       ));
  //     }
  //     else {
  //       throw Exception('Failed to load');
  //     }
  //   } else {
  //     throw Exception('Failed to load');
  //   }
  //   return jsonObject;
  // }

  void _showsortbyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.33,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            child:  SortByBottomsheet());

      },
    ).then((value) {
      if (value != null) {
        // Handle the selected quantity returned from the bottom sheet
        // addtocart(value.toString(),product_id);
        print('Selected quantity: '+ value);
        Fluttertoast.showToast(
            msg: value,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.cyan,
            textColor: Colors.white,
            fontSize: 14.0);
        sortBy = value;
        product = getProduct();
        product!.then((value) {
          setState(() {
            productlist = value.data!;
          });
        });
      }
    });
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            child: FilterScreen()
        );
      },
    ).then((value) {
      if (value != null) {
        //print('Selected quantity: '+ value);
        widget.categoryId = value[0];
        widget.subCategoryId = value[1];
        widget.keyword_id = value[2];
        widget.brandId = value[3];
        product = getProduct();
        product!.then((value) {
          setState(() {
            productlist = value.data!;
          });
        });
      }
    });
  }

  // void _showQuantityBottomSheet(BuildContext context,String product_id) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return QuantityBottomSheet();
  //     },
  //   ).then((value) {
  //     if (value != null) {
  //       // Handle the selected quantity returned from the bottom sheet
  //       addtocart(value.toString(),product_id);
  //       print('Selected quantity: $value');
  //     }
  //   });
  // }

  onTapImgImagefourteen() {
    Get.toNamed(AppRoutes.productDetailScreen);
  }

  onTapArrowleft5() {
    Navigator.of(context).pop();
    // Get.back();
  }
}
