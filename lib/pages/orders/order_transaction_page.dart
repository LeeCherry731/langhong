import 'package:flutter/material.dart';
import 'package:langhong/common/app_font.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:langhong/model/order_trans.dart';

class OrderTransactionPage extends StatefulWidget {
  const OrderTransactionPage({Key? key}) : super(key: key);

  @override
  _OrderTransactionPageState createState() => _OrderTransactionPageState();
}

class _OrderTransactionPageState extends State<OrderTransactionPage> {
  List<OrderTrans>? orderTransList;

  final GlobalKey<ExpansionTileCardState> cardOrder = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardWaittingPrice = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardConfirmPrice = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardCancelOrder = GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardOutstandingOrder = GlobalKey();

/*
    // ดึงข้อมูลการซื้อ/ขาย
    ApiServices.getOrderTransaction().then((value) {
      setState(() {
        orderTransList = value;
      });
      print(orderTransList);
    });
*/

  @override
  Widget build(BuildContext context) {

    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                height: height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/page-bg.png'),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 10,
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset('assets/images/logo-header.png',
                          width: width * 0.35, height: height * 0.055),
                    ],
                  ),
                  Row(
                    children: const [
                      Text('คำสั่งซื้อ/ขาย', style: AppFont.titleText01),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              top: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  width: width * 0.92,
                  height: height * 0.71,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ListView(
                      children: [
                        orderTranasction(),
                        waittingPriceTranasction(),
                        confirmPriceTranasction(),
                        cancelOrderTranasction(),
                        outStandingOrderTranasction(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  orderTranasction() {
    return ExpansionTileCard(
      key: cardOrder,
      title: const Text('รายการซื้อ/ขาย', style: AppFont.bodyText05),
      //subtitle: Text('Tap'),
      children: [
        Column(
          children: [
            Row(
              children: const [
                Text('รหัสอ้างอิง', style: AppFont.bodyText06),
                Spacer(),
                Text('รายการ', style: AppFont.bodyText06),
                Spacer(),
                Text('ประเภททอง', style: AppFont.bodyText06),
                Spacer(),
                Text('ราคา', style: AppFont.bodyText06),
                Spacer(),
                Text('จำนวน', style: AppFont.bodyText06),
                Spacer(),
                Text('    '),
              ],
            ),
          ],
        ),
      ],
    );
  }

  waittingPriceTranasction() {
    return ExpansionTileCard(
      key: cardWaittingPrice,
      title: const Text('รายการยืนยันราคา', style: AppFont.bodyText05),
      //subtitle: Text('Tap'),
      children: [
        Column(
          children: [
            Row(
              children: const [
                Text('รหัสอ้างอิง', style: AppFont.bodyText06),
                Spacer(),
                Text('รายการ', style: AppFont.bodyText06),
                Spacer(),
                Text('ประเภททอง', style: AppFont.bodyText06),
                Spacer(),
                Text('ราคา', style: AppFont.bodyText06),
                Spacer(),
                Text('จำนวน', style: AppFont.bodyText06),
                Spacer(),
                Text('    '),
              ],
            ),
          ],
        ),
      ],
    );
  }

  confirmPriceTranasction() {
    return ExpansionTileCard(
      key: cardConfirmPrice,
      title: const Text('รายการยืนยันราคา', style: AppFont.bodyText05),
      //subtitle: Text('Tap'),
      children: [
        Column(
          children: [
            Row(
              children: const [
                Text('รหัสอ้างอิง', style: AppFont.bodyText06),
                Spacer(),
                Text('รายการ', style: AppFont.bodyText06),
                Spacer(),
                Text('ประเภททอง', style: AppFont.bodyText06),
                Spacer(),
                Text('ราคา', style: AppFont.bodyText06),
                Spacer(),
                Text('จำนวน', style: AppFont.bodyText06),
                Spacer(),
                Text('    '),
              ],
            ),
          ],
        ),
      ],
    );
  }

  cancelOrderTranasction() {
    return ExpansionTileCard(
      key: cardCancelOrder,
      title: const Text('รายการยกเลิก', style: AppFont.bodyText05),
      //subtitle: Text('Tap'),
      children: [
        Column(
          children: [
            Row(
              children: const [
                Text('รหัสอ้างอิง', style: AppFont.bodyText06),
                Spacer(),
                Text('รายการ', style: AppFont.bodyText06),
                Spacer(),
                Text('ประเภททอง', style: AppFont.bodyText06),
                Spacer(),
                Text('ราคา', style: AppFont.bodyText06),
                Spacer(),
                Text('จำนวน', style: AppFont.bodyText06),
                Spacer(),
                Text('    '),
              ],
            ),
          ],
        ),
      ],
    );
  }

  outStandingOrderTranasction() {
    return ExpansionTileCard(
      key: cardOutstandingOrder,
      title: const Text('รายการสถานะคงค้าง', style: AppFont.bodyText05),
      //subtitle: Text('Tap'),
      children: [
        Column(
          children: [
            Row(
              children: const [
                Text('รหัสอ้างอิง', style: AppFont.bodyText06),
                Spacer(),
                Text('รายการ', style: AppFont.bodyText06),
                Spacer(),
                Text('ประเภททอง', style: AppFont.bodyText06),
                Spacer(),
                Text('ราคา', style: AppFont.bodyText06),
                Spacer(),
                Text('จำนวน', style: AppFont.bodyText06),
                Spacer(),
                Text('    '),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
