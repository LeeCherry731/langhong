import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:langhong/common/app_color.dart';
import 'package:langhong/common/app_font.dart';
import 'package:langhong/common/app_utility.dart';
import 'package:langhong/controller/mainCtr.dart';
import 'package:langhong/model/portfolio.dart';

class AssetTab extends StatefulWidget {
  AssetTab(this.userPortfolioList) : super();
  final UserPortfolio userPortfolioList;

  @override
  _AssetTabState createState() => _AssetTabState();
}

class _AssetTabState extends State<AssetTab> {
  final mainCtr = Get.put(MainCtr(), tag: "MainCtr");

  @override
  void initState() {
    debugPrint('Asset Tab initState');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          child: showAsset(),
        ),
      ],
    );
  }

  showAsset() {
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('เงินหลักประกัน', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text(
                  '${AppUtility.moneyFormatWithOnlyDigit(mainCtr.userPortfolioList.value.assetCash ?? 0)}[THB]',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ทองหลักประกัน', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text(
                  '${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.assetGold ?? 0)}[kg], ${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.assetGoldBg ?? 0)}[Bg]',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Maintenance Margin Cash', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text(
                  '${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.maintenanceMarginCash ?? 0)}[THB]',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Maintenance Margin Gold', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text(
                  '${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.maintenanceMarginGold ?? 0)}[kg], ${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.maintenanceMarginGoldBg ?? 0)}[Bg]',
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
                  '${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.depositGold ?? 0)}[kg], ${AppUtility.moneyFormatWithOnlyDigit(widget.userPortfolioList.depositGoldBg ?? 0)}[Bg]',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
      ],
    );
  }
}
