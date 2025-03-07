import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:laundry_boss_rider/constants/app_colors.dart';
import 'package:laundry_boss_rider/constants/app_text_decor.dart';
import 'package:laundry_boss_rider/constants/hive_contants.dart';
import 'package:laundry_boss_rider/features/auth/logic/auth_provider.dart';
import 'package:laundry_boss_rider/features/notfications/logic/notifications_providers.dart';
import 'package:laundry_boss_rider/features/orders/logic/order_provider.dart';
import 'package:laundry_boss_rider/features/profile/logic/profile_provider.dart';
import 'package:laundry_boss_rider/utils/context_less_nav.dart';
import 'package:laundry_boss_rider/utils/routes.dart';
import 'package:laundry_boss_rider/widgets/misc_widgets.dart';

class AppNavbarHome extends ConsumerWidget {
  const AppNavbarHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('EEE,dd-MMM-yyyy');
    return ValueListenableBuilder(
        valueListenable: Hive.box(AppHSC.userBox).listenable(),
        builder: (context, Box userbox, child) {
          return SizedBox(
            height: 44.h,
            width: 345.w,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22.h),
                  child: Container(
                    height: 44.h,
                    width: 44.h,
                    padding: const EdgeInsets.all(4),
                    child: userbox.get(AppHSC.userPhoto) != null
                        ? Image.network(userbox.get(AppHSC.userPhoto))
                        : Image.asset('assets/images/02.tutorial.png'),
                  ),
                ),
                AppSpacerW(6.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      userbox.get(AppHSC.userFullName) ?? '',
                      style: AppTextDecor.osBold14black,
                    ),
                    Text(
                      dateFormat.format(DateTime.now()),
                    
                      style: AppTextDecor.osRegular10Navy,
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          ref.refresh(
                            loginProvider,
                          ); //Refresh This so That App Doesn't Auto Login
                          //Refresh All Data
                          ref.refresh(userDetailsProvider);
                          ref.refresh(totalOrderListProvider);
                          ref.refresh(orderHistoriesProvider);
                          ref.refresh(todaysPendingOrderListProvider);
                          ref.refresh(todaysJobListProvider);
                          ref.refresh(acceptOrderProvider);
                          ref.refresh(thisWeekDeliveryListProvider);
                          ref.refresh(orderUpdateProvider);
                          ref.refresh(allNotificationsProvider);
                          ref.refresh(userDetailsProvider);
                          ref.refresh(userProfileUpdateProvider);
                          ref.refresh(userPasswordUpdateProvider);
                        },
                        child: Container(
                          height: 40.h,
                          width: 40.h,
                          decoration: BoxDecoration(
                              color: AppColors.grayBG,
                              borderRadius: BorderRadius.circular(20.h)),
                          child: const Icon(Icons.refresh),
                        ),
                      ),
                      AppSpacerW(10.w),
                      GestureDetector(
                        onTap: () {
                          context.nav.pushNamed(Routes.notficationsScreen);
                        },
                        child: Container(
                          height: 40.h,
                          width: 40.h,
                          decoration: BoxDecoration(
                              color: AppColors.grayBG,
                              borderRadius: BorderRadius.circular(20.h)),
                          child: const Icon(Icons.notifications),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
