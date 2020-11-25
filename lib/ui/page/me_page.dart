import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frolo/blocs/application_bloc.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/me_bloc.dart';
import 'package:frolo/data/common/common.dart';
import 'package:frolo/provider/user_info_provider.dart';
import 'package:frolo/ui/page/login_page.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:frolo/utils/navigator_util.dart';
import 'package:frolo/utils/ui_gaps.dart';
import 'package:frolo/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

class MePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MePageState();
  }
}

class _MePageState extends State<MePage> with AutomaticKeepAliveClientMixin {
  final UserInfoProvider _userInfoProvider = new UserInfoProvider();

  @override
  void initState() {
    final ApplicationBloc applicationBloc =
        BlocProvider.of<ApplicationBloc>(context);
    final MeBloc meBloc = BlocProvider.of<MeBloc>(context);
    applicationBloc.appEventStream.listen((value) {
      LogUtil.v('me page init ApplicationBloc login success');
      _getUserInfo(meBloc);
    });
    _getUserInfo(meBloc);
    String cookie = SpUtil.getString(Constant.keyAppToken);
    LogUtil.v('Cookie is $cookie');

    super.initState();
  }

  void _getUserInfo(MeBloc meBloc) {
    meBloc.getUserCoinInfo(_userInfoProvider);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return ChangeNotifierProvider(
      create: (context) => _userInfoProvider,
      child: Scaffold(
          backgroundColor: Color(0xFFF6F6F6),
          body: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              Gaps.getVGap(60),
              new Selector(builder: (context, name, child) {
                return new Row(children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(left: 30, right: 20),
                    child: CircleAvatar(
                      //头像半径
                      radius: 38,
                      //头像图片 -> NetworkImage网络图片，AssetImage项目资源包图片, FileImage本地存储图片
                      backgroundImage: NetworkImage(
                          'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg'),
                    ),
                  ),
                  new InkWell(
                    onTap: () {
                      NavigatorUtil.pushPage(context, new LoginPage());
                    },
                    child: new Text(
                      name == null ? '去登录' : name,
                      style: new TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ]);
              }, selector: (BuildContext context, UserInfoProvider notifier) {
                return notifier.userName;
              }),
              Gaps.vGap20,
              new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                      child: new Center(
                    child: new Column(
                      children: <Widget>[
                        new Selector(builder: (context, coinCount, child) {
                          return new Text(
                            coinCount.toString(),
                            style: new TextStyle(color: Color(0xFF1B1B1B)),
                          );
                        }, selector:
                            (BuildContext context, UserInfoProvider notifier) {
                          return notifier.coinCount;
                        }),
                        Gaps.vGap5,
                        Text('积分',
                            style: new TextStyle(color: Color(0xFF7F7F7F))),
                      ],
                    ),
                  )),
                  new Expanded(
                      child: new Center(
                    child: new Column(
                      children: <Widget>[
                        new Selector(builder: (context, level, child) {
                          return new Text(
                            level.toString(),
                            style: new TextStyle(color: Color(0xFF1B1B1B)),
                          );
                        }, selector:
                            (BuildContext context, UserInfoProvider notifier) {
                          return notifier.level;
                        }),
                        Gaps.vGap5,
                        Text('等级',
                            style: new TextStyle(color: Color(0xFF7F7F7F))),
                      ],
                    ),
                  )),
                  new Expanded(
                      child: new Center(
                    child: new Column(
                      children: <Widget>[
                        new Selector(builder: (context, rank, child) {
                          return new Text(
                            rank,
                            style: new TextStyle(color: Color(0xFF1B1B1B)),
                          );
                        }, selector:
                            (BuildContext context, UserInfoProvider notifier) {
                          return notifier.rank;
                        }),
                        Gaps.vGap5,
                        Text('排名',
                            style: new TextStyle(color: Color(0xFF7F7F7F))),
                      ],
                    ),
                  )),
                ],
              ),
              new Container(
                width: double.infinity,
                height: 64,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                        child: new Center(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            Utils.getImgPath('ic_collect'),
                            fit: BoxFit.fill,
                          ),
                          Gaps.getVGap(2),
                          Text('收藏',
                              style: new TextStyle(
                                  color: Color(0xFF1B1B1B), fontSize: 12))
                        ],
                      ),
                    )),
                    new Expanded(
                        child: new Center(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            Utils.getImgPath('ic_history'),
                            fit: BoxFit.fill,
                          ),
                          Gaps.getVGap(2),
                          Text('历史',
                              style: new TextStyle(
                                  color: Color(0xFF1B1B1B), fontSize: 12))
                        ],
                      ),
                    )),
                    new Expanded(
                        child: new Center(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            Utils.getImgPath('ic_notification'),
                            fit: BoxFit.fill,
                          ),
                          Gaps.getVGap(2),
                          Text('消息',
                              style: new TextStyle(
                                  color: Color(0xFF1B1B1B), fontSize: 12))
                        ],
                      ),
                    )),
                    new Expanded(
                        child: new Center(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            Utils.getImgPath('ic_share'),
                            fit: BoxFit.fill,
                          ),
                          Gaps.getVGap(2),
                          Text('分享',
                              style: new TextStyle(
                                  color: Color(0xFF1B1B1B), fontSize: 12))
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
