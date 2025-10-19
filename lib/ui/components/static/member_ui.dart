import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iqra/models/user_model.dart';
import 'package:iqra/ui/components/text/text_view.dart';

import '../../../gen/assets.gen.dart';

class MemberUi extends StatelessWidget {
  final UserModel user;
  const MemberUi({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(width: 1.w, color: Colors.black)
              ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.r),
                  child: Image.network(
                      user.photoUrl ?? "NA",
                      width: 40.w,
                      height: 40.w,
                    fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.person_sharp, size: 24.w,)
                  ),
                )
            ),

            SizedBox(width: 8.w,),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextView(text: user.name, maxLines: 1,),
                TextView(
                  text: user.email ?? "NA",
                  maxLines: 1,
                  fontWeight: FontWeight.w400,
                  size: 12.sp
                ),
              ],
            ),
            
            Spacer(),
            
            Icon(Icons.arrow_forward)
          ],
        ),
      ),
    );
  }
}
