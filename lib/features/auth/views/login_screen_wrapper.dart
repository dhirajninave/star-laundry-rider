import 'package:laundry_boss_rider/constants/app_colors.dart';
import 'package:laundry_boss_rider/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreenWrapper extends StatelessWidget {
  const LoginScreenWrapper({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      color: AppColors.grayBG,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          SizedBox(
            height: 812.h,
            width: 375.w,
            child: child,
          )
        ],
      ),
    );
  }
}
