import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:langhong/api/api_services.dart';
import 'package:langhong/common/app_color.dart';
import 'package:langhong/common/app_dialog.dart';
import 'package:langhong/common/app_font.dart';
import 'package:langhong/common/app_utility.dart';
import 'package:langhong/controller/mainCtr.dart';
import 'package:langhong/model/market_price.dart';
import 'package:langhong/model/order_place.dart';
import 'package:langhong/model/portfolio.dart';
import 'package:langhong/model/user_profile.dart';
import 'package:langhong/pages/home/home_page.dart';
import 'package:langhong/pages/market/xauusd_gold.dart';
import 'package:langhong/pages/orders/popup_order_details.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ShowOrderPlacePage extends StatefulWidget {
  ShowOrderPlacePage(this.socket) : super();

  late IO.Socket socket;

  @override
  _ShowOrderPlacePageState createState() => _ShowOrderPlacePageState();
}

class _ShowOrderPlacePageState extends State<ShowOrderPlacePage> {
  final mainCtr = Get.find<MainCtr>(tag: "MainCtr");

  List<OrderPlace> orderPlaceList = [];
  bool isLoad = false;

  void getOrderPlace() {
    ApiServices.getOrderPlaceTransaction(
            context,
            widget.socket,
            mainCtr.userProfileList.value.memberId ?? "",
            mainCtr.userProfileList.value.accessToken ?? "")
        .then((value) {
      setState(() {
        orderPlaceList = value;
        // จัดเรียงลำดับข้อมูลวันที่ทำรายการล่าสุดจากมากไปน้อย
        orderPlaceList.sort((a, b) => b.createDate!.compareTo(a.createDate!));
        isLoad = true;
      });
    });
  }

  void clearConnection() {
    // สั่งปิด Socket Connection จะเรียก socket.onDisconnect() ตอนเปืดให้เอง
    widget.socket.dispose();
    widget.socket.close();
  }

  @override
  void initState() {
    getOrderPlace();
    super.initState();
  }

