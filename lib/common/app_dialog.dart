import 'dart:io';

import 'package:flutter/material.dart';
import 'package:langhong/common/app_color.dart';
import 'package:langhong/common/app_font.dart';
import 'package:langhong/pages/login/login_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AppDialog {
  // level-> 0=Success, 1=Infomation, 2=Error
  static showCustomDialog(BuildContext context, int levelMsg, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
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
              width: MediaQuery.of(context).size.width * 0.7,
              height: Platform.isAndroid
                  ? MediaQuery.of(context).size.height * 0.55
                  : MediaQuery.of(context).size.height * 0.45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: levelMsg == 0
                          ? Image.asset('assets/images/accept.png',
                              height: 70, width: 70)
                          : levelMsg == 1
                              ? Image.asset('assets/images/info-warning.png',
                                  height: 70, width: 70)
                              : Image.asset('assets/images/error-warning.png',
                                  height: 70, width: 70)),
                  SizedBox(height: 30.0),
                  Text(message, style: AppFont.bodyText01),
                  SizedBox(height: 40.0),
                  ElevatedButton(
                    child: Text('ตกลง', style: AppFont.btnText09),
                    style: ElevatedButton.styleFrom(
                        primary: AppColor.brown,
                        onPrimary: AppColor.gold,
                        shadowColor: Colors.grey,
                        elevation: 7),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // use for signout for Session Expired
  static refreshLoginDialog(
      BuildContext context, IO.Socket socket, int levelMsg, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
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
              width: MediaQuery.of(context).size.width * 0.7,
              height: Platform.isAndroid
                  ? MediaQuery.of(context).size.height * 0.55
                  : MediaQuery.of(context).size.height * 0.45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: levelMsg == 0
                          ? Image.asset('assets/images/accept.png',
                              height: 70, width: 70)
                          : levelMsg == 1
                              ? Image.asset('assets/images/info-warning.png',
                                  height: 70, width: 70)
                              : Image.asset('assets/images/error-warning.png',
                                  height: 70, width: 70)),
                  SizedBox(height: 30.0),
                  Text(message, style: AppFont.bodyText01),
                  SizedBox(height: 30.0),
                  ElevatedButton(
                    child: Text('ตกลง', style: AppFont.btnText09),
                    style: ElevatedButton.styleFrom(
                        primary: AppColor.brown,
                        onPrimary: AppColor.gold,
                        shadowColor: Colors.grey,
                        elevation: 7),
                    onPressed: () {
                      // สั่งปิด Socket Connection จะเรียก socket.onDisconnect() ตอนเปืดให้เอง
                      try {
                        socket.dispose();
                        socket.close();
                      } catch (e) {}

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const LoginPage(),
                        ),
                        (route) => false,
                      );
                    },
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
