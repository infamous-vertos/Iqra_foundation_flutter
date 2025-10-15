import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/assets.gen.dart';

class UserDpName extends StatelessWidget {
  const UserDpName({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(width: 1.w, color: Colors.black)
          ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: Image.network(
                  "https://media.licdn.com/dms/image/v2/D4D03AQEuEpIMqUBfPg/profile-displayphoto-scale_400_400/B4DZhRB.7tGkAo-/0/1753706133954?e=1762992000&v=beta&t=9OZE0phWW1MsIdDgj1zVvjZh-fq0ltCo_solfh5Kyr0",
                  width: 20.w,
                  height: 20.w,
                fit: BoxFit.cover,
              ),
            )
        ),
        Text("Md Saif Uddin", maxLines: 1, overflow: TextOverflow.ellipsis,)
      ],
    );
  }
}