  @override
  void dispose() {
    orderPlaceList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: isLoad == false
            ? Center(child: CircularProgressIndicator())
            : buidReportOrderPlace(width, height));
  }

  buidReportOrderPlace(double width, double height) {
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
                      onTap: () {
                        clearConnection();
                        Get.back();
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context) => HomePage(
                        //       tabPage: 3,
                        //     ),
                        //   ),
                        //   (route) => false,
                        // );
                      },
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
                child: const Text('รายการรอราคา', style: AppFont.titleText01),
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
                    child: orderPlaceList.isEmpty
                        ? Column(
                            children: [
                              SizedBox(height: height * .35),
                              const Center(
                                  child: Text('ไม่พบข้อมูลรายการรอราคา',
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
                                      itemCount: orderPlaceList.length,
                                      itemBuilder: (context, index) {
                                        var dueDate =
                                            orderPlaceList[index].duedate ==
                                                    null
                                                ? ''
                                                : orderPlaceList[index].duedate;
                                        var tradeType =
                                            orderPlaceList[index].tradeType ==
                                                    'Buy'
                                                ? 'ซื้อ'
                                                : 'ขาย';
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
                                                    '${AppUtility.convertDateFormat(orderPlaceList[index].createDate!)}',
                                                    style: AppFont.bodyText13),
                                              ),
                                              Container(
                                                width: width * 0.1,
                                                height: height * 0.08,
                                                color: index % 2 == 0
                                                    ? Colors.white
                                                    : AppColor.lightGrey,
                                                alignment: Alignment.center,
                                                child: orderPlaceList[index]
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
                                                width: width * 0.1,
                                                height: height * 0.08,
                                                color: index % 2 == 0
                                                    ? Colors.white
                                                    : AppColor.lightGrey,
                                                alignment: Alignment.center,
                                                child: Text(
                                                    '${orderPlaceList[index].purity}',
                                                    style: AppFont.bodyText13),
                                              ),
                                              Container(
                                                width: width * 0.14,
                                                height: height * 0.08,
                                                color: index % 2 == 0
                                                    ? Colors.white
                                                    : AppColor.lightGrey,
                                                alignment: Alignment.center,
                                                child: Text(
                                                    '${AppUtility.moneyFormatWithOnlyDigit(orderPlaceList[index].price!)}',
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
                                                    '${AppUtility.moneyFormatWithOnlyDigit(orderPlaceList[index].quantity!)}',
                                                    style: AppFont.bodyText13),
                                              ),
                                              Container(
                                                width: width * 0.12,
                                                height: height * 0.08,
                                                color: index % 2 == 0
                                                    ? Colors.white
                                                    : AppColor.lightGrey,
                                                alignment: Alignment.center,
                                                child: GestureDetector(
                                                  onTap: () => confirmtReject(
                                                      context,
                                                      'ต้องการยกเลิกรายการ $tradeType เลขอ้างอิง ${orderPlaceList[index].tradeRef} ?',
                                                      orderPlaceList[index]
                                                          .tradeId!,
                                                      index),
                                                  child: Image.asset(
                                                      'assets/images/rejected.png',
                                                      width: 20,
                                                      height: 20),
                                                ),
                                              ),
                                              Container(
                                                width: width * 0.09,
                                                height: height * 0.08,
                                                color: index % 2 == 0
                                                    ? Colors.white
                                                    : AppColor.lightGrey,
                                                alignment: Alignment.center,
                                                child: GestureDetector(
                                                  onTap: () => PopupOrderDialog.showOrderDetails(
                                                      context,
                                                      orderPlaceList[index]
                                                          .tradeRef!,
                                                      orderPlaceList[index]
                                                          .tradeType!,
                                                      orderPlaceList[index]
                                                          .purity!,
                                                      AppUtility.moneyFormatWithOnlyDigit(
                                                          orderPlaceList[index]
                                                              .quantity!),
                                                      AppUtility.moneyFormatWithOnlyDigit(
                                                          orderPlaceList[index]
                                                              .quantityBalance!),
                                                      AppUtility.moneyFormatWithOnlyDigit(
                                                          orderPlaceList[index]
                                                              .price!),
                                                      AppUtility.moneyFormatWithOnlyDigit(
                                                          orderPlaceList[index]
                                                              .amount!),
                                                      AppUtility.moneyFormatWithOnlyDigit(
                                                          orderPlaceList[index]
                                                              .amountBalancePaid!),
                                                      orderPlaceList[index]
                                                          .status!,
                                                      orderPlaceList[index]
                                                          .createDate!,
                                                      orderPlaceList[index].paymentStatus!,
                                                      orderPlaceList[index].createBy!,
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

  //-- Function Confirm Reject Trade
  confirmtReject(
      BuildContext context, String message, String tradeId, int row) async {
    // set up the button
    Widget cancelButton = ElevatedButton(
        child: Text('ยกเลิก', style: AppFont.btnText09),
        style: ElevatedButton.styleFrom(
            primary: AppColor.brown,
            onPrimary: AppColor.gold,
            shadowColor: Colors.grey,
            elevation: 7),
        onPressed: () => Navigator.pop(context));
    Widget confirmButton = ElevatedButton(
        child: Text('ตกลง', style: AppFont.btnText09),
        style: ElevatedButton.styleFrom(
            primary: AppColor.brown,
            onPrimary: AppColor.gold,
            shadowColor: Colors.grey,
            elevation: 7),
        onPressed: () => rejectTradeOrder(
            mainCtr.userProfileList.value.accessToken ?? "", tradeId, row));
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      content: Text(message, style: AppFont.bodyText01),
      actions: [cancelButton, confirmButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void rejectTradeOrder(String token, String tradeId, int row) {
    ApiServices.rejectTradeOrder(tradeId, token).then((value) {
      var results = value;
      debugPrint('result-> $results');
      debugPrint('Status-> ${results['Status']}');
      debugPrint('Message-> ${results['Message']}');
      debugPrint('Success-> ${results['Success']}');

      // Validate Case 401 = Token Expired
      if (results == null) {
        AppDialog.refreshLoginDialog(context, widget.socket, 2, 'ไม่พบข้อมูล');
      } else {
        if (results['Success'] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ShowOrderPlacePage(widget.socket),
            ),
          );
          AppDialog.showCustomDialog(context, 0, '${results['Message']}');
        } else {
          AppDialog.showCustomDialog(context, 2, '${results['Message']}');
          return;
        }
        mainCtr.getPortfolio();
      }
    });
  }
}
