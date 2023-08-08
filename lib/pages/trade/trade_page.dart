import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:langhong/pages/login/login_page.dart';
import 'package:langhong/pages/market/xauusd_gold.dart';
import 'package:langhong/pages/trade/trade_confirm.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TradePage extends StatefulWidget {
  TradePage(this.socket) : super();

  late IO.Socket socket;

  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  final mainCtr = Get.find<MainCtr>(tag: "MainCtr");

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController quantity = TextEditingController();
  TextEditingController placePrice = TextEditingController();
  SharedPreferences? sharedPreferences;
  double? bidSpot, askSpot;
  int? bid99, ask99, bid96, ask96, marketPrice;
  bool isPlace = true; // Default เป็นตั้งรอราคา
  bool isLoad = false, tradeStatus = false;
  bool isBid99 = false, isAsk99 = false, isBid96 = false, isAsk96 = false;
  String tradeType = ''; // คำสั่งซื้อ/ขาย-> 'Buy'=ซื้อ, 'Sell'=ขาย
  String tradeText = '', goldText = '', unitText = '';
  String ipAddress = '';
  String? memberLevel;
  int goldType = 99; // ประเภททอง-> 99=ทอง 99.99%, 96=ทอง 96.50%

  void initTradeData() {
    debugPrint('Initial Trading Data...');
    memberLevel = mainCtr.userPortfolioList.value.memberLevel;
    tradeText = '';
    goldText = '';
    unitText = '';
    quantity.clear();
    isPlace = false; // Default ไม่ตั้งรอราคา
    placePrice.clear();
    isBid99 = false;
    isAsk99 = false;
    isBid96 = false;
    isAsk96 = false;
  }

  void getPortfolio() async {
    await ApiServices.getUserPortfolio(
            mainCtr.userProfileList.value.memberId ?? "",
            mainCtr.userProfileList.value.accessToken ?? "")
        .then((value) {
      mainCtr.userPortfolioList.value = value ?? UserPortfolio();

      initTradeData();
    });
  }

  void clearConnection() {
    // สั่งปิด Socket Connection จะเรียก socket.onDisconnect() ตอนเปืดให้เอง
    widget.socket.dispose();
    widget.socket.close();
  }

  @override
  void initState() {
    debugPrint('TradingPage initState');
    super.initState();
  }

  @override
  void dispose() {
    quantity.dispose();
    placePrice.dispose();
    debugPrint('TradingPage dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('TradingPage Build');

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/page-bg.png'),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 6, bottom: 4, left: 8, right: 8),
            child: Column(
              children: [
                Container(
                  width: width,
                  height: height * 0.04,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/images/logo-header.png',
                          width: width * 0.35, height: height * 0.055),
                      // Spacer(),
                      Row(
                        children: [
                          Text('${mainCtr.userProfileList.value.memberRef}',
                              style: AppFont.titleText04),
                          AppUtility.buildPopUpMenu(
                              mainCtr.userPortfolioList.value),
                        ],
                      ),
                      // AppUtility.buildPopUpMenu(mainCtr.userPortfolioList),
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  height: height * 0.05,
                  alignment: Alignment.center,
                  child: const Text('ซื้อ/ขาย', style: AppFont.titleText01),
                ),
                Container(
                  width: double.maxFinite,
                  height: Platform.isAndroid
                      ? height - (height * 0.27)
                      : height - (height * 0.3),
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
                                'ราคาตลาด${AppUtility.convertThaiDate(mainCtr.marketPriceList[0].dateTime.toString())}',
                                style: AppFont.titleText12),
                          ],
                        ),
                        //-- แสดงข้อมูลราคาทอง XAU/USD
                        XAUUSDGold(
                            name: 'XAU/USD',
                            bidSpot: mainCtr.marketPriceList[0].bidSpot == null
                                ? 0
                                : mainCtr.marketPriceList[0].bidSpot!,
                            askSpot: mainCtr.marketPriceList[0].askSpot == null
                                ? 0
                                : mainCtr.marketPriceList[0].askSpot!),
                        //-- แสดงข้อมูลราคาทอง 99.99%
                        marketPriceThaiGold99(
                            goldType: 99,
                            bid99: mainCtr
                                        .userPortfolioList.value.memberLevel ==
                                    '1'
                                ? mainCtr.marketPriceList[0].bid99Bg1!
                                : mainCtr.userPortfolioList.value.memberLevel ==
                                        '2'
                                    ? mainCtr.marketPriceList[0].bid99Bg2!
                                    : mainCtr.userPortfolioList.value
                                                .memberLevel ==
                                            '3'
                                        ? mainCtr.marketPriceList[0].bid99Bg3!
                                        : mainCtr.marketPriceList[0].bid99Bg4!,
                            ask99: mainCtr
                                        .userPortfolioList.value.memberLevel ==
                                    '1'
                                ? mainCtr.marketPriceList[0].ask99Bg1!
                                : mainCtr.userPortfolioList.value.memberLevel ==
                                        '2'
                                    ? mainCtr.marketPriceList[0].ask99Bg2!
                                    : mainCtr.userPortfolioList.value
                                                .memberLevel ==
                                            '3'
                                        ? mainCtr.marketPriceList[0].ask99Bg3!
                                        : mainCtr.marketPriceList[0].ask99Bg4!),
                        //-- แสดงข้อมูลราคาทอง 96.50%
                        marketPriceThaiGold96(
                            goldType: 96,
                            bid96: mainCtr
                                        .userPortfolioList.value.memberLevel ==
                                    '1'
                                ? mainCtr.marketPriceList[0].bid96Bg1!
                                : mainCtr.userPortfolioList.value.memberLevel ==
                                        '2'
                                    ? mainCtr.marketPriceList[0].bid96Bg2!
                                    : mainCtr.userPortfolioList.value
                                                .memberLevel ==
                                            '3'
                                        ? mainCtr.marketPriceList[0].bid96Bg3!
                                        : mainCtr.marketPriceList[0].bid96Bg4!,
                            ask96: mainCtr
                                        .userPortfolioList.value.memberLevel ==
                                    '1'
                                ? mainCtr.marketPriceList[0].ask96Bg1!
                                : mainCtr.userPortfolioList.value.memberLevel ==
                                        '2'
                                    ? mainCtr.marketPriceList[0].ask96Bg2!
                                    : mainCtr.userPortfolioList.value
                                                .memberLevel ==
                                            '3'
                                        ? mainCtr.marketPriceList[0].ask96Bg3!
                                        : mainCtr.marketPriceList[0].ask96Bg4!),
                        //-- ทำรายการซื้อ/ขาย
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              quantitySection(width, height),
                              SizedBox(height: 2),
                              placeCheckSection(width, height),
                              priceSection(width, height),
                              SizedBox(height: 18),
                              confirmBtn(width, height)
                            ],
                          ),
                        ),
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

  marketPriceThaiGold99(
      {required int goldType, required int bid99, required int ask99}) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 5, right: 5),
      child: Material(
        elevation: 8.0,
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          width: Get.width,
          height: Get.height * 0.104,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(4, 4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4, -4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/baht.png',
                            width: 30, height: 30),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text('${goldType == 99 ? '99.99%' : '96.50%'}',
                    style: AppFont.titleText11),
                Spacer(),
                bid99Gold(Get.width, Get.height, bid99),
                SizedBox(width: 6),
                ask99Gold(Get.width, Get.height, ask99)
              ],
            ),
          ),
        ),
      ),
    );
  }

  marketPriceThaiGold96(
      {required int goldType, required int bid96, required int ask96}) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 5, right: 5),
      child: Material(
        elevation: 8.0,
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          width: Get.width,
          height: Get.height * 0.104,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(4, 4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4, -4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/baht.png',
                            width: 30, height: 30),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text('${goldType == 99 ? '99.99%' : '96.50%'}',
                    style: AppFont.titleText11),
                Spacer(),
                bid96Gold(Get.width, Get.height, bid96),
                SizedBox(width: 6),
                ask96Gold(Get.width, Get.height, ask96)
              ],
            ),
          ),
        ),
      ),
    );
  }

  bid99Gold(double width, double height, int bid99) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        width: width * 0.22,
        height: height * 0.1,
        decoration: BoxDecoration(
          color: isBid99 == false ? AppColor.bid : AppColor.red,
          borderRadius: BorderRadius.circular(6),
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              tradeType = 'Sell';
              goldType = 99;
              tradeText = 'ขาย';
              goldText = '99.99%';
              unitText = 'กิโลกรัม';
              if (quantity.text.isEmpty) {
                quantity.text = '';
              }
              marketPrice = bid99;
              isBid99 = true;
              isAsk99 = false;
              isBid96 = false;
              isAsk96 = false;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isBid99 == false
                  ? const Text('ขาย', style: AppFont.btnText01)
                  : const Text('ขาย', style: AppFont.btnText10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isBid99 == false
                      ? Text(
                          '${AppUtility.moneyFormatWithOnlyDigit(bid99.toDouble())}',
                          style: AppFont.btnText01)
                      : Text(
                          '${AppUtility.moneyFormatWithOnlyDigit(bid99.toDouble())}',
                          style: AppFont.btnText10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ask99Gold(double width, double height, int ask99) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        width: width * 0.22,
        height: height * 0.1,
        decoration: BoxDecoration(
          color: isAsk99 == false ? AppColor.ask : AppColor.green,
          borderRadius: BorderRadius.circular(6),
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              tradeType = 'Buy';
              goldType = 99;
              tradeText = 'ซื้อ';
              goldText = '99.99%';
              unitText = 'กิโลกรัม';
              if (quantity.text.isEmpty) {
                quantity.text = '';
              }
              marketPrice = ask99;
              isBid99 = false;
              isAsk99 = true;
              isBid96 = false;
              isAsk96 = false;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isAsk99 == false
                  ? const Text('ซื้อ', style: AppFont.btnText03)
                  : const Text('ซื้อ', style: AppFont.btnText10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isAsk99 == false
                      ? Text(
                          '${AppUtility.moneyFormatWithOnlyDigit(ask99.toDouble())}',
                          style: AppFont.btnText03)
                      : Text(
                          '${AppUtility.moneyFormatWithOnlyDigit(ask99.toDouble())}',
                          style: AppFont.btnText10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bid96Gold(double width, double height, int bid96) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        width: width * 0.22,
        height: height * 0.1,
        decoration: BoxDecoration(
          color: isBid96 == false ? AppColor.bid : AppColor.red,
          borderRadius: BorderRadius.circular(6),
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              tradeType = 'Sell';
              goldType = 96;
              tradeText = 'ขาย';
              goldText = '96.50%';
              unitText = 'บาท';
              if (quantity.text.isEmpty) {
                quantity.text = '';
              }
              marketPrice = bid96;
              isBid99 = false;
              isAsk99 = false;
              isBid96 = true;
              isAsk96 = false;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isBid96 == false
                  ? const Text('ขาย', style: AppFont.btnText01)
                  : const Text('ขาย', style: AppFont.btnText10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isBid96 == false
                      ? Text(
                          '${AppUtility.moneyFormatWithOnlyDigit(bid96.toDouble())}',
                          style: AppFont.btnText01)
                      : Text(
                          '${AppUtility.moneyFormatWithOnlyDigit(bid96.toDouble())}',
                          style: AppFont.btnText10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ask96Gold(double width, double height, int ask96) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        width: width * 0.22,
        height: height * 0.1,
        decoration: BoxDecoration(
          color: isAsk96 == false ? AppColor.ask : AppColor.green,
          borderRadius: BorderRadius.circular(6),
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              tradeType = 'Buy';
              goldType = 96;
              tradeText = 'ซื้อ';
              goldText = '96.50%';
              unitText = 'บาท';
              if (quantity.text.isEmpty) {
                quantity.text = '';
              }
              marketPrice = ask96;
              isBid99 = false;
              isAsk99 = false;
              isBid96 = false;
              isAsk96 = true;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isAsk96 == false
                  ? const Text('ซื้อ', style: AppFont.btnText03)
                  : const Text('ซื้อ', style: AppFont.btnText10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isAsk96 == false
                      ? Text(
                          '${AppUtility.moneyFormatWithOnlyDigit(ask96.toDouble())}',
                          style: AppFont.btnText03)
                      : Text(
                          '${AppUtility.moneyFormatWithOnlyDigit(ask96.toDouble())}',
                          style: AppFont.btnText10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  quantitySection(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: width * 0.18,
          height: height * 0.1,
          child: isBid99 || isBid96
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tradeText, style: AppFont.titleText09),
                    Text(goldText, style: AppFont.titleText09)
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tradeText, style: AppFont.titleText10),
                    Text(goldText, style: AppFont.titleText10)
                  ],
                ),
        ),
        SizedBox(width: 8),
        goldQuantity(width, height),
        SizedBox(width: 8),
        Container(
          width: width * 0.16,
          height: height * 0.08,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(unitText, style: AppFont.titleText13),
            ],
          ),
        ),
      ],
    );
  }

  placeCheckSection(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: width * 0.16,
          height: height * 0.04,
          child: Text(''),
        ),
        SizedBox(width: 8),
        Container(
          width: width * 0.5,
          height: height * 0.04,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 14),
              Checkbox(
                  value: isPlace,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        isPlace = true;
                        placePrice.text = '';
                      }
                      if (value == false) {
                        isPlace = false;
                        placePrice.text = '';
                      }
                    });
                  }),
              SizedBox(width: 2),
              Text('ตั้งรอราคา', style: AppFont.titleText11),
            ],
          ),
        ),
        SizedBox(width: 8),
        Container(
          width: width * 0.14,
          height: height * 0.04,
          child: Text(''),
        ),
      ],
    );
  }

  priceSection(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: width * 0.2,
          height: height * 0.055,
          child: Text(''),
        ),
        SizedBox(width: 8),
        goldPrice(width, height),
        SizedBox(width: 8),
        Container(
          width: width * 0.16,
          height: height * 0.055,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('บาท', style: AppFont.titleText13),
            ],
          ),
        ),
      ],
    );
  }

  tradeSection(double width, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        children: [
          Container(
            width: width,
            height: height * 0.075,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 8),
                isBid99 || isBid96
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(tradeText, style: AppFont.titleText09),
                          Text(goldText, style: AppFont.titleText09)
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(tradeText, style: AppFont.titleText10),
                          Text(goldText, style: AppFont.titleText10)
                        ],
                      ),
                goldQuantity(width, height),
                Text(unitText, style: AppFont.titleText11),
                SizedBox(width: 12),
              ],
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: width,
            height: height * 0.04,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: width * 0.25),
                Checkbox(
                    value: isPlace,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          isPlace = true;
                          placePrice.text = '';
                        }
                        if (value == false) {
                          isPlace = false;
                          placePrice.text = '';
                        }
                      });
                    }),
                SizedBox(width: 2),
                Text('ตั้งรอราคา', style: AppFont.titleText03),
              ],
            ),
          ),
          Container(
            width: width,
            height: height * 0.07,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //SizedBox(width: 8),
                Platform.isAndroid
                    ? SizedBox(width: width * 0.13)
                    : SizedBox(width: width * 0.175),
                goldPrice(width, height),
                Text('บาท', style: AppFont.titleText13),
                SizedBox(width: 12),
              ],
            ),
          ),
          SizedBox(height: 12),
          confirmBtn(width, height),
        ],
      ),
    );
  }

  goldPrice(double width, double height) {
    return Container(
      width: width * 0.4,
      height: height * 0.055,
      child: TextFormField(
        controller: placePrice,
        showCursor: true,
        maxLength: 7,
        style: AppFont.bodyText01,
        keyboardType: TextInputType.number,
        inputFormatters: [ThousandsFormatter()],
        validator: (var value) {
          return null;
        },
        decoration: InputDecoration(
          enabled: isPlace == false ? false : true,
          fillColor: isPlace == false ? AppColor.lightGrey : Colors.white,
          filled: true,
          labelText: 'ราคา',
          counterText: '',
          labelStyle: AppFont.bodyText01,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  goldQuantity(double width, double height) {
    return Container(
      width: width * 0.4,
      height: height * 0.055,
      child: TextFormField(
        controller: quantity,
        autofocus: true,
        showCursor: true,
        style: AppFont.bodyText01,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (var value) {
          return null;
        },
        decoration: InputDecoration(
          enabled: isBid99 || isAsk99 || isBid96 || isAsk96 ? true : false,
          fillColor: isBid99 || isAsk99 || isBid96 || isAsk96
              ? Colors.white
              : AppColor.lightGrey,
          filled: true,
          labelText: 'จำนวน',
          labelStyle: AppFont.bodyText01,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  confirmBtn(double width, double height) {
    var _placePrice; //= int.parse(placePrice.text); // ราคาที่ลูกค้าตั้งรอ
    var ask99MarketPrice,
        bid99MarketPrice; // ราคาซื้อ(ask)ขาย(bid) ทอง 99.99% ตลาดปัจจุบัน
    var ask96MarketPrice,
        bid96MarketPrice; // ราคาซื้อ(ask)ขาย(bid) ทอง 99.99% ตลาดปัจจุบัน

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: width * 0.32,
          height: height * 0.065,
          child: ElevatedButton(
            child: Text('ตกลง', style: AppFont.btnText09),
            style: ElevatedButton.styleFrom(
                primary: AppColor.brown,
                onPrimary: AppColor.gold,
                shadowColor: Colors.grey,
                elevation: 7),
            onPressed: () async {
              if (!formKey.currentState!.validate()) {
                return;
              }
              // 1st-> Validate กรณีราคาตลาดสถานะ Pause
              if (mainCtr.marketPriceList[0].status == 'Pause') {
                AppDialog.showCustomDialog(context, 1, 'บริษัทหยุดการซื้อขาย');
                return;
              }
              // 2nd-> Validate กรณีราคาตลาดสถานะ Stop
              if (mainCtr.marketPriceList[0].status == 'Stop') {
                clearConnection();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LoginPage(),
                  ),
                  (route) => false,
                );
                AppDialog.showCustomDialog(context, 1, 'ระบบปิดการใช้งาน');
                return;
              }
              // 3rd-> Validate กรณีไม่มีการเลือกซื้อขาย
              if (isBid99 == false &&
                  isAsk99 == false &&
                  isBid96 == false &&
                  isAsk96 == false) {
                AppDialog.showCustomDialog(
                    context, 1, 'โปรดกดซื้อ/ขาย บนราคาตลาด');
                return;
              }
              // 4th-> Validate ฟิลด์จำนวน
              if (quantity.text.trim().isEmpty) {
                AppDialog.showCustomDialog(context, 1, 'โปรดใส่จำนวนทอง');
                return;
              }
              if (quantity.text == '0') {
                AppDialog.showCustomDialog(
                    context, 1, 'โปรดใส่จำนวนทองที่มีค่ามากกว่า 0');
                return;
              }
              if (goldType == 96 && (int.parse(quantity.text) < 5)) {
                AppDialog.showCustomDialog(context, 1, 'จำนวนทองขั้นต่ำ 5 บาท');
                return;
              }
              if (goldType == 96 && ((int.parse(quantity.text) % 5) != 0)) {
                AppDialog.showCustomDialog(
                    context, 1, 'จำนวนทองต้องลงท้ายด้วย 5 หรือ 0');
                return;
              }

              // 5th-> Validate price digit and convert price from string to int
              if (isPlace == true) {
                // Validate ฟิลด์ราคา กรณีไม่ใส่อะไรเลย หรือใส่ค่า 0
                if (placePrice.text.isEmpty) {
                  AppDialog.showCustomDialog(context, 1, 'โปรดใส่ราคาทอง');
                  return;
                }
                // Validate ฟิลด์ราคา กรณีจำนวน digit <= 3 หรือ > 5
                else if (placePrice.text.length <= 5 ||
                    placePrice.text.length > 6) {
                  AppDialog.showCustomDialog(
                      context, 1, 'ตั้งรอราคาไม่ถูกต้อง');
                  return;
                }
                // Validate ฟิลด์ราคา กรณีจำนวน digit ถูกต้อง
                else {
                  //-- กรณีตั้งรอราคา ราคาต้องลงท้ายด้วย 5 หรือ 0
                  if (isPlace == true &&
                      (placePrice.text.endsWith('1') ||
                          placePrice.text.endsWith('2') ||
                          placePrice.text.endsWith('3') ||
                          placePrice.text.endsWith('4') ||
                          placePrice.text.endsWith('6') ||
                          placePrice.text.endsWith('7') ||
                          placePrice.text.endsWith('8') ||
                          placePrice.text.endsWith('9'))) {
                    AppDialog.showCustomDialog(
                        context, 1, 'ตั้งรอราคาต้องลงท้ายด้วย 5 หรือ 0');
                    return;
                  }

                  // แปลง string เป็น int
                  _placePrice = int.parse(placePrice.text.replaceAll(',', ''));

                  //-- กรณีซื้อ 99.99% ราคาที่ตั้งรอต้องน้อย(ต่ำ)กว่าราคาตลาดปัจจุบัน
                  if (isAsk99 == true) {
                    // ดึงราคาใหม่ ขณะโปรแกรมตรวจสอบเงื่อนไข
                    memberLevel == '1'
                        ? ask99MarketPrice =
                            mainCtr.marketPriceList[0].ask99Bg1!
                        : memberLevel == '2'
                            ? ask99MarketPrice =
                                mainCtr.marketPriceList[0].ask99Bg2!
                            : memberLevel == '3'
                                ? ask99MarketPrice =
                                    mainCtr.marketPriceList[0].ask99Bg3!
                                : ask99MarketPrice =
                                    mainCtr.marketPriceList[0].ask99Bg4!;

                    if (_placePrice > ask99MarketPrice) {
                      AppDialog.showCustomDialog(context, 1,
                          'ราคาตั้งรอต้องน้อยกว่า(ต่ำ)ราคาตลาดปัจจุบัน');
                      return;
                    }
                  }
                  //-- กรณีซื้อ 96.50% ราคาที่ตั้งรอต้องน้อย(ต่ำ)กว่าราคาตลาดปัจจุบัน
                  if (isAsk96 == true) {
                    // ดึงราคาใหม่ ขณะโปรแกรมตรวจสอบเงื่อนไข
                    memberLevel == '1'
                        ? ask96MarketPrice =
                            mainCtr.marketPriceList[0].ask96Bg1!
                        : memberLevel == '2'
                            ? ask96MarketPrice =
                                mainCtr.marketPriceList[0].ask96Bg2!
                            : memberLevel == '3'
                                ? ask96MarketPrice =
                                    mainCtr.marketPriceList[0].ask96Bg3!
                                : ask96MarketPrice =
                                    mainCtr.marketPriceList[0].ask96Bg4!;
                    if (_placePrice > ask96MarketPrice) {
                      AppDialog.showCustomDialog(context, 1,
                          'ราคาตั้งรอต้องน้อย(ต่ำ)กว่าราคาตลาดปัจจุบัน');
                      return;
                    }
                  }
                  //-- กรณีขาย 99.99% ราคาที่ตั้งรอต้องมาก(สูง)กว่าราคาตลาดปัจจุบัน
                  if (isBid99 == true) {
                    // ดึงราคาใหม่ ขณะโปรแกรมตรวจสอบเงื่อนไข
                    memberLevel == '1'
                        ? bid99MarketPrice =
                            mainCtr.marketPriceList[0].bid99Bg1!
                        : memberLevel == '2'
                            ? bid99MarketPrice =
                                mainCtr.marketPriceList[0].bid99Bg2!
                            : memberLevel == '3'
                                ? bid99MarketPrice =
                                    mainCtr.marketPriceList[0].bid99Bg3!
                                : bid99MarketPrice =
                                    mainCtr.marketPriceList[0].bid99Bg4!;

                    if (_placePrice < bid99MarketPrice) {
                      AppDialog.showCustomDialog(context, 1,
                          'ราคาตั้งรอต้องมาก(สูง)กว่าราคาตลาดปัจจุบัน');
                      return;
                    }
                  }
                  //-- กรณีขาย 96.50% ราคาที่ตั้งรอต้องมาก(สูง)กว่าราคาตลาดปัจจุบัน
                  if (isBid96 == true) {
                    // ดึงราคาใหม่ ขณะโปรแกรมตรวจสอบเงื่อนไข
                    memberLevel == '1'
                        ? bid96MarketPrice =
                            mainCtr.marketPriceList[0].bid96Bg1!
                        : memberLevel == '2'
                            ? bid96MarketPrice =
                                mainCtr.marketPriceList[0].bid96Bg2!
                            : memberLevel == '3'
                                ? bid96MarketPrice =
                                    mainCtr.marketPriceList[0].bid96Bg3!
                                : bid96MarketPrice =
                                    mainCtr.marketPriceList[0].bid96Bg4!;

                    if (_placePrice < bid96MarketPrice) {
                      AppDialog.showCustomDialog(context, 1,
                          'ราคาตั้งรอต้องมาก(สูง)กว่าราคาตลาดปัจจุบัน');
                      return;
                    }
                  }
                }
              }
              formKey.currentState!.save();

              final tradeStatus = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TradeConfirm(
                          goldType,
                          tradeType,
                          tradeText,
                          isPlace,
                          isPlace == true ? _placePrice : marketPrice!,
                          int.parse(quantity.text),
                          ipAddress,
                          mainCtr.userProfileList.value,
                          mainCtr.userPortfolioList.value,
                          mainCtr.marketPriceList,
                          widget.socket)));

              //-- รายการซื้อ/ขายติดเรียบร้อย เคลียร์ค่าข้อมูล
              if (tradeStatus == true) {
                //initTradeData();
                getPortfolio();
                // mainCtr.getPortfolio();
              }
            },
          ),
        ),
      ],
    );
  }
}
