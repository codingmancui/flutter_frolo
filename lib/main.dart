
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:frolo/ui/widgets/bottom_navigation_bar.dart';
import 'package:frolo/utils/object_util.dart';
import 'package:frolo/utils/utils.dart';

import 'blocs/application_bloc.dart';
import 'blocs/bloc_provider.dart';
import 'blocs/main_bloc.dart';
import 'data/common/common.dart';
import 'data/net/dio_util.dart';

void main() {
  runApp(BlocProvider<ApplicationBloc>(
    bloc: ApplicationBloc(),
    child: BlocProvider(child: MyApp(), bloc: MainBloc()),
  ));

    SystemUiOverlayStyle style = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        ///这是设置状态栏的图标和字体的颜色
        ///Brightness.light  一般都是显示为白色
        ///Brightness.dark 一般都是显示为黑色
        statusBarIconBrightness: Brightness.light
    );
    SystemChrome.setSystemUIOverlayStyle(style);
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    init();
    _statusBar();
  }

  /// 状态栏样式 沉浸式状态栏
  _statusBar() {
    // 白色沉浸式状态栏颜色  白色文字
    SystemUiOverlayStyle light = SystemUiOverlayStyle(
      /// 注意安卓要想实现沉浸式的状态栏 需要底部设置透明色
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(light);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Utils.createMaterialColor(Colors.green),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BottomNavBar(),
    );
  }

  void _init() {
    DioUtil.openDebug();
    Options options = DioUtil.getDefOptions();
    options.baseUrl = Constant.server_address;
    String cookie = 'app_token';
    if (ObjectUtil.isNotEmpty(cookie)) {
      Map<String, dynamic> _headers = new Map();
      _headers["Cookie"] = cookie;
      options.headers = _headers;
    }
    HttpConfig config = new HttpConfig(options: options);
    DioUtil().setConfig(config);
  }

  void init() {
    _init();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
