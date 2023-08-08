import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:langhong/common/app_font.dart';
import 'package:langhong/common/app_utility.dart';
import 'package:langhong/controller/mainCtr.dart';
import 'package:langhong/model/market_price.dart';
import 'package:langhong/model/portfolio.dart';
import 'package:langhong/model/user_profile.dart';
import 'package:langhong/pages/market/thai_gold_96.dart';
import 'package:langhong/pages/market/thai_gold_99.dart';
import 'package:langhong/pages/market/xauusd_gold.dart';

class MarketPricePage extends StatefulWidget {
  MarketPricePage() : super();

  @override
  _MarketPricePageState createState() => _MarketPricePageState();
}

class _MarketPricePageState extends State<MarketPricePage> {
  late InAppWebViewController webViewController;
  // String? mainCtr.userPortfolioList. memberLevel;
  final mainCtr = Get.find<MainCtr>(tag: "MainCtr");

  bool isLoad = false;

  @override
  void initState() {
    debugPrint('MarketPage Init');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('MarketPage Build');
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/page-bg.png'),
                fit: BoxFit.cover),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 6, bottom: 4, left: 8, right: 8),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: const Text('ตลาด', style: AppFont.titleText01),
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
                  child: SingleChildScrollView(
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
                          SizedBox(height: 3),
                          XAUUSDGold(
                              name: 'XAU/USD',
                              bidSpot:
                                  mainCtr.marketPriceList[0].bidSpot == null
                                      ? 0
                                      : mainCtr.marketPriceList[0].bidSpot!,
                              askSpot:
                                  mainCtr.marketPriceList[0].askSpot == null
                                      ? 0
                                      : mainCtr.marketPriceList[0].askSpot!),
                          ThaiGold99(
                              pageCall: 'market',
                              goldType: 99,
                              name: '99.99%',
                              bid99: mainCtr.userPortfolioList.value
                                          .memberLevel ==
                                      '1'
                                  ? mainCtr.marketPriceList[0].bid99Bg1!
                                  : mainCtr.userPortfolioList.value
                                              .memberLevel ==
                                          '2'
                                      ? mainCtr.marketPriceList[0].bid99Bg2!
                                      : mainCtr.userPortfolioList.value
                                                  .memberLevel ==
                                              '3'
                                          ? mainCtr.marketPriceList[0].bid99Bg3!
                                          : mainCtr
                                              .marketPriceList[0].bid99Bg4!,
                              ask99: mainCtr.userPortfolioList.value
                                          .memberLevel ==
                                      '1'
                                  ? mainCtr.marketPriceList[0].ask99Bg1!
                                  : mainCtr.userPortfolioList.value
                                              .memberLevel ==
                                          '2'
                                      ? mainCtr.marketPriceList[0].ask99Bg2!
                                      : mainCtr.userPortfolioList.value
                                                  .memberLevel ==
                                              '3'
                                          ? mainCtr.marketPriceList[0].ask99Bg3!
                                          : mainCtr
                                              .marketPriceList[0].ask99Bg4!),
                          ThaiGold96(
                              pageCall: 'market',
                              goldType: 96,
                              name: '96.50%',
                              bid96: mainCtr.userPortfolioList.value
                                          .memberLevel ==
                                      '1'
                                  ? mainCtr.marketPriceList[0].bid96Bg1!
                                  : mainCtr.userPortfolioList.value
                                              .memberLevel ==
                                          '2'
                                      ? mainCtr.marketPriceList[0].bid96Bg2!
                                      : mainCtr.userPortfolioList.value
                                                  .memberLevel ==
                                              '3'
                                          ? mainCtr.marketPriceList[0].bid96Bg3!
                                          : mainCtr
                                              .marketPriceList[0].bid96Bg4!,
                              ask96: mainCtr.userPortfolioList.value
                                          .memberLevel ==
                                      '1'
                                  ? mainCtr.marketPriceList[0].ask96Bg1!
                                  : mainCtr.userPortfolioList.value
                                              .memberLevel ==
                                          '2'
                                      ? mainCtr.marketPriceList[0].ask96Bg2!
                                      : mainCtr.userPortfolioList.value
                                                  .memberLevel ==
                                              '3'
                                          ? mainCtr.marketPriceList[0].ask96Bg3!
                                          : mainCtr
                                              .marketPriceList[0].ask96Bg4!),
                          SizedBox(height: 12),
                          showTradingviewGraph(width, height),
                        ],
                      ),
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

  showTradingviewGraph(double width, double height) {
    return Container(
      //width: double.infinity,
      height:
          height * 0.3, //Platform.isAndroid ? height * 0.31 : height * 0.36,
      child: InAppWebView(
        initialData: InAppWebViewInitialData(data: """
<!-- TradingView Widget BEGIN -->
<div class="tradingview-widget-container">
  <div id="tradingview_35bcd"></div>
  <div class="tradingview-widget-copyright"><a href="https://th.tradingview.com/symbols/XAUUSD/" rel="noopener" target="_blank"><span class="blue-text">XAUUSD ชาร์ต</span></a> โดย TradingView</div>
  <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
  <script type="text/javascript">
  new TradingView.widget(
  {
  "autosize": true,
  "symbol": "OANDA:XAUUSD",
  "interval": "60",
  "timezone": "Etc/UTC",
  "theme": "light",
  "style": "1",
  "locale": "th_TH",
  "toolbar_bg": "#f1f3f6",
  "enable_publishing": false,
  "hide_side_toolbar": false,
  "allow_symbol_change": true,
  "save_image": false,
  "container_id": "tradingview_35bcd"
}
  );
  </script>
</div>
<!-- TradingView Widget END -->
                      """),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(javaScriptEnabled: true),
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          webViewController = controller;
          webViewController.addJavaScriptHandler(
              handlerName: 'handlerFoo',
              callback: (args) {
                return {'bar': 'bar_value', 'baz': 'baz_value'};
              });
          webViewController.addJavaScriptHandler(
              handlerName: 'handlerFooWithArgs',
              callback: (args) {
                print(args);
                // it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]
              });
          onConsoleMessage:
          (controller, consoleMessage) {
            print(consoleMessage);
            // it will print: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
          };
        },
      ),
    );
  }
}
