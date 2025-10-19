import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iqra/ui/components/static/activity_tile.dart';
import 'package:iqra/ui/components/text/text_view.dart';
import '../../../../gen/assets.gen.dart';
import '../../../components/static/category_item.dart';
import '../../../theme/ui_constants.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10.h,
        children: [
          FloatingActionButton(
            heroTag: "deposit",
            onPressed: () {},
            elevation: 10.h,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.white, width: 2),
            ),
            backgroundColor: Colors.green,
            child: Assets.images.deposite.image(
              width: 30.w,
              height: 30.w,
              color: Colors.white,
            ),
          ),
          FloatingActionButton(
            heroTag: "expense",
            onPressed: () {},
            elevation: 10.h,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.white, width: 2),
            ),
            backgroundColor: Colors.red,
            child: Assets.images.expense.image(
              width: 30.w,
              height: 30.w,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() => Padding(
          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.logo.logo.image(width: 70.w),
                  Assets.logo.textHorizontal.image(width: 0.7.sw),
                ],
              ),
              // Divider(),
              Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: Assets.images.goldenLine.image(),
              ),
              SizedBox(height: 15.h),
              Align(
                alignment: Alignment.center,
                child: Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: [
                    CategoryItem(
                      title: "Total Balance",
                      amount: controller.balance.value,
                      iconPath: Assets.images.wallet.path,
                      iconColor: Colors.green,
                    ),
                    CategoryItem(
                      title: "Total Expense",
                      amount: controller.expense.value,
                      iconPath: Assets.images.spending.path,
                      iconColor: Colors.red,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15.h),
              TextView(text: "Activity"),
              SizedBox(height: 10.h),

              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Column(
                    spacing: 8.h,
                    children: [
                      for(var item in controller.transactions)
                        ActivityTile(
                          item: item
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
