import 'package:laundry_boss_rider/constants/hive_contants.dart';
import 'package:laundry_boss_rider/utils/context_less_nav.dart';
import 'package:laundry_boss_rider/utils/routes.dart';
import 'package:laundry_boss_rider/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Box authBox = Hive.box(AppHSC.authBox);
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      context.nav.pushNamedAndRemoveUntil(
        (authBox.get(AppHSC.authToken) != null &&
                authBox.get(AppHSC.authToken) != '')
            ? Routes.homePage
            : Routes.loginScreen,

        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Center(
        child: Hero(
          tag: 'logo',
          child: Image.asset(
            'assets/images/logo.png',
            
            //  height: 200.h,
            width: 260.w,
          ),
        ),
      ),
    );
  }
}
