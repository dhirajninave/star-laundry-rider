import 'package:laundry_boss_rider/features/notfications/logic/notifications_notifiers.dart';
import 'package:laundry_boss_rider/repositories/notfication_repo.dart';
import 'package:laundry_boss_rider/features/notfications/models/notification_list_model/notification_list_model.dart';
import 'package:laundry_boss_rider/services/api_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRepoProvider = Provider<INotificationRepo>((ref) {
  return NotificationRepo();
});

//
//
//
//
final allNotificationsProvider = StateNotifierProvider<NotificationListNotifier,
    ApiState<NotificationListModel>>((ref) {
  return NotificationListNotifier(ref.watch(profileRepoProvider));
});
//
//
//
//
final readNotificationsProvider = StateNotifierProvider.family
    .autoDispose<ReadNotificationNotifier, ApiState<String>, String>((ref, id) {
  return ReadNotificationNotifier(ref.watch(profileRepoProvider), id);
});
//
//
//
//
final deleteNotificationsProvider = StateNotifierProvider.family
    .autoDispose<DeleteNotificationNotifier, ApiState<String>, String>(
        (ref, id) {
  return DeleteNotificationNotifier(ref.watch(profileRepoProvider), id);
});
