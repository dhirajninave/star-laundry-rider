import 'package:laundry_boss_rider/constants/app_colors.dart';
import 'package:laundry_boss_rider/constants/app_text_decor.dart';
import 'package:laundry_boss_rider/features/core/logic/misc_provider.dart';
import 'package:laundry_boss_rider/features/core/views/home_tab.dart';
import 'package:laundry_boss_rider/features/orders/logic/order_provider.dart';
import 'package:laundry_boss_rider/features/orders/views/orders_tab.dart';
import 'package:laundry_boss_rider/features/profile/views/profile_tab.dart';
import 'package:laundry_boss_rider/widgets/misc_widgets.dart';
import 'package:laundry_boss_rider/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    ref.watch(statusListProvider);
    return ScreenWrapper(
        child: Column(
      children: [
        Expanded(
          child: Consumer(builder: (context, ref, child) {
            return IndexedStack(
              index: selectedIndex,
              children: const [HomeTab(), OrdersTab(), ProfileTab()],
            );
          }),
        ),
        Container(
          width: 375.w,
          height: 70.h,
          color: AppColors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BottomMenuItem(
                title: 'DashBoard',
                icon: 'assets/svgs/icon_grid.svg',
                selected: selectedIndex == 0,
                ontap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },
              ),
              BottomMenuItem(
                title: 'Jobs',
                icon: 'assets/svgs/icon_rider.svg',
                selected: selectedIndex == 1,
                ontap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
              ),
              BottomMenuItem(
                title: 'Profile',
                icon: 'assets/svgs/icon_profile.svg',
                selected: selectedIndex == 2,
                ontap: () {
                  setState(() {
                    selectedIndex = 2;
                  });
                },
              ),
            ],
          ),
        )
      ],
    ));
  }
}

class BottomMenuItem extends ConsumerWidget {
  const BottomMenuItem({
    Key? key,
    required this.selected,
    required this.title,
    required this.icon,
    this.ontap,
  }) : super(key: key);
  final bool selected;
  final String title;
  final String icon;
  final Function()? ontap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentIndex = ref.watch(appBottomBarIndexProvider);
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.only(top: 10.h),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: selected
                        ? AppColors.secondaryColor
                        : Colors.transparent,
                    width: 3.h))),
        height: 60.h,
        child: Column(
          children: [
            SvgPicture.asset(
              icon,
              height: 24.h,
              width: 24.h,
              color: selected ? AppColors.secondaryColor : AppColors.navyText,
            ),
            const AppSpacerH(4),
            Text(
              title,
              style: selected
                  ? AppTextDecor.osRegular10Gold
                  : AppTextDecor.osRegular10Navy,
            )
          ],
        ),
      ),
    );
  }
}
