import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class HorizontalShimmer extends StatelessWidget {
  final int count;
  HorizontalShimmer({super.key, required this.count});

  final shimmerItem = Shimmer.fromColors(
    direction: ShimmerDirection.ltr,
    baseColor: Colors.grey.shade200,
    highlightColor: Colors.grey.shade400,
    child: Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        border: Border.all(width: 2.w, color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100.r),
            child: Container(
              width: 40.h,
              height: 40.h,
              color: Colors.grey.shade400,
            ),
          ),

          SizedBox(width: 10.w,),

          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.grey.shade400,
                width: 150.w,
                height: 10.h,
              ),
              SizedBox(height: 5.h,),
              Container(
                color: Colors.grey.shade400,
                width: 100.w,
                height: 5.h,
              ),
              SizedBox(height: 5.h,),
              Container(
                color: Colors.grey.shade400,
                width: 100.w,
                height: 5.h,
              ),
            ],
          )
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    if(count == 1){
      return shimmerItem;
    }
    return Flexible(
      child: ListView(
        children: [
          for (var i = 0; i < count; i++)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: shimmerItem,
            ),
        ],
      ),
    );
  }
}
