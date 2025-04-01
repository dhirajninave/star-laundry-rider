import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_boss_rider/constants/app_box_decoration.dart';
import 'package:laundry_boss_rider/constants/app_colors.dart';
import 'package:laundry_boss_rider/constants/app_durations.dart';
import 'package:laundry_boss_rider/constants/app_text_decor.dart';
import 'package:laundry_boss_rider/constants/hive_contants.dart';
import 'package:laundry_boss_rider/features/core/views/widgets/order_tile_text_row.dart';
import 'package:laundry_boss_rider/features/orders/logic/order_provider.dart';
import 'package:laundry_boss_rider/features/orders/models/pending_order_list_model/order.dart';
import 'package:laundry_boss_rider/features/orders/models/pending_order_list_model/product.dart';
import 'package:laundry_boss_rider/utils/global_functions.dart';
import 'package:laundry_boss_rider/widgets/buttons/full_width_button.dart';
import 'package:laundry_boss_rider/widgets/misc_widgets.dart';
import 'package:laundry_boss_rider/widgets/nav_bar.dart';
import 'package:laundry_boss_rider/widgets/screen_wrapper.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  late Order _order;
  int qty = 0;

  @override
  void initState() {
    _order = widget.order;
    debugPrint("order ${_order.toJson()}");
    debugPrint("order ${_order.products?.toList()}");
    debugPrint("order2222${_order.orderStatus}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderStatus = AppGFunctions.getUserOrderType(_order.orderStatus);
    bool pick = orderStatus == OrderType.pickUp;

    debugPrint("Order Status222223: $orderStatus $pick" );
    qty = 0;
    for (var element in _order.quantity!.quantity) {
      qty += element.quantity;
    }
    debugPrint("total qty $qty");
    final List<OrderDetailsTile> orderWidgets = [];

    for (var i = 0; i < _order.products!.length; i++) {
      orderWidgets.add(
        OrderDetailsTile(
          product: _order.products![i],
          qty: _order.quantity?.quantity[i].quantity,
        ),
      );
    }

    return ScreenWrapper(
      color: AppColors.white,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 12.h),
                decoration: AppBoxDecorations.topBar2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacerH(44.h),
                    AppNavbar(
                        showBack: true,
                        title: Center(
                          child: OrderTileTextRow(
                            center: true,
                            title: 'Order ID:',
                            content: '#IM${_order.id}',
                          ),
                        )),
                    AppSpacerH(12.h),
                    Row(
                      children: [
                        SizedBox(
                          height: 60.h,
                          width: 60.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.w),
                            child: Image.network(
                              _order.customer!.user!.profilePhotoPath!,
                              height: 60.h,
                              width: 60.w,
                            ),
                          ),
                        ),
                        AppSpacerW(12.w),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _order.customer?.user?.name ?? '',
                              style: AppTextDecor.osBold18black,
                            ),
                            Text(
                              _order.customer?.user?.mobile ?? '',
                              style: AppTextDecor.osRegular14black,
                            )
                          ],
                        ),
                        const Expanded(child: SizedBox()),
                        GestureDetector(
                          onTap: () async {
                            await launchUrlString(
                                'tel:${_order.customer?.user?.mobile}');
                          },
                          child: SvgPicture.asset(
                            'assets/svgs/icon_call.svg',
                            height: 36.h,
                            width: 36.w,
                          ),
                        )
                      ],
                    ),
                    AppSpacerH(16.h),
                    Row(
                      children: [
                        ColumnText(
                            title: 'Pick-up Date:',
                            content: _order.pickDate ?? ''),
                        const Expanded(child: SizedBox()),
                        ColumnText(
                            title: 'Time:', content: _order.pickHour ?? ''),
                      ],
                    ),
                    AppSpacerH(12.h),
                    Row(
                      children: [
                        ColumnText(
                            title: 'Address:',
                            content: AppGFunctions.processAdAddess(_order)
                            //'House #12, Flat #D2, Block #C, Road # 3, Mohammadpur, Dhaka'
                            ),    const Expanded(child: SizedBox()),
                            PaymentText(
  title: 'Payment Type',
  content: _order.paymentType ?? '',
),

                      ],
                    ),
                    Row(
  children: [
    ColumnText(title: "Total Amount ", content: _order.totalAmount?.toStringAsFixed(2) ?? '0.00')
  ],
),

                        
                    AppSpacerH(8.h),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ),
                  child: ListView(
                    children: [
                      AppSpacerH(16.h),
                      Container(
                        decoration: AppBoxDecorations.borderDecoration,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        child: ExpandablePanel(
                          header: Text(
                            'Total quantity (${qty.toString()})',
                            style: AppTextDecor.osBold14black,
                          ),
                          collapsed: const SizedBox(),
                          expanded: Column(
                            children: orderWidgets,
                          ),
                        ),
                      ),
                      AppSpacerH(10.h),
                      Container(
                        decoration: AppBoxDecorations.grayContainer,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Additional Instruction:',
                              style: AppTextDecor.osRegular12Navy,
                            ),
                            AppSpacerH(15.h),
                            Text(
                              _order.address?.deliveryNote ?? '', //FIXME
                              style: AppTextDecor.osRegular14black,
                            )
                          ],
                        ),
                      ),
                      AppSpacerH(100.h)
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (orderStatus == OrderType.pickUp ||
              orderStatus == OrderType.delivery)
            Positioned(
              bottom: 0,
              child: Container(
                width: 375.w,
                color: AppColors.white,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Center(
                  child: ref.watch(orderUpdateProvider).map(
                        initial: (_) => AppTextButton(
                         onTap: () {
  TextEditingController amountController = TextEditingController();


  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          "Confirm Payment",
          style: AppTextDecor.osBold14black,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ColumnText(
                title: "Action Confirmation",
                content: pick
                    ? "Are you sure you picked up this order?"
                    : "Are you sure you delivered this order?",
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  ColumnText(
                    title: "Total Amount",
                    content: _order.totalAmount?.toStringAsFixed(2) ?? '0.00',
                  ),
                  const Spacer(),
                  // Uncomment if needed
                  // ColumnTextColored(
                  //   title: "Total Amount in Wallet",
                  //   content: "AED ${walletAmount.toStringAsFixed(2)}",
                  //   color: walletAmount >= (_order.totalAmount ?? 0.0) ? Colors.green : Colors.red,
                  // ),
                ],
              ),

              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter Amount",
                  labelStyle: AppTextDecor.osRegular12Navy,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.black,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: AppTextDecor.osRegular14red),
          ),
          TextButton(
            onPressed: () {
              String enteredAmount = amountController.text.trim();

              if (enteredAmount.isEmpty || double.tryParse(enteredAmount) == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.red,
                    content: Text(
                      "Please enter a valid amount",
                      style: AppTextDecor.osBold14white,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                );
                return;
              }
               double paidAmount = double.parse(enteredAmount);
              Navigator.pop(context);

              ref.watch(orderUpdateProvider.notifier).updateOrder(
                    id: _order.id.toString(),
                    status: pick ? 'picked_order' : 'delivered',
                     paidAmount: paidAmount,
                  );
            },
            child: Text("Confirm", style: AppTextDecor.osRegular14black),
          ),
        ],
      );
    },
  );
},


                          //commented by me 
                            // onTap: () {
                            //   ref
                            //       .watch(orderUpdateProvider.notifier)
                            //       .updateOrder(
                            //           id: _order.id.toString(),
                            //           status:
                            //               pick ? 'picked_order' : 'delivered');
                            // },
                            //commented by me 
                            buttonColor: pick
                                ? AppColors.secondaryColor
                                : AppColors.cardGreen,
                            title: pick ? 'I picked it up' : 'I delivered it'),
                        loading: (_) => const LoadingWidget(),
                        loaded: (_) {
                          setState(() {
                            _order = _.data.data!.order!;
                          });
                          Future.delayed(AppDurConst.buildDuration)
                              .then((value) {
                            ref.refresh(orderUpdateProvider);
                            ref.refresh(totalOrderListProvider);
                            ref.refresh(todaysJobListProvider);

                            ref.refresh(todaysPendingOrderListProvider);
                            ref.refresh(thisWeekDeliveryListProvider);
                          });
                          return const MessageTextWidget(msg: 'Succes');
                        },
                        error: (_) {
                          Future.delayed(AppDurConst.buildDuration)
                              .then((value) {
                            ref.refresh(orderUpdateProvider);
                          });
                          return ErrorTextWidget(error: _.error);
                        },
                      ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class ColumnText extends StatelessWidget {
  const ColumnText({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextDecor.osRegular12Navy,
        ),
        Text(
          content,
          style: AppTextDecor.osBold12black,
        ),
      ],
    );
  }
}
class PaymentText extends StatelessWidget {
  const PaymentText({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextDecor.osRegular12Navy, // Grey style for title
        ),
        if (content == "cash_on_delivery") ...[
          
          Text(
            "COD",
            style: AppTextDecor.osBold12black, // Bold text
          ),Text(
            "(Cash On Delivery)",
            style: AppTextDecor.osRegular12Navy, // Grey text
          ),
        ] else if (content == "cash_on_collection") ...[
          
          Text(
            "COC",
            style: AppTextDecor.osBold12black, // Bold text
          ),
          Text(
            "(Cash On Collection)",
            style: AppTextDecor.osRegular12Navy, // Grey text
          ),
        ] else ...[
          Text(
            content,
            style: AppTextDecor.osBold12black, // Default bold content
          ),
        ]
      ],
    );
  }
}
class ColumnTextColored extends StatelessWidget {
  const ColumnTextColored({
    Key? key,
    required this.title,
    required this.content,
    required this.color, // Accepts a color for text
  }) : super(key: key);

  final String title;
  final String content;
  final Color color; // Defines the text color

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextDecor.osRegular12Navy,
        ),
        Text(
          content,
          style: AppTextDecor.osBold12black.copyWith(color: color), // Apply dynamic color
        ),
      ],
    );
  }
}


class OrderDetailsTile extends StatelessWidget {
  const OrderDetailsTile({
    Key? key,
    required this.product,
    required this.qty,
  }) : super(key: key);
  final Product product;
  final int? qty;

  @override
  Widget build(BuildContext context) {
    final Box settingsBox = Hive.box(AppHSC.appSettingsBox);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: SizedBox(
        // height: 40.h,
        width: 297.w,
        child: Row(
          children: [
            Image.network(
              product.imagePath!,
              height: 40.h,
              width: 42.w,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name!,
                          style: AppTextDecor.osBold12black,
                        ),
                      ),
                      Text(
                        '$qty',
                        style: AppTextDecor.osBold12gold,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.service?.name ?? '',
                          style: AppTextDecor.osRegular12Navy,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}