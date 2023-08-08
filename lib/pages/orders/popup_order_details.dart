import 'dart:io';

import 'package:flutter/material.dart';
import 'package:langhong/common/app_color.dart';
import 'package:langhong/common/app_font.dart';
import 'package:langhong/common/app_utility.dart';

class PopupOrderDialog {
  static showOrderDetails(
      BuildContext context,
      String tradeRef,
      String tradeType,
      int purity,
      String quantity,
      String quantityBalance,
      String price,
      String amount,
      String amountBalance,
      String status,
      String createDate,
      String paymentStatus,
      String createBy,
      String dueDate) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;        
    var quantityTitle = purity == 99 ? 'ปริมาณ(กิโลกรัม)' : 'ปริมาณ(บาททอง)';
    var quantityBalanceTitle =
        purity == 99 ? 'ปริมาณคงเหลือ(กิโลกรัม)' : 'ปริมาณคงเหลือ(บาททอง)';
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(15),
              width: width * 0.8,
              height: Platform.isAndroid
                ? height * 0.6
                : height * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('รหัสอ้างอิงซื้อ/ขาย', style: AppFont.bodyText17),
                        SizedBox(width: 8.0),
                        Text('$tradeRef', style: AppFont.bodyText06),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('รายการ', style: AppFont.bodyText17),
                        SizedBox(width: 8.0),
                        tradeType == 'Buy'
                            ? Container(
                                width: width * 0.1,
                                decoration: const BoxDecoration(
                                  color: AppColor.green,
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('ซื้อ', style: AppFont.bodyText08),
                                  ],
                                ),
                              )
                            : Container(
                                width: width * 0.1,
                                decoration: const BoxDecoration(
                                  color: AppColor.red,
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('ขาย', style: AppFont.bodyText08),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ประเภททอง', style: AppFont.bodyText17),
                        SizedBox(width: 8.0),
                        Text('$purity', style: AppFont.bodyText06),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(quantityTitle, style: AppFont.bodyText17),
                        SizedBox(width: 8.0),
                        Text('$quantity', style: AppFont.bodyText06),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(quantityBalanceTitle, style: AppFont.bodyText17),
                        SizedBox(width: 8.0),
                        Text('$quantityBalance', style: AppFont.bodyText06),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ราคา(บาท)', style: AppFont.bodyText17),
                        SizedBox(width: 8.0),
                        Text('$price', style: AppFont.bodyText06),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('มูลค่า(บาท)', style: AppFont.bodyText17),
                        SizedBox(width: 8.0),
                        Text('$amount', style: AppFont.bodyText06),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('มูลค่าคงเหลือ(บาท)', style: AppFont.bodyText17),
                        SizedBox(width: 8.0),
                        Text('$amountBalance', style: AppFont.bodyText06),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('สถานะ', style: AppFont.bodyText17),
                        SizedBox(width: 8.0),
                        status == 'ยืนยันราคา'
                          ? Container(
                              width: width * 0.18,
                              height: Platform.isAndroid
                                ? height * 0.035
                                : height * 0.03,
                              decoration: const BoxDecoration(
                                color: AppColor.green,
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('$status', style: AppFont.bodyText08),
                                ],
                              ),
                            )
                          : status == 'รอราคา'
                            ? Container(
                              width: width * 0.15,
                              height: Platform.isAndroid
                                ? height * 0.035
                                : height * 0.03,
                              decoration: const BoxDecoration(
                                color: AppColor.blue,
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('$status', style: AppFont.bodyText08),
                                  ],
                                ),
                              )
                            : Container(
                              width: width * 0.15,
                              height: Platform.isAndroid
                                ? height * 0.035
                                : height * 0.03,
                              decoration: const BoxDecoration(
                                color: AppColor.red,
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('$status', style: AppFont.bodyText08),
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('วันที่ทำรายการ', style: AppFont.bodyText17),
                        SizedBox(width: 8.0),
                        Text('${AppUtility.convertDateTimeFormat(createDate)}',
                            style: AppFont.bodyText06),
                      ],
                    ),
                  ),                  
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('การรับชำระ', style: AppFont.bodyText17),
                        SizedBox(width: 8.0),
                        paymentStatus == 'ยังไม่ชำระราคา'
                          ? Container(
                              width: width * 0.24,
                              height: Platform.isAndroid
                                ? height * 0.035
                                : height * 0.03,
                              decoration: const BoxDecoration(
                                color: AppColor.orange,
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('$paymentStatus', style: AppFont.bodyText08),
                                ],
                              ),
                            )
                          : paymentStatus == 'ชำระราคาแล้ว'
                            ? Container(
                                width: width * 0.24,
                                height: Platform.isAndroid
                                  ? height * 0.035
                                  : height * 0.03,
                                decoration: const BoxDecoration(
                                  color: AppColor.green,
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('$paymentStatus', style: AppFont.bodyText08),
                                  ],
                                ),
                              )
                            : Container(
                                width: width * 0.24,
                                height: Platform.isAndroid
                                  ? height * 0.035
                                  : height * 0.03,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('$paymentStatus', style: AppFont.bodyText15),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ผู้ส่งคำสั่ง', style: AppFont.bodyText17),
                        SizedBox(width: 8.0),
                        Text('$createBy', style: AppFont.bodyText06),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('วันที่ครบกำหนดชำระ', style: AppFont.bodyText17),
                        SizedBox(width: 8.0),
                        dueDate.isEmpty
                          ? Text('')
                          : Text('${AppUtility.convertDateFormat(dueDate)}', style: AppFont.bodyText06),
                      ],
                    ),
                  ),
                 
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

String convertDateTime(String dateTime) {
  var dateFormat = DateTime.parse(dateTime);
  String month = '';
  if (dateFormat.month == 1) {
    month = 'ม.ค.';
  } else if (dateFormat.month == 2) {
    month = 'ก.พ.';
  } else if (dateFormat.month == 3) {
    month = 'มี.ค.';
  } else if (dateFormat.month == 4) {
    month = 'เม.ย.';
  } else if (dateFormat.month == 5) {
    month = 'พ.ค.';
  } else if (dateFormat.month == 6) {
    month = 'มิ.ย.';
  } else if (dateFormat.month == 7) {
    month = 'ก.ค.';
  } else if (dateFormat.month == 8) {
    month = 'ส.ค.';
  } else if (dateFormat.month == 9) {
    month = 'ก.ย.';
  } else if (dateFormat.month == 10) {
    month = 'ต.ค.';
  } else if (dateFormat.month == 11) {
    month = 'พ.ย.';
  } else if (dateFormat.month == 12) {
    month = 'ธ.ค.';
  }
  String minute = '';
  if (dateFormat.minute.toString().length == 1) {
    minute = '0' + dateFormat.minute.toString();
  } else {
    minute = dateFormat.minute.toString();
  }
  String dateTimeFormat =
      '${dateFormat.day} $month ${dateFormat.year + 543} ${dateFormat.hour}:$minute';
  return dateTimeFormat;
}
