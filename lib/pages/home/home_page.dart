import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:langhong/common/app_dialog.dart';
import 'package:langhong/controller/mainCtr.dart';
import 'package:langhong/model/portfolio.dart';
import 'package:langhong/model/user_profile.dart';
import 'package:langhong/pages/login/login_page.dart';
import 'package:langhong/pages/trade/trade_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:langhong/api/api_services.dart';
import 'package:langhong/common/app_font.dart';
import 'package:langhong/model/market_price.dart';
import 'package:langhong/pages/market/market_price_page.dart';
import 'package:langhong/pages/orders/order_menu.dart';
import 'package:langhong/pages/portfolio/portfolio_page.dart';
import 'package:langhong/pages/settings/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({
    required this.tabPage,
  });
  final int tabPage;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late IO.Socket socket;
  SharedPreferences? sharedPreferences;
  List<MarketPrice> marketPriceList = [];
  bool isLogin = false, isLoad = false;
  String userName = '', memberRef = '', userId = '', memberLevel = '';
  int currentIndex = 0, amtMarketPrice = 0;
  final inactiveColor = Colors.grey;
  var dataList = [];

  final mainCtr = Get.find<MainCtr>(tag: "MainCtr");

  void getMarketPrice() {
    debugPrint('get Market Price');
    try {
      socket = IO.io(
          '${ApiServices.domainSocket}',
          OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .build());
      socket.connect();
      socket.onConnect((_) => debugPrint('connect: ${socket.id}'));
      socket.onConnect((_) {
        socket.on('marketprice', (data) {
          debugPrint('Market Price-> $data');
          dataList = data as List;
          marketPriceList = [];
          for (final items in dataList) {
            MarketPrice marketPrice = MarketPrice(
                ask99Bg1: items['ask99Bg1'],
                bid99Bg1: items['bid99Bg1'],
                ask99Bg2: items['ask99Bg2'],
                bid99Bg2: items['bid99Bg2'],
                ask99Bg3: items['ask99Bg3'],
                bid99Bg3: items['bid99Bg3'],
                ask99Bg4: items['ask99Bg4'],
                bid99Bg4: items['bid99Bg4'],
                ask96Bg1: items['ask96Bg1'],
                bid96Bg1: items['bid96Bg1'],
                ask96Bg2: items['ask96Bg2'],
                bid96Bg2: items['bid96Bg2'],
                ask96Bg3: items['ask96Bg3'],
                bid96Bg3: items['bid96Bg3'],
                ask96Bg4: items['ask96Bg4'],
                bid96Bg4: items['bid96Bg4'],
                askSpot: double.parse(items['AskSpot'].toString()),
                bidSpot: double.parse(items['BidSpot'].toString()),
                dateTime: items['Datetime'],
                status: items['status']);

            marketPriceList.add(marketPrice);
            mainCtr.marketPriceList(marketPriceList);

            setState(() {
              marketPriceList;

              isLoad = true;
            });
          }
        });
      });
      //-- สั่งไว้สำหรับเรียกปิด socket.dispose()->socket.close() ตอนสั่ง logout
      socket.onDisconnect((_) async {
        debugPrint('disconnect');
        socket.disconnect();

        AppDialog.refreshLoginDialog(
            context, socket, 2, 'ขาดการเชื่อมต่อจาก sever ราคา');
      });
      socket.onConnectTimeout((data) => AppDialog.refreshLoginDialog(
          context, socket, 2, 'ไม่สามารถเชื่อมต่อ sever ราคาได้'));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  void initState() {
    debugPrint('Home Init');

    currentIndex = widget.tabPage;

    //-- โหลดข้อมูลราคาตลาด
    getMarketPrice();

    super.initState();
  }

  @override
  void dispose() {
    debugPrint('HomePage dispose');
    dataList.clear();
    marketPriceList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    debugPrint('Home Build');
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        AppDialog.showExitCustomDialog(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: isLoad == false
              ? Center(child: CircularProgressIndicator())
              : getTabPage(),
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.redAccent,
            labelTextStyle: MaterialStateProperty.all(AppFont.bodyText04),
          ),
          child: NavigationBar(
            height: height * 0.11,
            backgroundColor: Colors.black,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            animationDuration: const Duration(seconds: 3),
            selectedIndex: currentIndex,
            onDestinationSelected: (index) =>
                setState(() => currentIndex = index),
            destinations: [
              NavigationDestination(
                icon: Image.asset('assets/images/market.png',
                    width: 22, height: 22, color: Colors.white),
                //selectedIcon: ,
                label: 'ตลาด',
              ),
              NavigationDestination(
                icon: Image.asset('assets/images/trade.png',
                    width: 28, height: 28, color: Colors.white),
                label: 'ซื้อ/ขาย',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person, color: Colors.white, size: 26),
                label: 'พอร์ท',
              ),
              const NavigationDestination(
                icon: Icon(Icons.poll, color: Colors.white, size: 26),
                label: 'รายงาน',
              ),
              const NavigationDestination(
                icon: Icon(Icons.toc, color: Colors.white, size: 28),
                label: 'เมนู',
              ),
            ],
          ),
        ),
      ),
    );
  }

  getTabPage() {
    List<Widget> pages = [
      MarketPricePage(),
      TradePage(socket),
      PortfolioPage(),
      OrderMenuPage(socket),
      SettingsPage(socket),
    ];
    return IndexedStack(
      index: currentIndex,
      children: pages,
    );
  }
}
