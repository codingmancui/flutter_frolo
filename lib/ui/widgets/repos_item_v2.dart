import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frolo/ui/widgets/pulse.dart';
import 'package:frolo/utils/ui_gaps.dart';

class ReposItemV2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 162,
      child: new Row(
        children: <Widget>[
          new Container(
              margin: EdgeInsets.only(left: 5),
              alignment: Alignment.center,
              child: new ClipRRect(
                borderRadius: BorderRadius.all(Radius.elliptical(8, 8)),
                child: new CachedNetworkImage(
                  width: 84,
                  height: 128,
                  fit: BoxFit.fill,
                  imageUrl:
                      'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1605266694852&di=e2818bf84c1de052341c593756e56740&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F1%2F57b2d0a2dce6a.jpg',
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
              )),
          new Expanded(
            flex: 1,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(top: 25, left: 10),
                  child: Text('显式调用父类构造函数，应该在初始化列表中完成',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF313131),
                        fontWeight: FontWeight.bold,
                      )),
                ),
                new Container(
                  margin: EdgeInsets.only(top: 8, left: 10),
                  child:
                      Text('显式调用父类构造函数，应该在初始化列表中完成（记得好像在C++中见到过初始化列表？太久了忘记了）',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF999999),
                            fontWeight: FontWeight.bold,
                          )),
                ),
                new Container(
                  margin: EdgeInsets.only(left: 10, top: 15),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.only(
                            left: 6, top: 3, right: 6, bottom: 3),
                        decoration: new BoxDecoration(
                            border: new Border.all(
                                color: Colors.lightGreen, width: 0.6),
                            borderRadius: new BorderRadius.circular(3)),
                        child: new Text('完整项目',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                letterSpacing: 0,
                                fontSize: 9,
                                color: Colors.green)),
                      ),
                      new Container(
                        margin: EdgeInsets.only(left: 5),
                        padding: EdgeInsets.only(
                            left: 6, top: 3, right: 6, bottom: 3),
                        decoration: new BoxDecoration(
                            border: new Border.all(
                                color: Color(0xFF999999), width: 0.5),
                            borderRadius: new BorderRadius.circular(3)),
                        child: new Text('作者',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                letterSpacing: 0,
                                fontSize: 9,
                                color: Color(0xFF999999))),
                      ),
                      new Expanded(flex: 1, child: new Container()),
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.thumb_up_rounded,
                            size: 14,
                            color: Colors.lightGreen,
                          ),
                          Gaps.hGap5,
                          new Text('10',
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  fontSize: 12, color: Color(0xFF999999))),
                          Gaps.hGap10,
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
