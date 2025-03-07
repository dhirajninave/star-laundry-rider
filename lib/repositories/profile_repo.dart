import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_boss_rider/constants/app_constants.dart';
import 'package:laundry_boss_rider/constants/hive_contants.dart';
import 'package:laundry_boss_rider/features/profile/models/user_model/user_model.dart';
import 'package:laundry_boss_rider/services/api_service.dart';

abstract class IProfileRepo {
  Future<UserModel> getUserDetails();
  Future<void> updateProfile({required Map<String, dynamic> data, File? file});
  Future<void> updatePassword({required Map<String, dynamic> data});
  Future<void> deactivate();
}

class ProfileRepo implements IProfileRepo {
  final Dio _dio = getDio();
  @override
  Future<UserModel> getUserDetails() async {
    var response = await _dio.get(AppConstants.userUrl);

    return UserModel.fromMap(response.data);
  }

  @override
  Future<void> updateProfile(
      {required Map<String, dynamic> data, File? file}) async {
    final ext = file?.path.split('.').last;

    await _dio.post(AppConstants.profileUpdate,
        data: FormData.fromMap({
          ...data,
          'profile_photo': file != null
              ? await MultipartFile.fromFile(
                  file.path,
                  filename:
                      "${DateTime.now().millisecondsSinceEpoch.toString()}.$ext", 
                )
              : null,
        }));
  }

  @override
  Future<void> updatePassword({required Map<String, dynamic> data}) async {
    await _dio.post(AppConstants.changePassword, data: FormData.fromMap(data));
  }

  @override
  Future<void> deactivate() async {
    Box userbox = Hive.box(AppHSC.userBox);
    var userID = userbox.get(AppHSC.userID);

    await _dio.get('${AppConstants.userUrl}/$userID/toggle-status');
  }
}
