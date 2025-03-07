import 'package:laundry_boss_rider/constants/app_constants.dart';
import 'package:laundry_boss_rider/features/orders/models/order_histories_model/order_histories_model.dart';
import 'package:laundry_boss_rider/features/orders/models/order_update/order_update.dart';
import 'package:laundry_boss_rider/features/orders/models/pending_order_list_model/pending_order_list_model.dart';
import 'package:laundry_boss_rider/features/orders/models/status_model/status_model.dart';
import 'package:laundry_boss_rider/features/orders/models/this_week_delivery_model/this_week_delivery_model.dart';
import 'package:laundry_boss_rider/features/orders/models/todays_job_model/todays_job_model.dart';
import 'package:laundry_boss_rider/features/orders/models/todays_pending_order_model/todays_pending_order_model.dart';
import 'package:laundry_boss_rider/services/api_service.dart';

abstract class IOrderRepo {
  Future<PendingOrderListModel> getTotalOrders({required String isAccepted});
  Future<TodaysPendingOrderModel> getTodaysPendingOrders();
  Future<TodaysJobModel> getTodaysJobs();
  Future<void> acceptOrder({required String id, required String status});
  Future<StatusModel> getStatusList();
  Future<ThisWeekDeliveryModel> getThisWeekDeliveryList();
  Future<OrderUpdate> updateOrder({required String id, required String status});
  Future<OrderHistoriesModel> getOrderHistory();
}

class OrderRepo implements IOrderRepo {
  final _dio = getDio();
  @override
  Future<PendingOrderListModel> getTotalOrders(
      {required String isAccepted}) async {
    var response = await _dio.get(AppConstants.totalOrders,
        queryParameters: {'isAccept': isAccepted});

    return PendingOrderListModel.fromMap(response.data);
  }

  @override
  Future<TodaysPendingOrderModel> getTodaysPendingOrders() async {
    var response = await _dio.get(AppConstants.todaysPendingOrders);

    return TodaysPendingOrderModel.fromMap(response.data);
  }

  @override
  Future<TodaysJobModel> getTodaysJobs() async {
    var response = await _dio.get(AppConstants.todaysJobs);

    return TodaysJobModel.fromMap(response.data);
  }

  @override
  Future<void> acceptOrder({required String id, required String status}) async {
    await _dio.get('${AppConstants.acceptOrder}/$id?isAccept=$status');
  }

  @override
  Future<StatusModel> getStatusList() async {
    var response = await _dio.get(AppConstants.orderStatus);

    return StatusModel.fromMap(response.data);
  }

  @override
  Future<ThisWeekDeliveryModel> getThisWeekDeliveryList() async {
    var response = await _dio.get(AppConstants.thisWeekDelivery);

    return ThisWeekDeliveryModel.fromMap(response.data);
  }

  @override
  Future<OrderUpdate> updateOrder(
      {required String id, required String status}) async {
    var response =
        await _dio.get('${AppConstants.orders}/$id/update?status=$status');

    return OrderUpdate.fromMap(response.data);
  }

  @override
  Future<OrderHistoriesModel> getOrderHistory() async {
    var response = await _dio.get(AppConstants.orderHistories);

    return OrderHistoriesModel.fromMap(response.data);
  }
}
