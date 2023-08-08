import 'package:flutter/material.dart';
import 'package:langhong/common/app_color.dart';
import 'package:langhong/common/app_font.dart';
import 'package:langhong/common/app_utility.dart';
import 'package:langhong/model/portfolio.dart';

class CreditTab extends StatefulWidget {
  CreditTab(this.userPortfolioList) : super();
  final UserPortfolio userPortfolioList;

  @override
  _CreditTabState createState() => _CreditTabState();
}

class _CreditTabState extends State<CreditTab> {
  @override
  void initState() {
    debugPrint('Credit Tab initState');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          height: MediaQuery.of(context).size.height * 0.8,
          child: showeCredit(),
        ),
      ],
    );
  }

  showeCredit() {
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ซื้อขายได้สูงสุดต่อครั้ง', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text(
                  '${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.maxKg!)}[Kg], ${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.maxBg!)}[Bg]',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Credit Limit', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text(
                  '${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.creditLimit!)}[kg], ${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.creditLimitBg!)}[Bg]',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Margin Type', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text('${widget.userPortfolioList.marginStatus}',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ทองฝาก', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text(
                  '${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.depositGold!)}[kg], ${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.depositGoldBg!)}[Bg]',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ปริมาณที่ซื้อ/ขายได้', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text(
                  '${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.creditLine!)}[kg], ${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.creditLineBg!)}[Bg]',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ปริมาณที่ลูกค้าซื้อได้คงเหลือ', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text(
                  '${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.creditBuyBalance!)}[kg], ${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.creditBuyBalanceBg!)}[Bg]',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ปริมาณที่ลูกค้าขายได้คงเหลือ', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text(
                  '${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.creditSellBalance!)}[kg], ${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.creditSellBalanceBg!)}[Bg]',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('จำนวนการซื้อทองคำตั้งรอราคา', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text(
                  '${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.sumBuyPlaceOrder!)}[kg], ${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.sumBuyPlaceOrderBg!)}[Bg]',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('จำนวนการขายทองคำตั้งรอราคา', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text(
                  '${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.sumSellPlaceOrder!)}[kg], ${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.sumSellPlaceOrderBg!)}[Bg]',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('จำนวนการซื้อทองคำ', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text(
                  '${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.sumBuy!)}[kg], ${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.sumBuyBg!)}[Bg]',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('จำนวนการขายทองคำ', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text(
                  '${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.sumSell!)}[kg], ${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.sumSellBg!)}[Bg]',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
      ],
    );
  }
}
