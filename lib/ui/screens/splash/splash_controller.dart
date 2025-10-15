import 'dart:async';

import 'package:get/get.dart';
import 'package:iqra/ui/navigation/routes.dart';

class SplashController extends GetxController{
  final isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    Timer(Duration(seconds: 2), () => Get.offNamed(Routes.home));
  }
}