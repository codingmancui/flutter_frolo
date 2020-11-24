import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frolo/ui/page/login_page.dart';
import 'package:frolo/utils/navigator_util.dart';
import 'package:frolo/utils/ui_gaps.dart';
import 'package:frolo/utils/utils.dart';

class PageInfo {
  PageInfo(this.titleId, this.iconData);

  String titleId;
  IconData iconData;
  Widget page;
  bool withScaffold;
}

class MePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MePageState();
  }
}

class _MePageState extends State<MePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
        backgroundColor: Color(0xFFF6F6F6),
        body: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            Gaps.getVGap(60),
            new Row(children: <Widget>[
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
                  '玩王者的代码侠',
                  style: new TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ]),
            Gaps.vGap20,
            new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                    child: new Center(
                  child: new Column(
                    children: <Widget>[
                      Text(
                        '21',
                        style: new TextStyle(color: Color(0xFF1B1B1B)),
                      ),
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
                      Text('1', style: new TextStyle(color: Color(0xFF1B1B1B))),
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
                      Text('56337',
                          style: new TextStyle(
                              color: Color(0xFF1B1B1B), fontSize: 16)),
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
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
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
        ));
  }
}
