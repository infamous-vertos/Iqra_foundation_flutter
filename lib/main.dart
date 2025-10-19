import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:iqra/ui/navigation/pages.dart';
import 'package:iqra/ui/theme/app_colors.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AppColors.setComponentsColors();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final screenWidth = orientation == Orientation.portrait ? 360.0 : 690.0;
    final screenHeight = orientation == Orientation.portrait ? 690.0 : 360.0;
    return ScreenUtilInit(
      designSize: Size(screenWidth, screenHeight),
      minTextAdapt: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: 'Iqra Foundation',
          debugShowCheckedModeBanner: false,
          initialRoute: Pages.initial,
          getPages: Pages.routes,
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: Colors.white,
            // fontFamily: 'Mulish',
          ),
          builder: (context, child) {
            child = EasyLoading.init()(context, child);
            EasyLoading().toastPosition = EasyLoadingToastPosition.bottom;
            child = MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child,
            );
            return child;
          },
        );
      },
    );
  }
}
