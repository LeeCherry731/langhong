import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:langhong/common/app_color.dart';
import 'package:langhong/common/app_font.dart';
import 'package:langhong/common/app_utility.dart';
import 'package:langhong/controller/mainCtr.dart';
import 'package:langhong/model/market_price.dart';
import 'package:langhong/model/portfolio.dart';
import 'package:langhong/model/user_profile.dart';
import 'package:langhong/pages/market/xauusd_gold.dart';
import 'package:langhong/pages/portfolio/asset_tab.dart';
import 'package:langhong/pages/portfolio/credit_tab.dart';
import 'package:langhong/pages/portfolio/personal_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PortfolioPage extends StatefulWidget {
  PortfolioPage() : super();

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(length: 3, vsync: this);
  SharedPreferences? sharedPreferences;
  bool isLoad = false;
  final mainCtr = Get.put(MainCtr(), tag: "MainCtr");

  final List<Tab> portfolioTabs = const <Tab>[
    Tab(text: 'ข้อมูลลูกค้า'),
    Tab(text: 'หลักประกัน'),
    Tab(text: 'เครดิต/วงเงิน')
  ];

  @override
  void initState() {
    debugPrint('Portfolio initState');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      // AppUtility.buildPopUpMenu(widget.userPortfolioList),
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  height: height * 0.05,
                  alignment: Alignment.center,
                  child: const Text('พอร์ท', style: AppFont.titleText01),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 4),
                      child: DefaultTabController(
                        length: 3,
                        initialIndex: 0,
                        child: Column(
                          children: [
                            Text(
                                'ราคาตลาด${AppUtility.convertThaiDate(mainCtr.marketPriceList[0].dateTime.toString())}',
                                style: AppFont.titleText12),
                            SizedBox(height: 3),
                            XAUUSDGold(
                                name: 'XAU/USD',
                                bidSpot: mainCtr.marketPriceList[0].bidSpot!,
                                askSpot: mainCtr.marketPriceList[0].askSpot!),
                            SizedBox(height: 10),
                            Container(
                              width: width,
                              child: TabBar(
                                  controller: tabController,
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  labelPadding:
                                      const EdgeInsets.only(left: 2, right: 2),
                                  labelStyle: AppFont.bodyText01,
                                  labelColor: AppColor.brown,
                                  unselectedLabelColor: AppColor.blueGrey,
                                  indicator: CircleTabIndicator(
                                      color: AppColor.brown, radius: 4),
                                  tabs: portfolioTabs),
                            ),
                            Container(
                              width: width,
                              height: height * 0.62,
                              child: TabBarView(
                                controller: tabController,
                                children: [
                                  PersonalTab(mainCtr.userPortfolioList.value),
                                  AssetTab(mainCtr.userPortfolioList.value),
                                  CreditTab(mainCtr.userPortfolioList.value),
                                ],
                              ),
                            ),
                          ],
                        ),
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
}

class CircleTabIndicator extends Decoration {
  late Color color;
  late double radius;

  CircleTabIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return CirclePainter(color: color, radius: radius);
  }
}

class CirclePainter extends BoxPainter {
  final double radius;
  late Color color;

  CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    late Paint paint;
    paint = Paint()..color = color;
    paint = paint..isAntiAlias = true;
    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, paint);
  }
}
