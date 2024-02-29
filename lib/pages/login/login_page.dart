import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:langhong/api/api_services.dart';
import 'package:langhong/common/app_color.dart';
import 'package:langhong/common/app_dialog.dart';
import 'package:langhong/common/app_font.dart';
import 'package:langhong/common/app_secure_storage.dart';
import 'package:langhong/controller/mainCtr.dart';
import 'package:langhong/model/portfolio.dart';
import 'package:langhong/model/user_profile.dart';
import 'package:langhong/pages/home/home_page.dart';
import 'package:langhong/pages/login/touch_id.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userName = TextEditingController();
  TextEditingController passWord = TextEditingController();
  LocalAuthentication auth = LocalAuthentication();
  bool isBiometrics = false, isFinger = false, isObscure = true;
  SharedPreferences? sharedPreferences;
  UserProfile? userProfileList;
  UserPortfolio? userPortfolioList;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final isRemember = false.obs;
  @override
  void initState() {
    super.initState();
    getRemember();
    loginFingerPrint();
  }

  void getRemember() async {
    final saveUser = await AppSecureStorage.getUserName() ?? '';
    final savePass = await AppSecureStorage.getPassword() ?? '';

    if (savePass.length > 1) {
      isRemember(true);
    }
    userName.text = saveUser;
    passWord.text = savePass;
  }

  final mainCtr = Get.find<MainCtr>(tag: "MainCtr");
  //String userName = '', passWord = '';

  Future<bool?> hasBiometrics() async {
    try {
      final bio = await auth.canCheckBiometrics;
      setState(() {
        isBiometrics = bio;
      });
      debugPrint('Biometrics= $isBiometrics');
      return isBiometrics;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool?> getBioFingerprint() async {
    List<BiometricType> bioTypeList = [];
    try {
      bioTypeList = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
    debugPrint('Type of Biometrics= $bioTypeList');
    if (Platform.isIOS) {
      if (bioTypeList.contains(BiometricType.fingerprint)) {
        setState(() {
          isFinger = true;
        });
      }
    } else if (Platform.isAndroid) {
      if (bioTypeList.contains(BiometricType.fingerprint)) {
        setState(() {
          isFinger = true;
        });
      }
    }
    debugPrint('Fingerprint is $isFinger');
    return isFinger;
  }

  void authBiometrics(String username, String password) async {
    bool isAuth = false;

    try {
      isAuth = await auth.authenticate(
        localizedReason: 'สแกนลายนิ้วมือ',
        useErrorDialogs: true,
        stickyAuth: true,
        //androidAuthStrings: null,
        //iOSAuthStrings: null
      );
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }

    debugPrint('isAuth= $isAuth');

    if (isAuth) {
      EasyLoading.show(status: 'กำลังตรวจสอบข้อมูลผู้ใช้งาน...');
      //-- Call API Login
      ApiServices.getUserProfile(username, password).then((value) {
        EasyLoading.dismiss();

        //-- Login Not Success
        // Validate กรณี login ไม่สำเร็จ มี 2 กรณี
        // กรณีที่ 1. Message = 'Invalid Username or Password'
        // กรณีที่ 2, Message ='ระบบปิดการใช้งานชั่วคราว'
        if (value!.loginSuccess == false) {
          //AppDialog.alertDialog2(context, '${value.message}');
          AppDialog.showCustomDialog(context, 1, '${value.message}');
          return;
        }
        //-- Login Sีuccess
        else {
          mainCtr.userProfileList(value);

          setState(() {
            userProfileList = value;
          });

          //-- Call API Portfolio
          ApiServices.getUserPortfolio(userProfileList!.memberId.toString(),
                  userProfileList!.accessToken.toString())
              .then((value) {
            EasyLoading.dismiss();
            mainCtr.userPortfolioList(value);

            setState(() {
              userPortfolioList = value;
            });

            //-- Open Home Page Screen
            (mainCtr.userPortfolioList.value.memberLevel == '' ||
                    mainCtr.userPortfolioList.value.memberLevel == null)
                ? getOut()
                : Get.offAll(() => HomePage(
                      tabPage: 0,
                    ));
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(
            //     builder: (BuildContext context) => HomePage(
            //         tabPage: 0,
            //         userProfileList: userProfileList!,
            //         userPortfolioList: userPortfolioList!),
            //   ),
            //   (route) => false,
            // );
          });
        }
      });
    }
  }

  getOut() async {
    Get.defaultDialog(
      title: '',
      content: const Text('memberID\n ไม่ถูกต้อง กรุณาติดต่อผู้พัฒนา'),
    );
  }

  void loginFingerPrint() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences!.getBool('touchId') == true) {
      // เรียก Finger Print ให้แสกนลายนิ้วมือ
      hasBiometrics().then((isBio) {
        if (isBio == false) {
          AppDialog.showCustomDialog(
              context, 1, 'อุปกรณ์หรือโทรศัพท์ไม่รองรับการสแกนลายนิ้วมือ');
          return;
        }
        getBioFingerprint().then((isFinger) async {
          if (isFinger == false) {
            AppDialog.showCustomDialog(
                context, 1, 'อุปกรณ์หรือโทรศัพท์ไม่รองรับการสแกนลายนิ้วมือ');
            return;
          }

          // โหลดข้อมูลลงบนฟิลด์หน้าจอ
          userName.text = await AppSecureStorage.getUserName() ?? '';
          passWord.text = await AppSecureStorage.getPassword() ?? '';
          setState(() {
            isObscure = true;
          });

          // เรียก Finger Print ให้แสกนลายนิ้วมือ
          authBiometrics(userName.text, passWord.text);
        });
      });
    }
  }

  @override
  void dispose() {
    userName.dispose();
    passWord.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/login-bg.png'),
                  fit: BoxFit.cover),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logo-header.png',
                          width: width * 0.8, height: height * 0.3),
                      inputUserName(width, height),
                      const SizedBox(height: 15),
                      inputPassword(width, height),
                      SizedBox(
                        width: width * 0.6,
                        child: GestureDetector(onTap: () {
                          isRemember.value = !isRemember.value;
                        }, child: Obx(
                          () {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 30,
                                  child: Checkbox(
                                      value: isRemember.value,
                                      onChanged: (v) {
                                        isRemember.value = !isRemember.value;
                                      }),
                                ),
                                Text("จำรหัสผ่าน", style: AppFont.bodyText06)
                              ],
                            );
                          },
                        )),
                      ),
                      SizedBox(height: 30),
                      loginBtn(width, height),
                      SizedBox(height: 15),
                      touchIdBtn(width, height),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  inputUserName(double width, double height) {
    return Container(
      width: width * 0.6,
      height: height * 0.07,
      child: TextFormField(
        controller: userName,
        validator: (String? value) {
          return null;
        },
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person, size: 25.0),
            fillColor: Colors.white,
            filled: true,
            labelText: 'ชื่อผู้ใช้งาน',
            labelStyle: AppFont.bodyText01,
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.gold, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.gold),
              borderRadius: BorderRadius.circular(20),
            ),
            // -- case not fill data
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.biteSweet)),
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.biteSweet)),
            errorStyle: const TextStyle(color: AppColor.biteSweet)),
      ),
    );
  }

  inputPassword(double width, double height) {
    return Container(
      width: width * 0.6,
      height: height * 0.07,
      child: TextFormField(
        controller: passWord,
        obscureText: isObscure,
        validator: (String? value) {
          return null;
        },
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.https, size: 25.0),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isObscure = !isObscure;
                });
              },
              child: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
            ),
            fillColor: Colors.white,
            filled: true,
            labelText: 'รหัสผ่าน',
            labelStyle: AppFont.bodyText01,
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.gold, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.gold),
              borderRadius: BorderRadius.circular(20),
            ),
            // -- case not fill data
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.biteSweet)),
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.biteSweet)),
            errorStyle: const TextStyle(color: AppColor.biteSweet)),
      ),
    );
  }

  loginBtn(double width, double height) {
    return Container(
      width: width * 0.6,
      height: height * 0.07,
      child: ElevatedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.login, size: 30.0, color: Colors.white),
              SizedBox(width: 10),
              Text('เข้าระบบ', style: AppFont.btnText09),
            ],
          ),
          style: ElevatedButton.styleFrom(
              primary: AppColor.brown,
              onPrimary: AppColor.gold,
              shadowColor: Colors.grey,
              elevation: 7),
          onPressed: () async {
            if (!formKey.currentState!.validate()) {
              return;
            }

            if (userName.text.trim().isEmpty) {
              AppDialog.showCustomDialog(context, 1, 'โปรดกรอกชื่อผู้ใช้งาน');
              return;
            }
            if (passWord.text.trim().isEmpty) {
              AppDialog.showCustomDialog(context, 1, 'โปรดกรอกรหัสผ่าน');
              return;
            }
            formKey.currentState!.save();

            EasyLoading.show(status: 'กำลังตรวจสอบข้อมูลผู้ใช้งาน...');
            //-- Call API Login
            ApiServices.getUserProfile(userName.text, passWord.text)
                .then((value) {
              EasyLoading.dismiss();

              //-- Login Not Success
              // Validate กรณี login ไม่สำเร็จ มี 2 กรณี
              // กรณีที่ 1. Message = 'Invalid Username or Password'
              // กรณีที่ 2, Message ='ระบบปิดการใช้งานชั่วคราว'
              if (value!.loginSuccess == false) {
                AppDialog.showCustomDialog(context, 1, '${value.message}');
                return;
              }
              //-- Login Sีuccess
              else {
                if (isRemember.value) {
                  AppSecureStorage.setUserName(userName.text.trim());
                  AppSecureStorage.setPassword(passWord.text.trim());
                } else {
                  AppSecureStorage.setUserName('');
                  AppSecureStorage.setPassword('');
                }

                mainCtr.userProfileList(value);
                setState(() {
                  userProfileList = value;
                });
                print('-memberid - ${userProfileList!.memberId}');

                //-- Call API Portfolio
                ApiServices.getUserPortfolio(
                        userProfileList!.memberId.toString(),
                        userProfileList!.accessToken.toString())
                    .then((value) {
                  EasyLoading.dismiss();

                  /*-- ดัก error ตรงนี้และแสดง message เพื่อไม่ให้ค่า userPortfolioList เป็น null
                  
                  if (value!.assetCash == null) {
                    AppDialog.showCustomDialog(context, 1, 'ไม่สามารถดึงข้อมูล Portfolio ของผู้ใช้งาน โปรดติดต่อ Admin');
                    return;
                  }
                  */
                  mainCtr.userPortfolioList(value);

                  setState(() {
                    userPortfolioList = value;
                  });

                  //-- Open Home Page Screen
                  (userPortfolioList?.memberLevel == '' ||
                          userPortfolioList?.memberLevel == null)
                      ? getOut()
                      : Get.offAll(() => HomePage(
                            tabPage: 0,
                          ));
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (BuildContext context) => HomePage(
                  //         tabPage: 0,
                  //         userProfileList: userProfileList!,
                  //         userPortfolioList: userPortfolioList!),
                  //   ),
                  //   (route) => false,
                  // );
                });
              }
            });
          }),
    );
  }

  touchIdBtn(double width, double height) {
    return Container(
      width: width * 0.6,
      height: height * 0.07,
      child: ElevatedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.fingerprint, size: 30.0, color: Colors.white),
              SizedBox(width: 10),
              Text('สแกนลายนิ้วมือ', style: AppFont.btnText09),
            ],
          ),
          style: ElevatedButton.styleFrom(
              primary: AppColor.brown,
              onPrimary: AppColor.gold,
              shadowColor: Colors.grey,
              elevation: 7),
          onPressed: () {
            hasBiometrics().then((isBio) {
              if (isBio == false) {
                AppDialog.showCustomDialog(context, 1,
                    'อุปกรณ์หรือโทรศัพท์ไม่รองรับการสแกนลายนิ้วมือ');
                return;
              }
              getBioFingerprint().then((isFinger) async {
                if (isFinger == false) {
                  AppDialog.showCustomDialog(context, 1,
                      'อุปกรณ์หรือโทรศัพท์ไม่รองรับการสแกนลายนิ้วมือ');
                  return;
                }

                // รองรับการกด leff arrow
                final isTouchId = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TouchId()));
                if (isTouchId == true) {
                  // โหลดข้อมูลลงบนฟิลด์หน้าจอ
                  userName.text = await AppSecureStorage.getUserName() ?? '';
                  passWord.text = await AppSecureStorage.getPassword() ?? '';
                  setState(() {
                    isObscure = true;
                  });

                  // เรียก Finger Print ให้แสกนลายนิ้วมือ
                  authBiometrics(userName.text, passWord.text);
                }
              });
            });
          }),
    );
  }
}
