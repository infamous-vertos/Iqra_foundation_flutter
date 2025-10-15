import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors{
  static const Color primary = Color(0xff22BE6A);
  static const Color onPrimary = Color(0xffffffff);
  static const Color styleBlack = Color(0xff313131);

  static setComponentsColors() async{
    // // change the status bar color to material color [green-400]
    // await FlutterStatusbarcolor.setStatusBarColor(Colors.green[400]);
    // if (useWhiteForeground(Colors.green[400])) {
    //   FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    // } else {
    //   FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    // }
    //
    // // change the navigation bar color to material color [orange-200]
    // await FlutterStatusbarcolor.setNavigationBarColor(Colors.orange[200]);
    // if (useWhiteForeground(Colors.orange[200]) {
    // FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
    // } else {
    // FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
    // }

    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: AppColors.primary,
    //     statusBarIconBrightness: Brightness.light,
    //     statusBarBrightness: Brightness.light
    //   ),
    // );
  }
}