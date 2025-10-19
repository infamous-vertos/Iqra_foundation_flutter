import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iqra/ui/screens/home/home_controller.dart';

import '../../../gen/assets.gen.dart';
import '../../theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => PopScope(
      onPopInvokedWithResult: (_,_){
        if(controller.currentIndex.value != 0){
          controller.goToScreen(0);
        }
      },
      child: Scaffold(
        body: controller.currentScreen.value,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.styleBlack,
          onTap: (index){
            controller.goToScreen(index);
          },
          currentIndex: controller.currentIndex.value,
          items: [
            BottomNavigationBarItem(label: "Home", icon: Assets.icons.icHome.svg(width: 20.w, colorFilter: controller.currentIndex.value == 0 ? ColorFilter.mode(AppColors.primary, BlendMode.srcIn) : null )),
            BottomNavigationBarItem(label: "Members", icon: Assets.icons.icGroup.svg(width: 20.w, colorFilter: controller.currentIndex.value == 1 ? ColorFilter.mode(AppColors.primary, BlendMode.srcIn) : null )),
            BottomNavigationBarItem(label: "Profile", icon: Assets.icons.icPerson.svg(width: 20.w, colorFilter: controller.currentIndex.value == 2 ? ColorFilter.mode(AppColors.primary, BlendMode.srcIn) : null )),
          ],
        ),
      ),
    ));
  }
}
