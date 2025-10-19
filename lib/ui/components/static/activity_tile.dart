import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../text/text_view.dart';

class ActivityTile extends StatelessWidget {
  final Color color;
  final String name, subtitle, imgUrl, iconPath;
  const ActivityTile({
    super.key,
    required this.color,
    required this.name,
    required this.subtitle,
    required this.imgUrl,
    required this.iconPath
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(width: 1.w, color: color.withAlpha(80)),
          color: color.withAlpha(10),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withValues(alpha: 0.3),
        //     offset: Offset(2.w, 2.h),
        //     blurRadius: 0.r,
        //     spreadRadius: 1.r, // changes position of shadow
        //   ),
        // ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(width: 1.w, color: Colors.black)
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: Image.network(
                  imgUrl,
                  width: 40.w,
                  height: 40.w,
                  fit: BoxFit.cover,
                ),
              )
          ),
          SizedBox(width: 10.w,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextView(text: name),
              TextView(text: subtitle, size: 12.sp, fontWeight: FontWeight.w400,)
            ],
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 5.w, top: 5.h),
            child: Image.asset(iconPath, width: 30.w, color: color.withAlpha(150),),
          )
        ],
      ),
    );
  }
}
