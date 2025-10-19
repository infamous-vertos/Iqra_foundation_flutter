import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/global.dart';
import '../../theme/app_colors.dart';

class InputBox extends StatelessWidget {
  final bool obscure;
  final String hint;
  final double? borderRadius;
  final TextInputType type;
  final int? maxLines, length;
  final Color? bgColor;
  final bool? isLabelVerticallyAtTop;
  final double? fontSize, height;
  final bool? enabled;
  final String? pattern;
  final RxBool? isValidated;
  final double unitAvailable;
  final bool checkAvailability;
  final bool hideKeyboardOnMaxLength;
  final bool isOutlined;
  final RxString text;

  InputBox({
    Key? key,
    required this.hint,
    required this.text,
    this.borderRadius,
    this.type = TextInputType.text,
    this.obscure = false,
    this.maxLines = 1,
    this.length = 300,
    this.bgColor,
    this.isLabelVerticallyAtTop,
    this.fontSize,
    this.enabled = true,
    this.pattern,
    this.isValidated,
    this.checkAvailability = false,
    this.unitAvailable = 0,
    this.height,
    this.hideKeyboardOnMaxLength = false,
    this.isOutlined = false,
  }) : super(key: key);

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var isValidated = this.isValidated ?? true.obs;

    return Obx(
      () => Container(
        height: height,
        decoration: BoxDecoration(
          color: isValidated.value || pattern == null
              ? (bgColor ?? Colors.white)
              : Colors.red[100],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadius ?? 4.r),
            topRight: Radius.circular(borderRadius ?? 4.r),
          ),
        ),
        child: TextField(
          textInputAction: TextInputAction.done,
          controller: textController,
          keyboardType: type,
          obscureText: obscure,
          maxLines: maxLines,
          maxLength: length,
          enabled: enabled,
          style: TextStyle(
            fontSize: fontSize ?? 14.sp,
            color: AppColors.styleBlack,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            alignLabelWithHint: isLabelVerticallyAtTop ?? false,
            counterText: '',
            labelText: hint,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade500,
            ),
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: fontSize ?? 14.sp,
              color: Colors.grey.shade500,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 10.h,
              horizontal: 15.w,
            ),
            enabledBorder: isOutlined
                ? OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.h,
                    ),
                  )
                : UnderlineInputBorder(
                    // borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
                    borderSide: BorderSide(
                      color: AppColors.styleBlack,
                      width: 1.7.h,
                    ),
                  ),
            focusedBorder: isOutlined
                ? OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.h,
                    ),
                  )
                : UnderlineInputBorder(
                    // borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.7.h,
                    ),
                  ),
          ),
          onChanged: (value) {
            if (pattern != null) {
              final regEx = RegExp(pattern ?? "");
              final result = regEx.hasMatch(value);
              if (result) {
                text.value = value;
                isValidated.value = true;
              } else {
                isValidated.value = false;
              }
            }else{
              text.value = value;
            }
            if (hideKeyboardOnMaxLength && value.length == length) {
              Global.hideKeyboard();
            }
          },
        ),
      ),
    );
  }
}
