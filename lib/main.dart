import 'dart:io';
import 'package:espacios_uc/app_theme.dart';
import 'package:espacios_uc/onboarding/onboarding.dart';
import 'package:espacios_uc/onboarding/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'navigation_home_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Onboarding Concept',
      home: Builder(
        builder: (BuildContext context) {
          final screenHeight = MediaQuery.of(context).size.height;

          return Onboarding(screenHeight: screenHeight);
        },
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}