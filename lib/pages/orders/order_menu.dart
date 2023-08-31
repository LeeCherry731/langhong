import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:langhong/common/app_color.dart';
import 'package:langhong/common/app_font.dart';
import 'package:langhong/common/app_utility.dart';
import 'package:langhong/controller/mainCtr.dart';
import 'package:langhong/model/market_price.dart';
import 'package:langhong/model/order_menu.dart';
import 'package:langhong/model/portfolio.dart';
import 'package:langhong/model/user_profile.dart';
import 'package:langhong/pages/market/xauusd_gold.dart';
import 'package:langhong/pages/orders/show_order_accept.dart';
import 'package:langhong/pages/orders/show_order_place.dart';
import 'package:langhong/pages/orders/show_order_reject.dart';
import 'package:langhong/pages/orders/show_order_trans.dart';
import 'package:langhong/pages/orders/show_order_unpaid.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class OrderMenuPage extends StatefulWidget {
  OrderMenuPage(this.socket) : super();

  late IO.Socket socket;

  @override
  _OrderMenuPageState createState() => _OrderMenuPageState();
}

class _OrderMenuPageState extends State<OrderMenuPage> {
  final mainCtr = Get.find<MainCtr>(tag: "MainCtr");

  List<OrderMenu> orderMenuList = OrderMenu.getOrderMenuData();
  bool isLoad = false;

  @override
  void initState() {
    debugPrint('OrdersPage init');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('OrdersPage Build');
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
                  child: const Text('ประวัติรายการซื้อ/ขาย',
                      style: AppFont.titleText01),
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
                            height: height * 0.5,
                            child: ListView.builder(
                              itemCount: orderMenuList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: AppColor.lightGrey),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                        '${orderMenuList[index].transName}',
                                        style: AppFont.bodyText05),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        if (orderMenuList[index].transId == 1) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShowOrderTransPage(
                                                          widget.socket)));
                                        }
                                        if (orderMenuList[index].transId == 2) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShowOrderPlacePage(
                                                          widget.socket)));
                                        }
                                        if (orderMenuList[index].transId == 3) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShowOrderAcceptPage(
                                                          widget.socket)));
                                        }
                                        if (orderMenuList[index].transId == 4) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShowOrderRejectPage(
                                                          widget.socket)));
                                        }
                                        if (orderMenuList[index].transId == 5) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShowOrderUnpaidPage(
                                                          widget.socket)));
                                        }
                                      },
                                      child:
                                          const Icon(Icons.play_circle_outline),
                                    ),
                                  ),
                                );
                              },
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
      ),
    );
  }
}
