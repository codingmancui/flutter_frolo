import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frolo/ui/widgets/bottom_navigation_bar.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:frolo/utils/object_util.dart';
import 'package:frolo/utils/utils.dart';
import 'package:sp_util/sp_util.dart';

import 'blocs/application_bloc.dart';
import 'blocs/bloc_provider.dart';
import 'blocs/main_bloc.dart';
import 'data/common/common.dart';
import 'data/net/dio_util.dart';

void main() {
  runApp(BlocProvider<ApplicationBloc>(
    bloc: ApplicationBloc(),
    child: MyApp(),
  ));

  SystemUiOverlayStyle style = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,

      ///这是设置状态栏的图标和字体的颜色
      ///Brightness.light  一般都是显示为白色
      ///Brightness.dark 一般都是显示为黑色
      statusBarIconBrightness: Brightness.light);
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
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Utils.createMaterialColor(Color(0xFF8BC34A)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BottomNavBar(),
    );
  }

  void _init() async {
    const bool inProduction = const bool.fromEnvironment("dart.vm.product");
    LogUtil.init(isDebug: !inProduction);
    if (!inProduction) {
      DioUtil.openDebug();
    }
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
    SpUtil.getInstance();
  }

  void init() {
    _init();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
