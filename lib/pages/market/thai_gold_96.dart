import 'package:flutter/material.dart';
import 'package:langhong/common/app_color.dart';
import 'package:langhong/common/app_font.dart';
import 'package:langhong/common/app_utility.dart';

class ThaiGold96 extends StatefulWidget {
  ThaiGold96({
    required this.pageCall, // หน้าจอที่เรียกมา -> 'market', 'trading'
    required this.goldType, // ประเภททอง -> 99.99%, 96.50%
    required this.name,
    required this.bid96,    
    required this.ask96
  });

  String pageCall;
  int goldType;
  String name;
  int bid96;  
  int ask96;

  @override
  _ThaiGold96State createState() => _ThaiGold96State();
}

class _ThaiGold96State extends State<ThaiGold96> {
  int? orderType; // ประเภทซื้อ/ขาย -> 1=ซื้อ, 2=ขาย
  bool isBid99 = false, isAsk99 = false, isBid96 = false, isAsk96 = false;
  String orderText = 'ลูกค้าไม่มีการทำรายการซื้อ/ขาย';

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 5, right: 5),
      child: Material(
        elevation: 8.0,
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          width: width,
          height: height*0.104,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Row(
              children: [
                Container(
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
                  width: 50,
                  height: 50,
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
                SizedBox(width: 11),
                Text(widget.name, style: AppFont.titleText11),
                Spacer(),
                bid96(width, height), 
                SizedBox(width: 6),                               
                ask96(width, height), 
              ],
            ),
          ),
        ),
      ),
    );
  }

  bid96(double width, double height) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        width: width * 0.22,
        height: height * 0.1,
/*        
        decoration: BoxDecoration(
          color: isBid96 == false ? AppColor.bid : AppColor.red,
          borderRadius: BorderRadius.circular(6),
        ),
*/        
        child: widget.pageCall == 'market'
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ขาย', style: AppFont.btnText01),
                  Text('${AppUtility.moneyFormatWithOnlyDigit(widget.bid96.toDouble())}',
                    style: AppFont.btnText01)
                ],
              )
            : GestureDetector(
                onTap: () {
                  setState(() {
                    orderType = 1;
                    orderText = 'ลูกค้าขาย ทองคำ 96.50%';
                    isBid99 = false;                    
                    isAsk99 = false;
                    isBid96 = true;                    
                    isAsk96 = false;
                  });
                  print(
                      'bid96-> isBid99=$isBid99, isAsk99=$isAsk99, isBid96=$isBid96, isAsk96= $isAsk96');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isBid96 == false
                        ? Text('ขาย', style: AppFont.btnText01)
                        : Text('ขาย', style: AppFont.btnText10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Image.asset('assets/images/baht.png', width: 20, height: 20),
                        //SizedBox(width: 8),
                        isBid96 == false
                            ? Text('${AppUtility.moneyFormatWithOnlyDigit(widget.bid96.toDouble())}',
                                style: AppFont.btnText01)
                            : Text('${AppUtility.moneyFormatWithOnlyDigit(widget.bid96.toDouble())}',
                                style: AppFont.btnText10),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  ask96(double width, double height) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        width: width * 0.22,
        height: height * 0.1,
/*        
        decoration: BoxDecoration(
          color: isAsk96 == false ? AppColor.ask : AppColor.green,
          borderRadius: BorderRadius.circular(6),
        ),
*/        
        child: widget.pageCall == 'market'
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ซื้อ', style: AppFont.btnText03),
                  Text('${AppUtility.moneyFormatWithOnlyDigit(widget.ask96.toDouble())}', style: AppFont.btnText03)
                ],
              )
            : GestureDetector(
                onTap: () {
                  setState(() {
                    orderType = 1;
                    orderText = 'ลูกค้าซื้อ ทองคำ 96.50%';
                    isBid99 = false;                    
                    isAsk99 = false;
                    isBid96 = false;                    
                    isAsk96 = true;
                  });
                  print(
                      'ask96-> isBid99=$isBid99, isAsk99=$isAsk99, isBid96=$isBid96, isAsk96= $isAsk96');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isAsk96 == false
                        ? Text('ซื้อ', style: AppFont.btnText03)
                        : Text('ซื้อ', style: AppFont.btnText10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Image.asset('assets/images/baht.png', width: 20, height: 20),
                        //SizedBox(width: 8),
                        isAsk96 == false
                            ? Text('${AppUtility.moneyFormatWithOnlyDigit(widget.ask96.toDouble())}',
                                style: AppFont.btnText03)
                            : Text('${AppUtility.moneyFormatWithOnlyDigit(widget.ask96.toDouble())}',
                                style: AppFont.btnText10),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
