class AppConstants {
  AppConstants._();
  // static const String baseUrl = 'https://adminlaundry.razinsoft.com/api';
  static const String baseUrl = 'https://admin.jaisrak.com/api';
  static const String loginUrl = '$baseUrl/driver/login';
  static const String logoutUrl = '$baseUrl/driver/logout';
  static const String registerUrl = '$baseUrl/driver/register';
  // notification
  static const String notificatons = '$baseUrl/driver/notifications';
  // order
  static const String totalOrders = '$baseUrl/driver/total-orders';
  static const String todaysPendingOrders = '$baseUrl/driver/todays-pending';
  static const String todaysJobs = '$baseUrl/driver/todays';
  static const String acceptOrder = '$baseUrl/driver/accept-order';
  static const String orderStatus = '$baseUrl/driver/orders-status';
  static const String thisWeekDelivery = '$baseUrl/driver/this-week';
  static const String orders = '$baseUrl/driver/orders';
  static const String orderHistories = '$baseUrl/driver/order-histories';
  // profile
  static const String profileUpdate = '$baseUrl/driver/profile-update';
  static const String changePassword = '$baseUrl/driver/change-password';
  // user
  static const String userUrl = '$baseUrl/driver/user';



  // app name
  static const appName = "Jais Laundry Rider";
}
