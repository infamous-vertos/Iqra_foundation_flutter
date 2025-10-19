import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iqra/ui/components/button/responsive_button.dart';
import 'package:iqra/ui/components/text/text_view.dart';
import 'package:iqra/ui/screens/splash/splash_controller.dart';
import 'package:iqra/ui/theme/app_colors.dart';

import '../../../gen/assets.gen.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final controller = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Assets.logo.logo.image(width: 120.w),
        TextView(text: "Welcome to"),
        Assets.logo.textHorizontal.image(width: 200.w),
        controller.isLoading.value
            ? Assets.anim.animLoadingDots.lottie(height: 70.h)
            : Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: ResponsiveButton(
                  text: "Sign In with Google",
                  width: 200.w,
                  isOutlinedBtn: true.obs,
                  bgColor: AppColors.styleBlack,
                  icon: Assets.icons.icGoogle.svg(width: 20.h),
                  funOnTap: controller.onTap,
                ),
            ),
      ],
    );
  }
}
