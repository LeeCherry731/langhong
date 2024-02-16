import 'dart:io';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:langhong/api/api_services.dart';
import 'package:langhong/common/app_color.dart';
import 'package:langhong/common/app_dialog.dart';
import 'package:langhong/common/app_font.dart';
import 'package:langhong/common/app_utility.dart';
import 'package:langhong/controller/mainCtr.dart';
import 'package:langhong/model/market_price.dart';
import 'package:langhong/model/portfolio.dart';
import 'package:langhong/model/user_profile.dart';
import 'package:langhong/pages/login/login_page.dart';
import 'package:langhong/pages/market/xauusd_gold.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SettingsPage extends StatefulWidget {
  SettingsPage(this.socket) : super();

  late IO.Socket socket;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ExpansionTileCardState> changeUserName = GlobalKey();
  final GlobalKey<ExpansionTileCardState> changePassword = GlobalKey();
  TextEditingController memberName = TextEditingController();
  TextEditingController confirmMemberName = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmNewPassword = TextEditingController();
  final mainCtr = Get.find<MainCtr>(tag: "MainCtr");

  void clearAllBeforeExit() {
    debugPrint('SettingPage Clear All before Exit...');
    memberName.clear();
    confirmMemberName.clear();
    newPassword.clear();
    confirmNewPassword.clear();
    mainCtr.marketPriceList.clear();

    mainCtr.userProfileList(UserProfile());
    mainCtr.userPortfolioList(UserPortfolio());
    mainCtr.marketPriceList(<MarketPrice>[]);
    // สั่งปิด Socket Connection จะเรียก socket.onDisconnect() ตอนเปืดให้เอง
    widget.socket.dispose();
    widget.socket.close();
  }

  @override
  void initState() {
    debugPrint('SettingPage init');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('SettingPage Build');
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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
                    child: const Text('เมนู', style: AppFont.titleText01),
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
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    'ราคาตลาด${AppUtility.convertThaiDate(mainCtr.marketPriceList[0].dateTime.toString())}',
                                    style: AppFont.titleText12),
                              ],
                            ),
                            //-- แสดงข้อมูลราคาทอง XAU/USD
                            XAUUSDGold(
                                name: 'XAU/USD',
                                bidSpot:
                                    mainCtr.marketPriceList[0].bidSpot == null
                                        ? 0
                                        : mainCtr.marketPriceList[0].bidSpot!,
                                askSpot:
                                    mainCtr.marketPriceList[0].askSpot == null
                                        ? 0
                                        : mainCtr.marketPriceList[0].askSpot!),
                            //-- แสดงรายการเมนู
                            SizedBox(height: 20),
                            menuChangeUserName(width, height),
                            Divider(thickness: 1, color: AppColor.lightGrey),
                            menuChangePassword(width, height),
                            Divider(thickness: 1, color: AppColor.lightGrey),
                            menuExit(),
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
      ),
    );
  }

  menuChangeUserName(double width, double height) {
    return ExpansionTileCard(
      key: changeUserName,
      leading: Image.asset('assets/images/user.png', width: 18, height: 18),
      title: Text('เปลี่ยนชื่อสมาชิก', style: AppFont.bodyText05),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  inputMemberName(width, height),
                  SizedBox(width: 55),
                  Text(' ')
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  inputConfirmMemberName(width, height),
                  SizedBox(width: 30),
                  submitChangeUserNameBtn(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  inputMemberName(double width, double height) {
    return Container(
      width: width * 0.5,
      height: height * 0.05,
      child: TextFormField(
        controller: memberName,
        style: AppFont.bodyText01,
        validator: (var value) {
          return null;
        },
        decoration: InputDecoration(
            labelText: 'ชื่อสมาชิกใหม่',
            labelStyle: AppFont.bodyText01,
            fillColor: AppColor.whiteGrey,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.biteSweet)),
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.biteSweet)),
            errorStyle: const TextStyle(color: AppColor.biteSweet)),
      ),
    );
  }

  inputConfirmMemberName(double width, double height) {
    return Container(
      width: width * 0.5,
      height: height * 0.05,
      child: TextFormField(
        controller: confirmMemberName,
        style: AppFont.bodyText01,
        validator: (var value) {
          return null;
        },
        decoration: InputDecoration(
            labelText: 'ยืนยันชื่อสมาชิกใหม่',
            labelStyle: AppFont.bodyText01,
            fillColor: AppColor.whiteGrey,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.biteSweet)),
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.biteSweet)),
            errorStyle: const TextStyle(color: AppColor.biteSweet)),
      ),
    );
  }

  submitChangeUserNameBtn() {
    return GestureDetector(
      onTap: () {
        if (memberName.text.trim().isEmpty) {
          AppDialog.showCustomDialog(context, 1, 'ใส่ชื่อสมาชิกใหม่');
          return;
        } else if (memberName.text.trim() ==
            mainCtr.userProfileList.value.userName) {
          AppDialog.showCustomDialog(
              context, 1, 'ชื่อสมาชิกใหม่ ต้องเป็นชื่อไม่ซ้ำกับชื่อเดิม');
          return;
        } else if (confirmMemberName.text.isEmpty) {
          AppDialog.showCustomDialog(context, 1, 'ใส่ยืนยันชื่อสมาชิกใหม่');
          return;
        } else if (confirmMemberName.text.trim() != memberName.text.trim()) {
          AppDialog.showCustomDialog(context, 1, 'ชื่อสมาชิกใหม่ไม่ตรงกัน');
          return;
        }

        // Call API Change Username
        //changeUserNameData();
        ApiServices.changeUserName(
                mainCtr.userProfileList.value.accessToken ?? "",
                mainCtr.userProfileList.value.userId ?? "",
                memberName.text)
            .then((value) {
          var results = value;

          debugPrint('result-> $results');
          debugPrint('Status-> ${results['Status']}');
          debugPrint('Message-> ${results['Message']}');
          debugPrint('Success-> ${results['Success']}');

          if (results['Success'] == true) {
            //-- เปลี่ยนชื่อสำเร็จ ให้ logout ออกจากระบบ
            clearAllBeforeExit();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const LoginPage(),
              ),
              (route) => false,
            );

            AppDialog.showCustomDialog(context, 0, '${results['Message']}');
          } else {
            AppDialog.refreshLoginDialog(
                context, widget.socket, 2, '${results['Message']}');
          }
        });
      },
      child: Image.asset('assets/images/change-data.png',
          width: 30, height: 30, color: AppColor.brown),
    );
  }

  menuChangePassword(double width, double height) {
    return ExpansionTileCard(
      key: changePassword,
      leading: Image.asset('assets/images/password.png', width: 20, height: 20),
      title: Text('เปลี่ยนรหัสผ่าน', style: AppFont.bodyText05),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  inputPassword(width, height),
                  SizedBox(width: 55),
                  Text(' ')
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  inputConfirmPassword(width, height),
                  SizedBox(width: 30),
                  submitChangePasswordBtn(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  inputPassword(double width, double height) {
    return Container(
      width: width * 0.5,
      height: height * 0.05,
      child: TextFormField(
        controller: newPassword,
        style: AppFont.bodyText01,
        validator: (var value) {
          return null;
        },
        decoration: InputDecoration(
            labelText: 'รหัสผ่านใหม่',
            labelStyle: AppFont.bodyText01,
            fillColor: AppColor.whiteGrey,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.biteSweet)),
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.biteSweet)),
            errorStyle: const TextStyle(color: AppColor.biteSweet)),
      ),
    );
  }

  inputConfirmPassword(double width, double height) {
    return Container(
      width: width * 0.5,
      height: height * 0.05,
      child: TextFormField(
        controller: confirmNewPassword,
        style: AppFont.bodyText01,
        validator: (var value) {
          return null;
        },
        decoration: InputDecoration(
            labelText: 'ยืนยันรหัสผ่านใหม่',
            labelStyle: AppFont.bodyText01,
            fillColor: AppColor.whiteGrey,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.biteSweet)),
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.biteSweet)),
            errorStyle: const TextStyle(color: AppColor.biteSweet)),
      ),
    );
  }

  submitChangePasswordBtn() {
    return GestureDetector(
      onTap: () {
        if (newPassword.text.trim().isEmpty) {
          AppDialog.showCustomDialog(context, 1, 'ใส่รหัสผ่านใหม่');
          return;
        } else if (newPassword.text.trim().length < 6) {
          AppDialog.showCustomDialog(
              context, 1, 'รหัสผ่านใหม่ต้องมากกว่าหรือเท่ากับ 6 ตัวอักษร');
          return;
        } else if (newPassword.text.trim().length > 50) {
          AppDialog.showCustomDialog(
              context, 1, 'รหัสผ่านใหม่ต้องไม่เกิน 50 ตัวอักษร');
          return;
        } else if (confirmNewPassword.text.trim().isEmpty) {
          AppDialog.showCustomDialog(context, 1, 'ใส่ยืนยันรหัสผ่านใหม่');
          return;
        } else if (confirmNewPassword.text.trim().length < 6) {
          AppDialog.showCustomDialog(context, 1,
              'ยืนยันรหัสผ่านใหม่ต้องมากกว่าหรือเท่ากับ 6 ตัวอักษร');
          return;
        } else if (newPassword.text.trim().length > 50) {
          AppDialog.showCustomDialog(
              context, 1, 'ยืนยันรหัสผ่านใหม่ต้องไม่เกิน 50 ตัวอักษร');
          return;
        } else if (newPassword.text.trim() != confirmNewPassword.text.trim()) {
          AppDialog.showCustomDialog(context, 1, 'รหัสผ่านใหม่ไม่ตรงกัน');
          return;
        }

        // Call API Change Password
        //changePasswordData();
        ApiServices.changePassword(
                mainCtr.userProfileList.value.accessToken ?? "",
                mainCtr.userProfileList.value.userId ?? "",
                newPassword.text)
            .then((value) {
          var results = value;
          debugPrint('result-> $results');
          debugPrint('Status-> ${results['Status']}');
          debugPrint('Message-> ${results['Message']}');
          debugPrint('Success-> ${results['Success']}');

          if (results['Success'] == true) {
            //-- เปลี่ยนรหัสผ่านสำเร็จ ให้ logout ออกจากระบบ
            clearAllBeforeExit();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const LoginPage(),
              ),
              (route) => false,
            );
            AppDialog.showCustomDialog(context, 0, '${results['Message']}');
          } else {
            AppDialog.refreshLoginDialog(
                context, widget.socket, 2, '${results['Message']}');
          }
        });
      },
      child: Image.asset('assets/images/change-data.png',
          width: 30, height: 30, color: AppColor.brown),
    );
  }

  menuExit() {
    return Card(
      child: ListTile(
        leading: GestureDetector(
          onTap: () => confirmtExit(context, 'คุณต้องการออกจากระบบ ?'),
          child: Image.asset('assets/images/logout.png',
              width: 20, height: 20, color: Colors.red),
        ),
        title: GestureDetector(
          onTap: () => confirmtExit(context, 'คุณต้องการออกจากระบบ ?'),
          child: Text('ออกจากระบบ', style: AppFont.bodyText05),
        ),
      ),
    );
  }

  // use for signout in setting menu screen only
  confirmtExit(BuildContext context, String message) async {
    // set up the button
    Widget cancelButton = ElevatedButton(
        child: Text('ยกเลิก', style: AppFont.btnText09),
        style: ElevatedButton.styleFrom(
            primary: AppColor.brown,
            onPrimary: AppColor.gold,
            shadowColor: Colors.grey,
            elevation: 7),
        onPressed: () => Navigator.pop(context));
    Widget confirmButton = ElevatedButton(
        child: Text('ตกลง', style: AppFont.btnText09),
        style: ElevatedButton.styleFrom(
            primary: AppColor.brown,
            onPrimary: AppColor.gold,
            shadowColor: Colors.grey,
            elevation: 7),
        onPressed: () {
          clearAllBeforeExit();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const LoginPage(),
            ),
            (route) => false,
          );
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      //title: Text("ออกจากระบบ"),
      actionsAlignment: MainAxisAlignment.center,
      content: Text(message, style: AppFont.bodyText01),
      actions: [cancelButton, confirmButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
