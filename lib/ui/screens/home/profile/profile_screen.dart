import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iqra/ui/components/static/not_found.dart';
import 'package:iqra/ui/components/text/text_view.dart';
import 'package:iqra/ui/screens/home/profile/profile_controller.dart';
import 'package:iqra/ui/theme/app_colors.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/FirebaseHelper.dart';
import '../../../components/button/responsive_button.dart';
import '../../../components/shimmer/horizontal_shimmer.dart';
import '../../../components/static/activity_tile.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? Center(child: Assets.anim.animLoadingDots.lottie())
              : controller.user.value == null
                  ? NotFound(text: "Error Occurred",)
              : Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(onPressed: (){}, icon: Icon(Icons.logout_rounded)),
                      ),

                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.r),
                          border: Border.all(width: 1.w, color: Colors.black),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.r),
                          child: Image.network(
                            controller.user.value!.photoUrl!,
                            width: 40.w,
                            height: 40.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.person_sharp, size: 24.w),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h,),

                      TextView(text: controller.user.value!.name, size: 20.sp,),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.email_outlined, size: 20.w, color: AppColors.styleBlack,),
                          SizedBox(width: 5.w,),
                          TextView(text: controller.user.value!.email ?? "No Email", size: 16.sp, fontWeight: FontWeight.w400,),
                        ],
                      ),

                      SizedBox(height: 5.h,),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: AppColors.styleBlack,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                          child: TextView(
                            text: "Member Since - ${controller.user.value!.getJoinedOn()}",
                            size: 16.sp,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          )
                      ),

                      SizedBox(height: 10.h,),

                      Align(
                          alignment: Alignment.topLeft,
                          child: TextView(text: "Your Activity"),
                      ),
                      SizedBox(height: 10.h),
                      controller.isLoading.value
                          ? HorizontalShimmer(count: 6,)
                          :
                      controller.transactions.isEmpty
                          ? NotFound(text: "No record found",)
                          :
                      Flexible(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Column(
                            spacing: 8.h,
                            children: [
                              for(var item in controller.transactions.reversed)
                                ActivityTile(
                                    item: item
                                ),
                              Visibility(
                                visible: controller.transactions.length % FirebaseHelper.transactionLimit == 0,
                                child: controller.isLoadingMore.value
                                    ? HorizontalShimmer(count: 1)
                                    : Padding(
                                  padding: EdgeInsets.only(top: 10.h),
                                  child: Center(
                                    child: ResponsiveButton(
                                      width: 100.w,
                                      isOutlinedBtn: true.obs,
                                      text: "Load more",
                                      bgColor: Colors.grey.shade500,
                                      funOnTap: (){
                                        controller.getTransactions(isLoading: controller.isLoadingMore);
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
              ),
        ),
      ),
    );
  }
}
