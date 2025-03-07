import 'package:dio/dio.dart';
import 'package:laundry_boss_rider/constants/app_constants.dart';

import '../services/api_service.dart';

class NotficationHelper {
  static final Dio _dio = getDio();

  static Future<void> readNotfication({required String id}) async {
    await _dio.post('${AppConstants.notificatons}/$id');
  }

  static Future<void> deleteNotfication({required String id}) async {
    await _dio.delete('${AppConstants.notificatons}/$id');
  }
}
