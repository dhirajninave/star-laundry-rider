import 'package:dio/dio.dart';
import 'package:laundry_boss_rider/constants/app_constants.dart';
import 'package:laundry_boss_rider/features/notfications/models/notification_list_model/notification_list_model.dart';
import 'package:laundry_boss_rider/services/api_service.dart';

abstract class INotificationRepo {
  Future<NotificationListModel> getNotifications();
  Future<void> readNotfication({required String id});
  Future<void> deleteNotfication({required String id});
}

class NotificationRepo implements INotificationRepo {
  final Dio _dio = getDio();
  @override
  Future<NotificationListModel> getNotifications() async {
    var response = await _dio.get(AppConstants.notificatons);

    return NotificationListModel.fromMap(response.data);
  }

  @override
  Future<void> readNotfication({required String id}) async {
    await _dio.post('${AppConstants.notificatons}/$id');
  }

  @override
  Future<void> deleteNotfication({required String id}) async {
    await _dio.delete('${AppConstants.notificatons}/$id');
  }
}
