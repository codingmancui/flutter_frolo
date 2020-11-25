import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:frolo/data/common/global.dart';
import 'package:frolo/ui/page/main_page.dart';
import 'package:frolo/ui/page/splash_page.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:frolo/utils/object_util.dart';
import 'package:frolo/utils/utils.dart';
import 'package:sp_util/sp_util.dart';

import 'blocs/application_bloc.dart';
import 'blocs/bloc_provider.dart';
import 'data/common/common.dart';
import 'data/net/dio_util.dart';

void main() {
  debugPaintSizeEnabled = false;
  Global.init(() {
    runApp(BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: MyApp(),
    ));
  });
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
      routes: {
        '/MainPage': (ctx) => MainPage(),
      },
      home: SplashPage(),
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
    String cookie = SpUtil.getString(Constant.keyAppToken);
    if (ObjectUtil.isNotEmpty(cookie)) {
      Map<String, dynamic> _headers = new Map();
      _headers["Cookie"] = cookie;
      options.headers = _headers;
    }
    LogUtil.v('Cookie is $cookie');
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
