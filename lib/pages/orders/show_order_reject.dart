import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:langhong/api/api_services.dart';
import 'package:langhong/common/app_color.dart';
import 'package:langhong/common/app_font.dart';
import 'package:langhong/common/app_utility.dart';
import 'package:langhong/controller/mainCtr.dart';
import 'package:langhong/model/market_price.dart';
import 'package:langhong/model/order_reject.dart';
import 'package:langhong/model/portfolio.dart';
import 'package:langhong/model/user_profile.dart';
import 'package:langhong/pages/market/xauusd_gold.dart';
import 'package:langhong/pages/orders/popup_order_details.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ShowOrderRejectPage extends StatefulWidget {
  ShowOrderRejectPage(this.socket) : super();

  late IO.Socket socket;

  @override
  _ShowOrderRejectPageState createState() => _ShowOrderRejectPageState();
}

class _ShowOrderRejectPageState extends State<ShowOrderRejectPage> {
  final mainCtr = Get.find<MainCtr>(tag: "MainCtr");

  List<OrderReject> orderRejectList = [];
  bool isLoad = false;

  //-- Call API Order Reject
  void getOrderReject() {
    ApiServices.getOrderRejectTransaction(
            context,
            widget.socket,
            mainCtr.userProfileList.value.memberId ?? "",
            mainCtr.userProfileList.value.accessToken ?? "")
        .then((value) {
      setState(() {
        orderRejectList = value;
        // จัดเรียงลำดับข้อมูลวันที่ทำรายการล่าสุดจากมากไปน้อย
        orderRejectList.sort((a, b) => b.createDate!.compareTo(a.createDate!));
        isLoad = true;
      });
    });
  }

  @override
  void initState() {
    getOrderReject();
    super.initState();
  }

