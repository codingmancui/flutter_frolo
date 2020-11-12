import 'package:flutter/material.dart';
import 'package:frolo/utils/screen_utils.dart';

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
  List<PageInfo> _pageInfo = new List();

  @override
  void initState() {
    _pageInfo
      ..add(PageInfo('收藏', Icons.collections))
      ..add(PageInfo('设置', Icons.settings))
      ..add(PageInfo('关于', Icons.info))
      ..add(PageInfo('分享', Icons.share));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Column(
        children: <Widget>[
          new Container(
            alignment: Alignment.center,
            height: 300.0,
            decoration: new BoxDecoration(color: Colors.green),
            padding:
                EdgeInsets.only(top: ScreenUtil.getInstance().statusBarHeight),
            child: buildUserInfoColumn(),
          ),
          new Container(
            height: 10.0,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.black12),
          ),
          new Expanded(
              child: new ListView.separated(
                padding: const EdgeInsets.all(0.0),
                itemCount: _pageInfo.length,
                separatorBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 25.0, left: 25.0),
                    height: 0.25,
                    color: Colors.black12,
                  );
                },
                itemBuilder: (context, index) {
                  PageInfo pageInfo = _pageInfo[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    leading: new Icon(pageInfo.iconData),
                    title: Text(pageInfo.titleId),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {},
                  );
                },
              ),
              flex: 1)
        ],
      ),
    );
  }

  Column buildUserInfoColumn() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
          alignment: Alignment.center,
          width: 78.0,
          height: 78.0,
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/ali_connors.png'),
            ),
          ),
        ),
        new Text('Xiaoyong Cui',
            style: TextStyle(fontSize: 18.0, color: Colors.white)),
        new SizedBox(height: 5.0),
        new Text('专心研究Flutter',
            style: TextStyle(fontSize: 14.0, color: Colors.white)),
        new SizedBox(height: 10.0)
      ],
    );
  }
}
