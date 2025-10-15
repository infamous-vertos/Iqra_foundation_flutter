import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../theme/app_colors.dart';
import '../text/text_view.dart';

class ResponsiveButton extends StatelessWidget {
  final String text;
  final Color bgColor;
  final double? height;
  final double? textSize;
  final double? width;
  final Color textColor;
  final Function? funOnTap;
  final RxBool? loader;
  final RxString? loadingText;
  final double? borderRadius;
  final EdgeInsets? padding;
  final SvgPicture? icon;
  final RxBool? isOutlinedBtn;

  const ResponsiveButton(
      {Key? key,
      required this.text,
      this.bgColor = AppColors.primary,
      this.height,
      this.width,
      this.textSize,
      this.textColor = Colors.white,
      this.funOnTap,
      this.loader,
      this.loadingText,
      this.borderRadius,
      this.padding,
      this.icon,
      this.isOutlinedBtn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = loader ?? false.obs;
    final isOutlined = isOutlinedBtn ?? false.obs;

    final style = isOutlined.value
        ? OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w), // Removes vertical padding
            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Removes extra space
            minimumSize: Size.zero,
            backgroundColor: Colors.white,
            side: BorderSide(width: 1.r, color: bgColor),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 8.r)
            ))
        : ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w), // Removes vertical padding
            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Removes extra space
            minimumSize: Size.zero,
            backgroundColor: bgColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 8.r)
            )
          );

    Widget getContent(){
      return SizedBox(
        height: height,
        width: width,
        child: Center(
          child: IntrinsicWidth(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoading.value
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16.h,
                        height: 16.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 5.w,
                          color: isOutlined.value ? bgColor:  textColor,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      TextView(
                        size: 14.sp,
                        textOverflow: TextOverflow.ellipsis,
                        text: loadingText?.value ?? "Loading...",
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w600,
                        color: isOutlined.value ? bgColor:  textColor,
                      )
                    ],
                  )
                      : Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        icon ?? Container(),
                        icon != null
                            ? SizedBox(
                          width: 12.w,
                        )
                            : Container(),
                        Flexible(
                          child: TextView(
                            text: text,
                            textOverflow: TextOverflow.ellipsis,
                            size: textSize ?? 14.sp,
                            fontWeight: FontWeight.w700,
                            color: isOutlined.value ? bgColor:  textColor,
                          ),
                        ),
                                          ],
                                        ),
                      ),
                ],
              )),
        ),
      );
    }

    return Obx(() {
      return isOutlined.isTrue
          ? OutlinedButton(
              onPressed: () {
                if (funOnTap != null && isLoading.isFalse) {
                  funOnTap!();
                }
              },
              style: style,
              child: getContent(),
            )
          : ElevatedButton(
              onPressed: () {
                if (funOnTap != null && isLoading.isFalse) {
                  funOnTap!();
                }
              },
              style: style,
              child: getContent(),
            );
    });
  }
}
