import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iqra/ui/screens/home/profile/profile_screen.dart';

import 'dashboard/dashboard_screen.dart';
import 'members/members_screen.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final currentScreen = Rx<Widget?>(null);

  Widget? dashboardScreen, membersScreen, profileScreen;


  @override
  void onReady() {
    goToScreen(currentIndex.value);
    super.onReady();
  }

  goToScreen(int index) {
    switch (index) {
      case 0:
        dashboardScreen ??= DashboardScreen();
        currentScreen.value = dashboardScreen!;
      case 1:
        membersScreen ??= MembersScreen();
        currentScreen.value = membersScreen!;
      case 2:
        profileScreen ??= ProfileScreen();
        currentScreen.value = profileScreen!;
      default:
        dashboardScreen ??= DashboardScreen();
        currentScreen.value = dashboardScreen!;
    }
    currentIndex.value = index;
  }
}
