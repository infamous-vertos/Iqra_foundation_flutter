import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/transaction_model.dart';
import '../../../utils/global.dart';
import '../text/text_view.dart';

class ActivityTile extends StatelessWidget {
  final TransactionModel item;
  const ActivityTile({
    super.key,
    required this.item
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(width: 1.w, color: item.getColor().withAlpha(80)),
          color: item.getColor().withAlpha(10),
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
                  item.by.photoUrl ?? "NA",
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
              TextView(text: item.by.name),
              TextView(text: item.getTransactionSubtitle() , size: 12.sp, fontWeight: FontWeight.w400,),
              TextView(text: "Admin - ${item.by.uid == item.admin.uid ? "Self" : item.admin.name}" , size: 12.sp, fontWeight: FontWeight.w400,)

            ],
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 5.w, top: 5.h),
            child: Image.asset(item.getImagePath(), width: 30.w, color: item.getColor().withAlpha(150),),
          )
        ],
      ),
    );
  }
}
