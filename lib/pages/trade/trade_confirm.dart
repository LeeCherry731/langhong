import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:langhong/api/api_services.dart';
import 'package:langhong/common/app_color.dart';
import 'package:langhong/common/app_dialog.dart';
import 'package:langhong/common/app_font.dart';
import 'package:langhong/common/app_utility.dart';
import 'package:langhong/controller/mainCtr.dart';
import 'package:langhong/model/market_price.dart';
import 'package:langhong/model/portfolio.dart';
import 'package:langhong/model/user_profile.dart';
import 'package:langhong/pages/market/xauusd_gold.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TradeConfirm extends StatefulWidget {
  // ประกาศตัวแปรมารับค่า parameter ที่ถูกส่งมาจากหน้าจอที่เรียกมา
  TradeConfirm(
      this.goldType,
      this.tradeType,
      this.tradeText,
      this.isPlace,
      this.price,
      this.quantity,
      this.ipAddress,
      this.userProfileList,
      this.userPortfolioList,
      this.marketPriceList,
      this.socket)
      : super();

  final int goldType;
  final String tradeType;
  final String tradeText;
  final bool isPlace;
  final int price;
  final int quantity;
  final String ipAddress;
  final UserProfile userProfileList;
  UserPortfolio? userPortfolioList;
  final List<MarketPrice> marketPriceList;
  late IO.Socket socket;

  @override
  _TradeConfirmState createState() => _TradeConfirmState();
}

class _TradeConfirmState extends State<TradeConfirm> {
  final mainCtr = Get.find<MainCtr>(tag: "MainCtr");

  double amount = 0;
  double assetCash = 0;
  String? goldUnit;
  String ipAddress = '';
  bool isLoad = false, isDiable = false;
  static const maxSeconds = 5;
  int seconds = maxSeconds;
  Timer? timer;

