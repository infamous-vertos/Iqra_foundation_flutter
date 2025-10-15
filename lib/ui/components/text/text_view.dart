import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

class TextView extends StatelessWidget {
  final double? size;
  final String text;
  final Color color;
  final bool isSoftWrap;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final FontStyle fontStyle;
  final TextDecoration textDecoration;
  final String? fontFamily;
  final TextStyle? style;

  const TextView(
      {super.key,
        required this.text,
        this.size,
        this.color = AppColors.styleBlack,
        this.isSoftWrap = true,
        this.fontWeight = FontWeight.w600,
        this.textAlign = TextAlign.start,
        this.maxLines,
        this.textOverflow,
        this.fontStyle = FontStyle.normal,
        this.textDecoration = TextDecoration.none,
        this.fontFamily,
        this.style
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      softWrap: isSoftWrap,
      maxLines:maxLines,
      overflow: textOverflow,
      style: style ?? TextStyle(
        fontFamily: fontFamily,
        fontSize: size ?? 14.sp,
        fontWeight: fontWeight,
        color: color,
        fontStyle: fontStyle,
        decoration: textDecoration
      ),
    );
  }
}
