import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frolo/blocs/application_bloc.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/coin_bloc.dart';
import 'package:frolo/blocs/collect_bloc.dart';
import 'package:frolo/blocs/me_bloc.dart';
import 'package:frolo/data/common/common.dart';
import 'package:frolo/provider/user_info_provider.dart';
import 'package:frolo/ui/page/coin_detail_page.dart';
import 'package:frolo/ui/page/collect_page.dart';
import 'package:frolo/ui/page/history_page.dart';
import 'package:frolo/ui/page/login_page.dart';
import 'package:frolo/ui/widgets/loading/pulse.dart';
import 'package:frolo/ui/widgets/web_page.dart';
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(64),
                      child: new CachedNetworkImage(
                        width: 64,
                        height: 64,
                        fit: BoxFit.fill,
                        imageUrl:
                            'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg',
                        placeholder: (BuildContext context, String url) {
                          return new SpinKitPulse(color: Colors.lightGreen);
                        },
                        errorWidget:
                            (BuildContext context, String url, Object error) {
                          return new Icon(
                            Icons.error,
                            color: Colors.lightGreen,
                          );
                        },
                      ),
                    ),
                  ),
                  new InkWell(
                    onTap: () {
                      if (!Utils.isLogin()) {
                        NavigatorUtil.pushPage(context, new LoginPage());
                      }
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
                      child: new InkWell(
                    onTap: () {
                      Utils.isLogin()
                          ? NavigatorUtil.pushPage(
                              context,
                              BlocProvider(
                                  child: CoinDetailPage(
                                      _userInfoProvider.coinCount),
                                  bloc: new CoinBloc()))
                          : NavigatorUtil.pushPage(context, LoginPage());
                    },
                    child: new Center(
                      child: new Column(
                        children: <Widget>[
                          new Selector(builder: (context, coinCount, child) {
                            return new Text(
                              coinCount.toString(),
                              style: new TextStyle(color: Color(0xFF1B1B1B)),
                            );
                          }, selector: (BuildContext context,
                              UserInfoProvider notifier) {
                            return notifier.coinCount;
                          }),
                          Gaps.vGap5,
                          Text('积分',
                              style: new TextStyle(color: Color(0xFF7F7F7F))),
                        ],
                      ),
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
                margin: EdgeInsets.only(top: 20),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                        child: new Center(
                      child: new InkWell(
                        onTap: () {
                          Utils.isLogin()
                              ? NavigatorUtil.pushPage(
                                  context,
                                  BlocProvider(
                                      child: CollectPage(),
                                      bloc: new CollectBloc()))
                              : NavigatorUtil.pushPage(context, LoginPage());
                        },
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
                      ),
                    )),
                    new Expanded(
                        child: new Center(
                      child: new InkWell(
                        onTap: () {
                          NavigatorUtil.pushPage(context, new HistoryPage());
                        },
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
              Gaps.getVGap(35),
              new InkWell(
                onTap: () {},
                child: new Container(
                  padding: EdgeInsets.only(left: 40, right: 20),
                  width: double.infinity,
                  height: 48,
                  color: Colors.white,
                  child: new Row(
                    children: <Widget>[
                      Text('常用网站'),
                      new Expanded(child: new Container()),
                      new Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
              new InkWell(
                onTap: () {},
                child: new Container(
                  padding: EdgeInsets.only(left: 40, right: 20),
                  width: double.infinity,
                  height: 48,
                  color: Colors.white,
                  child: new Row(
                    children: <Widget>[
                      Text('本站问答'),
                      new Expanded(child: new Container()),
                      new Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
              new InkWell(
                onTap: () {},
                child: new Container(
                  padding: EdgeInsets.only(left: 40, right: 20),
                  width: double.infinity,
                  height: 48,
                  color: Colors.white,
                  child: new Row(
                    children: <Widget>[
                      Text('我要反馈'),
                      new Expanded(child: new Container()),
                      new Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
              Gaps.vGap10,
              new InkWell(
                onTap: () {},
                child: new Container(
                  padding: EdgeInsets.only(left: 40, right: 20),
                  width: double.infinity,
                  height: 48,
                  color: Colors.white,
                  child: new Row(
                    children: <Widget>[
                      Text('关于作者'),
                      new Expanded(child: new Container()),
                      new Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
              new InkWell(
                onTap: () {},
                child: new Container(
                  padding: EdgeInsets.only(left: 40, right: 20),
                  width: double.infinity,
                  height: 48,
                  color: Colors.white,
                  child: new Row(
                    children: <Widget>[
                      Text('系统设置'),
                      new Expanded(child: new Container()),
                      new Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
