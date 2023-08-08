import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:langhong/common/app_font.dart';
import 'package:langhong/model/portfolio.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUtility {
  // แปลงวันที่ไทย
  static String convertThaiDate(String marketDate) {
    var dateTimeFormat;
    Intl.defaultLocale = 'th';
    initializeDateFormatting();
    var formatter = DateFormat.yMMMMEEEEd();
    dateTimeFormat =
        formatter.formatInBuddhistCalendarThai(DateTime.parse(marketDate));
    var formatTime = DateFormat.Hm();
    return dateTimeFormat + ' ' + formatTime.format(DateTime.parse(marketDate));
  }

  static Future<String> getIpAddress() async {
    String ipv4 = await Ipify.ipv4();
    return ipv4;
  }

  static Future<double?> getBidSpot() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getDouble('bidSpot');
  }

  static Future<double?> getAskSpot() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getDouble('askSpot');
  }

  static Future<void> clearSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

  // ตรวจสอบการเข้าระบบผู้ใช้งาน
  static Future<bool> userIsLogin(String pageCall) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isLogin = sharedPreferences.getBool('isLogin') == true ? true : false;
    debugPrint('-> Checking for user login of $pageCall? $isLogin');
    return isLogin;
  }

  static Future<String?> getUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('username');
  }

  static Future<String?> getMemberRef() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('memberRef');
  }

  static Future<String?> getMemberId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('memberId');
  }

  static Future<String?> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('userId');
  }

  static Future<String?> getMemberLevel() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('memberLevel');
  }

  static String getCreditLimit(double creditLimit, double creditLimitBg) {
    if (creditLimit == null) {
      return '0[Kg], 0[Bg]';
    } else {
      return moneyFormatWithOnlyDigit(creditLimit) +
          '[Kg], ' +
          moneyFormatWithOnlyDigit(creditLimitBg) +
          '[Bg]';
    }
  }

  static String getCreditBuyBalance(
      double creditBuyBalance, double creditBuyBalanceBg) {
    if (creditBuyBalance == null) {
      return '0[Kg], 0[Bg]';
    } else {
      return moneyFormatWithOnlyDigit(creditBuyBalance) +
          '[Kg], ' +
          moneyFormatWithOnlyDigit(creditBuyBalanceBg) +
          '[Bg]';
    }
  }

  static String getCreditSellBalance(
      double creditSellBalance, double creditSellBalanceBg) {
    if (creditSellBalance == null) {
      return '0[Kg], 0[Bg]';
    } else {
      return moneyFormatWithOnlyDigit(creditSellBalance) +
          '[Kg], ' +
          moneyFormatWithOnlyDigit(creditSellBalanceBg) +
          '[Bg]';
    }
  }

  // แปลง Number Format-> ใส่คอมมาให้ตัวเลขและตัดทศนิยมออก ตย. 12345.9087 -> 12,345
  static String moneyFormatWithOnlyDigit(double value) {
    MoneyFormatterOutput mf = MoneyFormatter(amount: value).output;
    return mf.withoutFractionDigits;
  }

  // แปลง Number Format-> ใส่คอมมาให้ตัวเลขและทดทศนิยม 2 หลัก ตย. 12345.9087 -> 12,345.91
  static String moneyFormatWithDigitAndDecimal(double value) {
    MoneyFormatterOutput mf = MoneyFormatter(amount: value).output;
    return mf.nonSymbol;
  }

  // สร้าง Popup Menu ผู้ใช้งาน
  static buildPopUpMenu(UserPortfolio portfolioList) {
    String pauseBuy = portfolioList.pauseBuy == false ? 'Pause' : 'unPause';
    String pauseSell = portfolioList.pauseSell == false ? 'Pause' : 'unPause';
    String creditLimit = AppUtility.getCreditLimit(
        portfolioList.creditLimit ?? 0, portfolioList.creditLimitBg ?? 0);
    String creditBuyBalance = AppUtility.getCreditBuyBalance(
        portfolioList.creditBuyBalance ?? 0,
        portfolioList.creditBuyBalanceBg ?? 0);
    String creditSellBalance = AppUtility.getCreditSellBalance(
        portfolioList.creditSellBalance ?? 0,
        portfolioList.creditSellBalanceBg ?? 0);

    return PopupMenuButton(
        icon: const Icon(Icons.more_vert, size: 14),
        offset: const Offset(2, 30),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.all(5),
        itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('เลเวล', style: AppFont.bodyText18),
                    Text(portfolioList.memberLevel ?? "",
                        style: AppFont.bodyText18),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('สถานะฝั่งซื้อ', style: AppFont.bodyText18),
                    Text(pauseBuy, style: AppFont.bodyText18),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('สถานะฝั่งขาย', style: AppFont.bodyText18),
                    Text(pauseSell, style: AppFont.bodyText18),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('เงินหลักประกัน', style: AppFont.bodyText18),
                    Text(
                        '${moneyFormatWithOnlyDigit(portfolioList.assetCash ?? 0)}',
                        style: AppFont.bodyText18),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Credit Limit', style: AppFont.bodyText18),
                    Text(creditLimit, style: AppFont.bodyText18),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ปริมาณซื้อได้คงเหลือ', style: AppFont.bodyText18),
                    Text(creditBuyBalance, style: AppFont.bodyText18),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ปริมาณขายได้คงเหลือ', style: AppFont.bodyText18),
                    Text(creditSellBalance, style: AppFont.bodyText18),
                  ],
                ),
              ),
            ]);
  }

  static String convertDateFormat(String dateTime) {
    var dateTimeFormat = DateTime.parse(dateTime);
    String month = '';
    if (dateTimeFormat.month.toString().length == 1) {
      month = '0' + dateTimeFormat.month.toString();
    } else {
      month = dateTimeFormat.month.toString();
    }
    String dateFormat = dateTimeFormat.day.toString() +
        '/' +
        month +
        '/' +
        dateTimeFormat.year.toString();
    return dateFormat;
  }

  static String convertDateTimeFormat(String dateTime) {
    var dateTimeFormat = DateTime.parse(dateTime);

    // check digit of month
    String month = '';
    if (dateTimeFormat.month.toString().length == 1) {
      month = '0' + dateTimeFormat.month.toString();
    } else {
      month = dateTimeFormat.month.toString();
    }

    // chech digit of minute
    String minute = '';
    if (dateTimeFormat.minute.toString().length == 1) {
      minute = '0' + dateTimeFormat.minute.toString();
    } else {
      minute = dateTimeFormat.minute.toString();
    }

    String dateFormat = dateTimeFormat.day.toString() +
        '/' +
        month +
        '/' +
        dateTimeFormat.year.toString() +
        ' ' +
        dateTimeFormat.hour.toString() +
        ':' +
        minute;
    return dateFormat;
  }
}
