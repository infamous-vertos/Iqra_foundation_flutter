import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iqra/ui/components/static/member_ui.dart';
import 'package:iqra/ui/components/static/not_found.dart';

import '../../../models/user_model.dart';
import '../../../utils/FirebaseHelper.dart';
import '../button/responsive_button.dart';
import '../text/text_view.dart';


class MembersDropdownDialog extends StatelessWidget {
  double? titleSize, iconSize;
  FontWeight? titleWeight;
  Color? titleColor, bgColor;
  Timer? debounce;

  final Rx<UserModel?> selectedValue;
  final Rx<UserModel?> tempSelectedValue =
      Rx<UserModel?>(null);

  final list = <UserModel>[].obs;
  final filteredList = <UserModel>[].obs;
  final EdgeInsets? padding;
  final String? hint;
  final searchTextController = TextEditingController();
  final bool isAutoSelect, isSearchVisible, isBorderVisible;
  final MainAxisSize mainAxisSize;
  String? leadingIcon;
  Function({required UserModel member})? funOnSelect;
  TextOverflow? textOverflow;

  final isLoading = true.obs;

  MembersDropdownDialog(
      {super.key,
      required this.selectedValue,
        required this.debounce,
      this.padding,
      this.hint,
      this.isAutoSelect = true,
      this.isSearchVisible = true,
      this.isBorderVisible = true,
        this.titleSize,
        this.titleColor,
        this.titleWeight,
        this.iconSize,
        this.funOnSelect,
        this.mainAxisSize = MainAxisSize.max,
        this.leadingIcon,
        this.textOverflow = TextOverflow.ellipsis,
        this.bgColor
      });
  
  final surface = Colors.grey.shade400;
  final onSurface = Colors.grey.shade500;

  @override
  Widget build(BuildContext context) {
    // searchMembers();

    return Obx(() => GestureDetector(
      onTap: () {
        openDialog();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 15.w,
        ),
        decoration: BoxDecoration(
          color: bgColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: surface, width: 1.r)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: mainAxisSize,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  leadingIcon != null
                  ? SvgPicture.asset(leadingIcon!, width: 15.w,color: onSurface,)
                  : Container(),
                  leadingIcon != null
                      ? SizedBox(width: 5.w)
                      : Container(),
                  Flexible(
                    child: TextView(
                      maxLines: 1,
                      textOverflow: textOverflow,
                      size: 14.sp,
                      text: selectedValue.value == null
                          ? hint ?? "Select Member"
                          : selectedValue.value!.name,
                      fontWeight: titleWeight ?? FontWeight.w400,
                      color: titleColor ?? onSurface,
                      isSoftWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5.w,),
            Icon(Icons.keyboard_arrow_down, color: titleColor ?? onSurface, size: iconSize ?? 16.w,)
          ],
        ),
      ),
    ));
  }

  openDialog() {
    tempSelectedValue.value = selectedValue.value;
    if(list.isEmpty) {
      searchMembers();
    }

    Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.r),
          ),
          child: Obx(() => ClipRRect(
                borderRadius: BorderRadius.circular(5.r),
                child: Container(
                  height: 300.h,
                  padding: EdgeInsets.all(10.r),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextView(
                        text: "Select Member",
                        size: 16.sp,
                      ),
                      Visibility(
                        visible: isSearchVisible,
                        child: SizedBox(
                          height: 10.h,
                        ),
                      ),
                      Visibility(
                        visible: isSearchVisible,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: TextField(
                              textInputAction: TextInputAction.done,
                              controller: searchTextController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: onSurface
                              ),
                              onChanged: (value) {
                                debugPrint("Search1 - $value");
                                if(debounce?.isActive ?? false) debounce?.cancel();
                                if(value.isEmpty && list.isNotEmpty){
                                  debugPrint("Assigning List - ${list.length}");
                                  filteredList.assignAll(list);
                                  return;
                                }
                                debounce = Timer(Duration(milliseconds: 700), () async {
                                  debugPrint("Search2 - $value");
                                  await searchMembers();
                                });
                              },
                              decoration: InputDecoration(
                                constraints: BoxConstraints(
                                  maxHeight: 40.h
                                ),
                                prefixIcon: const Icon(Icons.search),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Search",
                                hintStyle: TextStyle(
                                    fontSize: 12.sp,
                                    color: onSurface,
                                    fontWeight: FontWeight.w500),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.h,
                                  horizontal: 10.w,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24.r),
                                    borderSide: BorderSide(
                                        color: onSurface, width: 1.w)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24.r),
                                    borderSide: BorderSide(
                                        color: onSurface, width: 1.w)),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : filteredList.isEmpty
                      ? Flexible(child: NotFound(text: "No Members Found",))
                      : Flexible(
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: ListView(
                            children: [
                              for (var i = 0; i < filteredList.length; i++)
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      tempSelectedValue.value = filteredList[i];

                                      //OnClick item it will not wait for 'Done' button to be clicked
                                      if(isAutoSelect){
                                        onDone();
                                      }
                                    },
                                    child: MemberUi(user: filteredList[i], isChecked: tempSelectedValue.value !=
                                        null &&
                                        tempSelectedValue
                                            .value!.uid ==
                                            filteredList[i].uid,),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Visibility(
                        visible: !isAutoSelect,
                        child: ResponsiveButton(
                            funOnTap: onDone,
                            text: "Done",
                            height: 30.h,
                            textSize: 12.sp),
                      )
                    ],
                  ),
                ),
              )),
        ),
        barrierDismissible: true);
  }

  onDone(){
    selectedValue.value = tempSelectedValue.value;
    Get.back();
    funOnSelect?.call(member: tempSelectedValue.value!);
  }

  Future<void> searchMembers() async {
    try{
      final keyword = searchTextController.text.toString();
      debugPrint("Keyword - $keyword");
      debugPrint("Flag - ${keyword.isEmpty && list.isNotEmpty}");

      isLoading.value = true;
      final data = await FirebaseHelper.getMembers(
          searchText: keyword.isEmpty ? null : keyword,
          isRefresh: true,
          tempLimit: 5
      );
      if(data.isNotEmpty){
        if(list.isEmpty){
          debugPrint("assignAll in list");
          list.assignAll(data);
        }
        filteredList.assignAll(data);
      }else{
        filteredList.clear();
      }
      isLoading.value = false;
    }catch(e,s){
      debugPrintStack(stackTrace: s);
      isLoading.value = false;
    }
  }
}
