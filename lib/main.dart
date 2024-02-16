import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:langhong/pages/login/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'langhong',
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: "/home", page: () => const LoginPage()),
      ],
      initialRoute: "/home",
      theme: ThemeData(useMaterial3: false),
    );
  }
}

/*
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'langhong',
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          home: child,
        );
      },
      child: const LoginPage(),
    );
  }
}
*/

/*
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'langhong',
      builder: (context, child) {
        EasyLoading.init();
        final mediaQuery = MediaQuery.of(context);
        final scale = mediaQuery.textScaleFactor;
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
            child: child!);
      },
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: "/home", page: () => const LoginPage()),
      ],
      initialRoute: "/home",
    );
  }
}
*/

/*
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'langhong',
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: "/home", page: () => const LoginPage()),
      ],
      initialRoute: "/home",     
    );
  }
}
*/

/*

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'langhong',
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          EasyLoading.init();
          var mediaQuery = MediaQuery.of(context);
          var newTextScaleFactor = 1.0; // varying this has effect
          var newDevicePixelRatio = 4.0; // varying this has no effect
          debugPrint('textScaleFactor= ${mediaQuery.textScaleFactor}');
          debugPrint('devicePixelRatio= ${mediaQuery.devicePixelRatio}');

          var physicalPixelWidth =
              mediaQuery.size.width * mediaQuery.devicePixelRatio;
          var physicalPixelHeight =
              mediaQuery.size.height * mediaQuery.devicePixelRatio;
          var newSize = Size(physicalPixelWidth / newDevicePixelRatio,
              physicalPixelHeight / newDevicePixelRatio);

          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: newTextScaleFactor, devicePixelRatio: newDevicePixelRatio, size: newSize),
            child: Navigator(
              onGenerateInitialRoutes: (state, routeName) => [
                MaterialPageRoute(builder: (_) {
                  return Overlay(
                    initialEntries: [
                      OverlayEntry(builder: (context) => const LoginPage())
                    ],
                  );
                }),
              ],
            ),
          );
        });
  }
}
*/
