import 'package:flutter/material.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/utils/navigator_util.dart';
import 'package:frolo/utils/ui_gaps.dart';
import 'package:frolo/utils/utils.dart';

import 'likebtn/like_button.dart';

class ArticleItem extends StatelessWidget {
  const ArticleItem(
    this.model, {
    Key key,
    this.labelId,
    this.isHome,
  }) : super(key: key);
  final ReposModel model;
  final String labelId;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        NavigatorUtil.pushWeb(context,
            title: model.title, url: model.link, isHome: isHome);
      },
      child: new Container(
        height: 98,
        padding: EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 15),
        child: Row(
          children: <Widget>[
            new Expanded(
                child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(model.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF444444),
                      fontWeight: FontWeight.bold,
                    )),
                new Expanded(
                  flex: 1,
                  child: new Container(),
                ),
                new Row(
                  children: <Widget>[
                    new LikeButton(
                      width: 30.0,
                      duration: Duration(milliseconds: 500),
                    ),
                    Text(
                      model.author,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    new Expanded(flex: 1, child: SizedBox()),
                    new Container(
                      margin: EdgeInsets.only(right: 5),
                      child: new Text(
                          Utils.getTimeLine(context, model.publishTime),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic)),
                    ),
                  ],
                ),
              ],
            )),
            new Container(
              margin: EdgeInsets.only(left: 12.0),
              child: new CircleAvatar(
                radius: 42.0,
                backgroundColor: Colors.green,
                child: new Padding(
                  padding: EdgeInsets.all(5.0),
                  child: new Text(
                    model.superChapterName ?? "文章",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 11.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