  //-- Function เคาร์ดาวน์เวลา (ตั้ง 5 วินาที)
  void startTimer() async {
    timer = Timer.periodic(Duration(milliseconds: 1000), (_) {
      if (seconds > 0) {
        setState(() => seconds--);
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    Get.back();
  }

  //-- Function แปลงหน่วยของประเภททอง และคำนวณราคารวมการซื้อ/ขาย
  void convertGoldUnit() {
    if (widget.goldType == 99) {
      goldUnit = 'กิโลกรัม';
      amount = ((widget.price * widget.quantity) * 65.6).roundToDouble();
    } else {
      goldUnit = 'บาท';
      amount = (widget.price * widget.quantity).roundToDouble();
    }
    setState(() {
      isLoad = true;
      isDiable == false;
    });
    // Countdown เวลา
    startTimer();
  }

  @override
  void initState() {
    convertGoldUnit();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: isLoad == false
          ? Center(child: CircularProgressIndicator())
          : Scaffold(
              body: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/page-bg.png'),
                      fit: BoxFit.cover),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 6, bottom: 4, left: 8, right: 8),
                  child: Column(
                    children: [
                      Container(
                        width: width,
                        height: height * 0.04,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('assets/images/logo-header.png',
                                width: width * 0.35, height: height * 0.055),
                            Spacer(),
                            Text('${widget.userProfileList.memberRef}',
                                style: AppFont.titleText04),
                            AppUtility.buildPopUpMenu(
                                widget.userPortfolioList!),
                          ],
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        height: height * 0.05,
                        alignment: Alignment.center,
                        child: const Text('ยืนยันรายการซื้อ/ขาย',
                            style: AppFont.titleText01),
                      ),
                      Container(
                        width: double.maxFinite,
                        height: Platform.isAndroid
                            ? height - (height * 0.17)
                            : height - (height * 0.19),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      'ราคาตลาด${AppUtility.convertThaiDate(widget.marketPriceList[0].dateTime.toString())}',
                                      style: AppFont.titleText12),
                                ],
                              ),
                              //-- แสดงข้อมูลราคาทอง XAU/USD
                              XAUUSDGold(
                                  name: 'XAU/USD',
                                  bidSpot:
                                      widget.marketPriceList[0].bidSpot == null
                                          ? 0
                                          : widget.marketPriceList[0].bidSpot!,
                                  askSpot:
                                      widget.marketPriceList[0].askSpot == null
                                          ? 0
                                          : widget.marketPriceList[0].askSpot!),
                              //-- แสดงข้อมูลการทำรายการซื้อ/ขาย
                              SizedBox(height: 60),
                              buildTimer(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildTimer() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.7,
      height: Platform.isAndroid ? height * 0.4 : height * 0.34,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: seconds / maxSeconds,
            valueColor: AlwaysStoppedAnimation(Colors.white),
            strokeWidth: 12,
            backgroundColor: Colors.greenAccent,
          ),
          Center(
            child: Column(
              children: [
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$seconds', style: AppFont.counterText01),
                    Text('  วินาที', style: AppFont.counterText02),
                  ],
                ),
                SizedBox(height: 2),
                widget.tradeText == 'ซื้อ'
                    ? Text(widget.tradeText, style: AppFont.bodyText10)
                    : Text(widget.tradeText, style: AppFont.bodyText09),
                Text(
                    'จำนวน ${AppUtility.moneyFormatWithOnlyDigit(widget.quantity.toDouble())} $goldUnit',
                    style: AppFont.bodyText01),
                widget.isPlace == false
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('ราคาปัจจุบัน ', style: AppFont.bodyText16),
                          Text(
                              '${AppUtility.moneyFormatWithOnlyDigit(widget.price.toDouble())} บาท',
                              style: AppFont.bodyText01)
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('ตั้งรอราคา ', style: AppFont.bodyText16),
                          Text(
                              '${AppUtility.moneyFormatWithOnlyDigit(widget.price.toDouble())} บาท',
                              style: AppFont.bodyText01)
                        ],
                      ),
                Text(
                    'ราคารวม ${AppUtility.moneyFormatWithOnlyDigit(amount)} บาท',
                    style: AppFont.bodyText01),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: width * 0.2,
                      height: height * 0.05,
                      child: ElevatedButton(
                          child: const Text('ยกเลิก', style: AppFont.btnText10),
                          style: isDiable == false
                              ? ElevatedButton.styleFrom(
                                  primary: AppColor.brown,
                                  onPrimary: AppColor.gold,
                                  shadowColor: Colors.grey,
                                  elevation: 7)
                              : ElevatedButton.styleFrom(
                                  primary: Colors.grey,
                                  onPrimary: AppColor.gold,
                                  shadowColor: Colors.grey,
                                  elevation: 7),
                          onPressed: () {
                            //-- มีการกดปุ่ม "ตกลง" confirm การซื้อ/ขายไปแล้ว ไม่ให้กดปุ่ม "ยกเลิก"
                            if (isDiable == false) {
                              Get.back();
                            }
                          }),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: width * 0.2,
                      height: height * 0.05,
                      child: ElevatedButton(
                        child: const Text('ตกลง', style: AppFont.btnText10),
                        style: isDiable == false
                            ? ElevatedButton.styleFrom(
                                primary: AppColor.brown,
                                onPrimary: AppColor.gold,
                                shadowColor: Colors.grey,
                                elevation: 7)
                            : ElevatedButton.styleFrom(
                                primary: Colors.grey,
                                onPrimary: AppColor.gold,
                                shadowColor: Colors.grey,
                                elevation: 7),
                        onPressed: () async {
                          if (isDiable == false) {
                            EasyLoading.show(status: '');
                            setState(() {
                              isDiable = true;
                            });

                            // call api append trade
                            appendTradeOrder();
                            mainCtr.getPortfolio();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //-- Function บันทึกข้อมูลการซื้อ/ขาย
  void appendTradeOrder() async {
    try {
      // stop timer
      timer?.cancel();

      var headers = {
        'Authorization': 'Bearer ${widget.userProfileList.accessToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'POST', Uri.parse('${ApiServices.domainServer}/api/trade'));
      request.body = json.encode({
        "MemberId": widget.userProfileList.memberId,
        "UserId": widget.userProfileList.userId,
        "TradeType": widget.tradeType,
        "Purity": widget.goldType,
        "Quantity": widget.quantity,
        "Price": widget.price,
        "Leave": widget.isPlace,
        "IpAddress": widget.ipAddress
      });
      request.headers.addAll(headers);

      debugPrint('headers-> $headers');
      debugPrint('body-> ${request.body}');

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint('statusCode= ${response.statusCode}');
      if (response.statusCode == 200) {
        var result = json.decode(response.body) as Map<String, dynamic>;
        debugPrint('result-> $result');
        debugPrint('Status-> ${result['Status']}');
        debugPrint('Message-> ${result['Message']}');
        debugPrint('Success-> ${result['Success']}');

        //-- บันทึกรายการซื้อ/ขาย สำเร็จ
        if (result['Success'] == true) {
          EasyLoading.dismiss();

/*
          //-- Call API Portfolio for Refresh Portfolio data
          ApiServices.getUserPortfolio(widget.userProfileList.memberId!,
                  widget.userProfileList.accessToken!)
              .then((value) {
            setState(() {
              widget.userPortfolioList = value;
            });  
            Navigator.pop(context, true);
            AppDialog.showCustomDialog(context, 0, '${result['Message']}');
          });
*/
          Navigator.pop(context, true);
          AppDialog.showCustomDialog(context, 0, '${result['Message']}');
        }
        //-- บันทึกรายการซื้อ/ขาย ไม่สำเร็จ
        else {
          EasyLoading.dismiss();
          Navigator.pop(context, false);
          AppDialog.showCustomDialog(context, 1, '${result['Message']}');
        }
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();

        AppDialog.refreshLoginDialog(
            context, widget.socket, 2, 'Session Expired/เซสชั่นหมดอายุ');
      } else if (response.statusCode == 400) {
        EasyLoading.dismiss();

        AppDialog.refreshLoginDialog(
            context, widget.socket, 2, 'API not found');
      } else {
        EasyLoading.dismiss();

        AppDialog.refreshLoginDialog(context, widget.socket, 2, 'server error');
      }
    } catch (e) {
      EasyLoading.dismiss();
      AppDialog.showCustomDialog(context, 2,
          'เกิดความผิดพลาดในการเชื่อมต่อฐานข้อมูล โปรดติดต่อแอดมินระบบ');
      throw Exception(e.toString());
    }
  }
}
