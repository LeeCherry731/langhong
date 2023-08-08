import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:langhong/common/app_color.dart';
import 'package:langhong/common/app_font.dart';
import 'package:langhong/controller/mainCtr.dart';
import 'package:langhong/model/portfolio.dart';

class PersonalTab extends StatefulWidget {
  PersonalTab(this.userPortfolioList) : super();
  final UserPortfolio userPortfolioList;

  @override
  _PersonalTabState createState() => _PersonalTabState();
}

class _PersonalTabState extends State<PersonalTab> {
  final mainCtr = Get.find<MainCtr>(tag: "MainCtr");

  @override
  void initState() {
    debugPrint('Personal Tab initState');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          height: MediaQuery.of(context).size.height * 0.8,
          child: showPersonalInfo(),
        ),
      ],
    );
  }

  showPersonalInfo() {
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('เลขที่บัญชี้อขาย', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text('${mainCtr.userPortfolioList.value.memberRef}',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ประเภทสมาชิก', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text('${mainCtr.userPortfolioList.value.memberType}',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ชื่อสมาชิก', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text('${mainCtr.userPortfolioList.value.firstName}',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('เลเวล', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text('${mainCtr.userPortfolioList.value.memberLevel}',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('กลุ่มสมาชิก', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text('${mainCtr.userPortfolioList.value.memberGroup}',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('สถานะฝั่งซื้อ', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text('${mainCtr.userPortfolioList.value.pauseBuy}',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('สถานะฝั่งขาย', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text('${mainCtr.userPortfolioList.value.pauseSell}',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Duedate T+', style: AppFont.bodyText06),
              SizedBox(width: 8.0),
              Text('${mainCtr.userPortfolioList.value.duedateValue}',
                  style: AppFont.bodyText06),
            ],
          ),
        ),
        Divider(thickness: 1, color: AppColor.lightGrey),
      ],
    );
  }
}
