import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/assets.gen.dart';
import '../text/text_view.dart';

class NotFound extends StatelessWidget {
  String? text;
  NotFound({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.anim.animCat1.lottie(width: 200.w),
          TextView(text: text ?? "Not Found"),
        ],
      ),
    );
  }
}
