import 'package:flutter/foundation.dart';

class Constant {
  static const int status_success = 0;

  static const String server_address = wan_android;

  static const String wan_android = "https://www.wanandroid.com/";

  static const int type_login_success = 10000;

  static const String key_theme_color = 'key_theme_color';
  static const String key_guide = 'key_guide';
  static const String key_splash_model = 'key_splash_models';
  static const String keyUserModel = 'user_model';
  static const String keyAppToken = 'app_token';
  static const String keyUserCoinModel = 'user_coin_model';
}

class AppConfig {
  static const String appId = 'com.thl.flutterwanandroid';
  static const String appName = 'flutter_wanandroid';
  static const String version = '0.2.5';
  static const bool isDebug = kDebugMode;
}

class LoadingStatus {
  static const int fail = -1;
  static const int loading = 0;
  static const int success = 1;
  static const int empty = 2;
}
