import 'package:flutter/material.dart';
import 'package:langhong/common/app_color.dart';
import 'package:langhong/common/app_dialog.dart';
import 'package:langhong/common/app_font.dart';
import 'package:langhong/common/app_secure_storage.dart';
import 'package:langhong/pages/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TouchId extends StatefulWidget {
  //TouchId(this.userProfileList) : super();
  //final UserProfile userProfileList;

  @override
  _TouchIdState createState() => _TouchIdState();
}

class _TouchIdState extends State<TouchId> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController userName = TextEditingController();
  TextEditingController passWord = TextEditingController();
  SharedPreferences? sharedPreferences;
  bool isObscure = true, isTouchId = false, isChange=false;

  // Function ตรวจสอบการตั้งค่า Touch ID ของผู้ใช้งาน
  void initTouchId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences!.getBool('touchId') == null) {
      setState(() {
        sharedPreferences!.setBool('touchId', false);
        isTouchId = false;
      });
    } else if (sharedPreferences!.getBool('touchId') == false) {
      setState(() {
        isTouchId = false;
      });
    } else if (sharedPreferences!.getBool('touchId') == true) {
      setState(() async {
        isTouchId = true;
        // โหลดข้อมูลลงบนฟิลด์หน้าจอ
        userName.text = await AppSecureStorage.getUserName() ?? '';
        passWord.text = await AppSecureStorage.getPassword() ?? '';
        isObscure = true;      
      });
    }
  }

  @override
  void initState() {
    initTouchId();
    super.initState();
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
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                child: Container(
                  width: double.maxFinite,
                  height: height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/page-bg.png'),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context, isTouchId),
                  child: Image.asset('assets/images/arrow-left.png',
                      width: 40, height: 40),
                ),
              ),
              Positioned(
                  left: width * 0.28,
                  top: 50,
                  child: const Text('ตั้งค่าการสแกนลายนิ้วมือ',
                      style: AppFont.titleText01)),
              Positioned(
                top: 85,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    width: width * 0.92,
                    height: height * 0.79,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 30),
                      child: Column(
                        children: [
                          buildCheckedTouchId(width, height),
                          SizedBox(height: 20),
                          isTouchId == false
                              ? Text('')
                              : Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/fingerprint.png',
                                          width: 80,
                                          height: 80),
                                      SizedBox(height: 30),
                                      inputUserName(width, height),
                                      SizedBox(height: 15),
                                      inputPassword(width, height),
                                      SizedBox(height: 40),
                                      saveBtn(width, height),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildCheckedTouchId(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
            value: isTouchId,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  isTouchId = true;
                  sharedPreferences!.setBool('touchId', true);
                }
                if (value == false) {
                  isTouchId = false;
                  sharedPreferences!.setBool('touchId', false);
                }
              });
            }),
        Text('เข้าสู่ระบบด้วยการสแกนลายนิ้วมือ', style: AppFont.bodyText01),
      ],
    );
  }

  inputUserName(double width, double height) {
    return Container(
      width: width * 0.7,
      height: height * 0.07,
      child: TextFormField(
        controller: userName,
        onChanged: (value) {
          setState(() {
            isChange = true;
          });
        },        
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
              borderSide: BorderSide(color: Colors.grey),
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
      width: width * 0.7,
      height: height * 0.07,
      child: TextFormField(
        controller: passWord,
        obscureText: isObscure,
        onChanged: (value) {
          setState(() {
            isChange = true;
          });
        },        
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
              borderSide: const BorderSide(color: Colors.grey),
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

  saveBtn(double width, double height) {
    return Container(
      width: width * 0.7,
      height: height * 0.07,
      child: ElevatedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('บันทึกข้อมูล', style: AppFont.btnText09),
            ],
          ),
          style: isChange == true
            ? ElevatedButton.styleFrom(
                primary: AppColor.brown,
                onPrimary: AppColor.gold,
                shadowColor: Colors.grey,
                elevation: 7
              )
            : ElevatedButton.styleFrom(
                primary: AppColor.lightGrey,
                onPrimary: Colors.white,
                shadowColor: AppColor.biteSweet,
                elevation: 7
              ),
          onPressed: () async {
            if (isChange == true) {
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

              // Call Class Save Username/Password on device
              await AppSecureStorage.setUserName(userName.text.trim());

              await AppSecureStorage.setPassword(passWord.text.trim());

              showMsgDialog(context, 0, 'บันทึกข้อมูลสำเร็จ');
            }

          }),
    );
  }

  showMsgDialog(BuildContext context, int levelMsg, String message) {
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
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width * 0.6,
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
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    child: Text('ตกลง', style: AppFont.btnText09),
                    style: ElevatedButton.styleFrom(
                        primary: AppColor.brown,
                        onPrimary: AppColor.gold,
                        shadowColor: Colors.grey,
                        elevation: 7),
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const LoginPage()),
                      (route) => false,
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
