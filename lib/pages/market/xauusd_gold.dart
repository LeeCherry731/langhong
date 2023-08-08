import 'package:flutter/material.dart';
import 'package:langhong/common/app_font.dart';
import 'package:langhong/common/app_utility.dart';

class XAUUSDGold extends StatelessWidget {
  XAUUSDGold({
    required this.name,
    required this.bidSpot,
    required this.askSpot,    
  });

  String name;
  double bidSpot;
  double askSpot;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;    
    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 5, right: 5),
      child: Material(
        elevation: 10.0,
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),        
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
                        Image.asset('assets/images/dollar.png', width: 30, height: 30),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 11),
                Text(name, style: AppFont.titleText13),
                Spacer(),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),                   
                  child: Container(
                    width: width * 0.22,
                    height: height * 0.08,           
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${AppUtility.moneyFormatWithDigitAndDecimal(bidSpot)}', style: AppFont.btnText01),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 6),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),                     
                  child: Container(
                    width: width * 0.22,
                    height: height * 0.08,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${AppUtility.moneyFormatWithDigitAndDecimal(askSpot)}', style: AppFont.btnText03),
                          ],
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
}