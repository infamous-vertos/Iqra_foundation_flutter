import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iqra/ui/components/dropdown/members_dropdown_dialog.dart';
import 'package:iqra/ui/components/shimmer/horizontal_shimmer.dart';
import 'package:iqra/ui/components/static/activity_tile.dart';
import 'package:iqra/ui/components/text/text_view.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../models/user_model.dart';
import '../../../../utils/FirebaseHelper.dart';
import '../../../components/button/responsive_button.dart';
import '../../../components/input/input_box.dart';
import '../../../components/static/category_item.dart';
import '../../../components/static/not_found.dart';
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
            onPressed: openDepositDialog,
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
            onPressed: openExpenseDialog,
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
        )),
      ),
    );
  }

  openDepositDialog() {
    final amount = "".obs;
    final description = "".obs;
    final loader = false.obs;
    final selectedMember = Rx<UserModel?>(null);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextView(
                text: "Add Deposit",
                fontWeight: FontWeight.w700,
                size: 18.sp,
                color: Colors.green,
              ),
              // Divider(),
              SizedBox(height: 10.h),
              MembersDropdownDialog(
                  selectedValue: selectedMember,
                debounce: controller.debounce,
              ),
              SizedBox(height: 10.h),
              InputBox(isOutlined: true, hint: "Amount", text: amount, type: TextInputType.number,),
              SizedBox(height: 10.h),
              InputBox(isOutlined: true, hint: "Description", text: description),

              SizedBox(height: 20.h),

              ResponsiveButton(
                text: "Submit",
                loader: loader,
                funOnTap: () async {
                  loader.value = true;
                  await controller.deposit(amount: amount.value, desc: description.value, by: selectedMember.value);
                  loader.value = false;
                },),
            ],
          ),
        ),
      ),
    );
  }

  openExpenseDialog() {
    final amount = "".obs;
    final description = "".obs;
    final loader = false.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextView(
                text: "Add Expense",
                fontWeight: FontWeight.w700,
                size: 18.sp,
                color: Colors.red,
              ),
              // Divider(),
              SizedBox(height: 10.h),
              InputBox(isOutlined: true, hint: "Amount", text: amount, type: TextInputType.number,),
              SizedBox(height: 10.h),
              InputBox(isOutlined: true, hint: "Description", text: description),

              SizedBox(height: 20.h),

              ResponsiveButton(
                text: "Submit",
                loader: loader,
                funOnTap: () async {
                  loader.value = true;
                  await controller.addExpense(amount: amount.value, desc: description.value);
                  loader.value = false;
                },),
            ],
          ),
        ),
      ),
    );
  }
}
