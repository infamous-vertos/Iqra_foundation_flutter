import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iqra/ui/theme/ui_constants.dart';

import '../../../gen/assets.gen.dart';
import '../text/text_view.dart';

class CategoryItem extends StatelessWidget {
  final String iconPath, title;
  final int amount;
  final Color iconColor;
  const CategoryItem({
    super.key,
    required this.iconPath,
    required this.title,
    required this.amount,
    required this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .45.sw,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(width: 1.w, color: Colors.grey),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            offset: Offset(2.w, 2.h),
            blurRadius: 0.r,
            spreadRadius: 1.r, // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 5.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextView(
              text: title,
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    letterSpacing: .5,
                    fontSize: 16
                ),
              ),
            ),

            Row(
              children: [
                Image.asset(
                  iconPath,
                  width: 30.w,
                  color: iconColor
                ),
                Spacer(),
                Column(
                  children: [
                    Row(
                      children: [
                        TextView(text: UiConstants.rupeeSymbol),
                        TextView(
                          text: amount.toString(),
                          style: GoogleFonts.quantico(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24
                              )
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
