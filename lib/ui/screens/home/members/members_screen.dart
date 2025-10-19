import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iqra/ui/components/button/responsive_button.dart';
import 'package:iqra/ui/components/input/input_box.dart';
import 'package:iqra/ui/components/static/member_ui.dart';
import 'package:iqra/ui/components/static/not_found.dart';
import 'package:iqra/ui/components/text/text_view.dart';
import 'package:iqra/utils/FirebaseHelper.dart';

import '../../../../gen/assets.gen.dart';
import '../../../components/shimmer/horizontal_shimmer.dart';
import 'members_controller.dart';

class MembersScreen extends StatelessWidget {
  MembersScreen({super.key});

  final controller = Get.put(MembersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10.h,
        children: [
          FloatingActionButton(
            heroTag: "deposit",
            onPressed: () {
              openDialog();
            },
            elevation: 10.h,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.white, width: 2),
            ),
            backgroundColor: Colors.green,
            child: Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
          ),
        ],
      ),
      body: Obx(
        () => SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    children: [
                      SearchBar(
                        controller: controller.searchController,
                        leading: const Icon(Icons.search),
                        hintText: 'Search',
                        padding: WidgetStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 20.w),
                        ),
                        onChanged: (value) {
                          controller.searchMembers(value);
                        },
                        elevation: WidgetStateProperty.all(1.0),
                      ),
                      SizedBox(height: 16.h),
                      controller.isLoading.value
                          ? HorizontalShimmer(count: 8)
                          :
                      controller.tempList.isEmpty
                          ? NotFound(text: "No members found",)
                          : Flexible(
                              child: ListView(
                                padding: EdgeInsets.only(bottom: 10.h),
                                children: [
                                  for (var user in controller.tempList)
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 5.h),
                                      child: MemberUi(user: user),
                                    ),
                                  Visibility(
                                    visible: controller.searchController.text.isEmpty && controller.tempList.length % FirebaseHelper.limit == 0,
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
                                              controller.fetchData(isLoading: controller.isLoadingMore);
                                            },
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  openDialog() {
    final name = "".obs;
    final email = "".obs;
    final phone = "".obs;
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
                text: "Add Member",
                fontWeight: FontWeight.w700,
                size: 18.sp,
              ),
              // Divider(),
              SizedBox(height: 10.h),
              InputBox(isOutlined: true, hint: "Name", text: name),
              SizedBox(height: 10.h),
              InputBox(isOutlined: true, hint: "Phone", text: phone),
              SizedBox(height: 10.h),
              InputBox(isOutlined: true, hint: "Email", text: email),

              SizedBox(height: 20.h),

              ResponsiveButton(
                text: "Submit",
                loader: loader,
                funOnTap: () async {
                  loader.value = true;
                  await controller.addMember(name.value, email.value, phone.value);
                  loader.value = false;
              },),
            ],
          ),
        ),
      ),
    );
  }
}
