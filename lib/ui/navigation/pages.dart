import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:iqra/ui/navigation/routes.dart';
import 'package:iqra/ui/screens/home/home_binding.dart';
import 'package:iqra/ui/screens/splash/splash_binding.dart';
import 'package:iqra/ui/screens/splash/splash_screen.dart';

import '../screens/home/home_screen.dart';

class Pages{
  static final initial = Routes.splash;
  static const transition = Transition.rightToLeftWithFade;
  static const transitionDuration = Duration(milliseconds: 300);
  static final routes = [
    GetPage(
        name: Routes.home,
        page: () => HomeScreen(),
        binding: HomeBinding(),
        transition: transition,
        transitionDuration: transitionDuration),
    GetPage(
        name: Routes.splash,
        page: () => SplashScreen(),
        binding: SplashBinding(),
        transition: transition,
        transitionDuration: transitionDuration)
  ];
}