  @override
  void dispose() {
    orderRejectList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: isLoad == false
            ? Center(child: CircularProgressIndicator())
            : buidReportOrderUnpaid(width, height));
  }

  buidReportOrderUnpaid(double width, double height) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/page-bg.png'),
              fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 4, left: 8, right: 8),
          child: Column(
            children: [
              Container(
                width: width,
                height: height * 0.04,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Image.asset('assets/images/arrow-left.png',
                          width: 40, height: 40),
                    ),
                    Spacer(),
                    Text('${mainCtr.userProfileList.value.memberRef}',
                        style: AppFont.titleText04),
                    AppUtility.buildPopUpMenu(mainCtr.userPortfolioList.value),
                  ],
                ),
              ),
              Container(
                width: double.maxFinite,
                height: height * 0.05,
                alignment: Alignment.center,
                child: const Text('รายการยกเลิก', style: AppFont.titleText01),
              ),
              Container(
                width: double.maxFinite,
                height: Platform.isAndroid
                    ? height - (height * 0.2)
                    : height - (height * 0.3),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: orderRejectList.isEmpty
                        ? Column(
                            children: [
                              SizedBox(height: height * .35),
                              const Center(
                                  child: Text('ไม่พบข้อมูลรายการยกเลิก',
                                      style: AppFont.bodyText05)),
                            ],
                          )
                        : Column(
                            children: [
                              Text(
                                  'ราคาตลาด${AppUtility.convertThaiDate(mainCtr.marketPriceList[0].dateTime.toString())}',
                                  style: AppFont.titleText12),
                              SizedBox(height: 3),
                              XAUUSDGold(
                                  name: 'XAU/USD',
                                  bidSpot: mainCtr.marketPriceList[0].bidSpot!,
                                  askSpot: mainCtr.marketPriceList[0].askSpot!),
                              SizedBox(height: 20),
                              //-- 2. ส่วนแสดงรายงาน
                              //-- 2.1 Heading Report
                              Container(
                                height: height * 0.08,
                                child: Row(
                                  children: [
                                    Container(
                                      width: width * 0.26,
                                      height: height * 0.1,
                                      color: AppColor.blue,
                                      alignment: Alignment.center,
                                      child: Text('วันทำรายการ',
                                          style: AppFont.bodyText14),
                                    ),
                                    Container(
                                      width: width * 0.1,
                                      height: height * 0.12,
                                      color: AppColor.blue,
                                      alignment: Alignment.center,
                                      child: const Text('รายการ',
                                          style: AppFont.bodyText14),
                                    ),
                                    Container(
                                      width: width * 0.1,
                                      height: height * 0.12,
                                      color: AppColor.blue,
                                      alignment: Alignment.center,
                                      child: const Text('ทอง',
                                          style: AppFont.bodyText14),
                                    ),
                                    Container(
                                      width: width * 0.16,
                                      height: height * 0.12,
                                      color: AppColor.blue,
                                      alignment: Alignment.center,
                                      child: Text('ราคา',
                                          style: AppFont.bodyText14),
                                    ),
                                    Container(
                                      width: width * 0.10,
                                      height: height * 0.12,
                                      color: AppColor.blue,
                                      alignment: Alignment.center,
                                      child: Text('จำนวน',
                                          style: AppFont.bodyText14),
                                    ),
                                    Container(
                                      width: width * 0.21,
                                      height: height * 0.1,
                                      color: AppColor.blue,
                                      alignment: Alignment.center,
                                      child: GestureDetector(
                                          onTap: () {}, child: Text('')),
                                    ),
                                  ],
                                ),
                              ),
                              //-- 2.2 Details Report
                              SingleChildScrollView(
                                child: Container(
                                  height: height * 0.5,
                                  child: ListView.builder(
                                      itemCount: orderRejectList.length,
                                      itemBuilder: (context, index) {
                                        var dueDate = orderRejectList[index]
                                                    .duedate ==
                                                null
                                            ? ''
                                            : orderRejectList[index].duedate;
                                        return Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                width: width * 0.26,
                                                height: height * 0.08,
                                                color: index % 2 == 0
                                                    ? Colors.white
                                                    : AppColor.lightGrey,
                                                alignment: Alignment.center,
                                                child: Text(
                                                    '${AppUtility.convertDateFormat(orderRejectList[index].createDate!)}',
                                                    style: AppFont.bodyText13),
                                              ),
                                              Container(
                                                width: width * 0.1,
                                                height: height * 0.08,
                                                color: index % 2 == 0
                                                    ? Colors.white
                                                    : AppColor.lightGrey,
                                                alignment: Alignment.center,
                                                child: orderRejectList[index]
                                                            .tradeType ==
                                                        'Buy'
                                                    ? Container(
                                                        width: width * 0.08,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: AppColor.green,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4)),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Text('ซื้อ',
                                                                style: AppFont
                                                                    .bodyText14),
                                                          ],
                                                        ),
                                                      )
                                                    : Container(
                                                        width: width * 0.08,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: AppColor.red,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4)),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Text('ขาย',
                                                                style: AppFont
                                                                    .bodyText14),
                                                          ],
                                                        ),
                                                      ),
                                              ),
                                              Container(
                                                width: width * 0.10,
                                                height: height * 0.08,
                                                color: index % 2 == 0
                                                    ? Colors.white
                                                    : AppColor.lightGrey,
                                                alignment: Alignment.center,
                                                child: Text(
                                                    '${orderRejectList[index].purity}',
                                                    style: AppFont.bodyText13),
                                              ),
                                              Container(
                                                width: width * 0.16,
                                                height: height * 0.08,
                                                color: index % 2 == 0
                                                    ? Colors.white
                                                    : AppColor.lightGrey,
                                                alignment: Alignment.center,
                                                child: Text(
                                                    '${AppUtility.moneyFormatWithOnlyDigit(orderRejectList[index].price!)}',
                                                    style: AppFont.bodyText13),
                                              ),
                                              Container(
                                                width: width * 0.1,
                                                height: height * 0.08,
                                                color: index % 2 == 0
                                                    ? Colors.white
                                                    : AppColor.lightGrey,
                                                alignment: Alignment.center,
                                                child: Text(
                                                    '${AppUtility.moneyFormatWithOnlyDigit(orderRejectList[index].quantity!)}',
                                                    style: AppFont.bodyText13),
                                              ),
                                              Container(
                                                width: width * 0.08,
                                                height: height * 0.08,
                                                color: index % 2 == 0
                                                    ? Colors.white
                                                    : AppColor.lightGrey,
                                                alignment: Alignment.center,
                                                child: orderRejectList[index]
                                                            .duedate ==
                                                        null
                                                    ? Text('')
                                                    : Text(
                                                        '${AppUtility.convertDateFormat(orderRejectList[index].duedate!)}',
                                                        style:
                                                            AppFont.bodyText13),
                                              ),
                                              Container(
                                                width: width * 0.12,
                                                height: height * 0.08,
                                                color: index % 2 == 0
                                                    ? Colors.white
                                                    : AppColor.lightGrey,
                                                alignment: Alignment.center,
                                                child: GestureDetector(
                                                  onTap: () => PopupOrderDialog.showOrderDetails(
                                                      context,
                                                      orderRejectList[index]
                                                          .tradeRef!,
                                                      orderRejectList[index]
                                                          .tradeType!,
                                                      orderRejectList[index]
                                                          .purity!,
                                                      AppUtility.moneyFormatWithOnlyDigit(
                                                          orderRejectList[index]
                                                              .quantity!),
                                                      AppUtility.moneyFormatWithOnlyDigit(
                                                          orderRejectList[index]
                                                              .quantityBalance!),
                                                      AppUtility.moneyFormatWithOnlyDigit(
                                                          orderRejectList[index]
                                                              .price!),
                                                      AppUtility.moneyFormatWithOnlyDigit(
                                                          orderRejectList[index]
                                                              .amount!),
                                                      AppUtility.moneyFormatWithOnlyDigit(
                                                          orderRejectList[index]
                                                              .amountBalancePaid!),
                                                      orderRejectList[index]
                                                          .status!,
                                                      orderRejectList[index]
                                                          .createDate!,
                                                      orderRejectList[index].paymentStatus!,
                                                      orderRejectList[index].createBy!,
                                                      dueDate!),
                                                  child: Image.asset(
                                                      'assets/images/zoom.png',
                                                      width: 22,
                                                      height: 22),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
