import 'package:dio/dio.dart';
import 'package:laundry_boss_rider/constants/app_constants.dart';
import 'package:laundry_boss_rider/features/auth/models/login_model/login_model.dart';
import 'package:laundry_boss_rider/features/auth/models/register_model/register_model.dart';
import 'package:laundry_boss_rider/services/api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class IAuthRepo {
  Future<LoginModel> login(
      {required String contact,
      required String password,
      required String deviceKey});
  Future<RegisterModel> register({required Map<String, dynamic> data});
  Future<void> logout({required String deviceKey});
}

class AuthRepo implements IAuthRepo {
  final _dio = getDio();
  @override
  Future<LoginModel> login(
      {required String contact,
      required String password,
      required String deviceKey}) async {
    final token = await FirebaseMessaging.instance.getToken();
    var response = await _dio.post(AppConstants.loginUrl,
        data: {'contact': contact, 'password': password, 'device_key': token});

    return LoginModel.fromMap(response.data);
  }

  @override
  Future<void> logout({required String deviceKey}) async {
    final deviceKey = await FirebaseMessaging.instance.getToken();
    await _dio.get(AppConstants.logoutUrl,
        queryParameters: {'device_key': deviceKey});
  }

  @override
  Future<RegisterModel> register({required Map<String, dynamic> data}) async {
    final token = await FirebaseMessaging.instance.getToken();
    var response =
        await _dio.post(AppConstants.registerUrl, data: FormData.fromMap(data));

    return RegisterModel.fromMap(response.data);
  }
}
