import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/loading/pulse.dart';
import 'package:frolo/utils/navigator_util.dart';
import 'package:frolo/utils/ui_gaps.dart';
import 'package:frolo/utils/utils.dart';

import 'likebtn/like_button.dart';

class ReposItem extends StatelessWidget {
  const ReposItem(
    this.model, {
    this.labelId,
    Key key,
    this.isHome,
  }) : super(key: key);
  final String labelId;
  final ArticleModel model;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        NavigatorUtil.pushWeb(context,
            title: model.title, url: model.link, isHome: isHome);
      },
      child: new Container(
        height: 148.0,
        padding: EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 15),
        child: new Row(
          children: <Widget>[
            new Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(model.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF444444),
                    )),
                Gaps.vGap5,
                new Expanded(
                  flex: 1,
                  child: new Text(
                    model.desc,
                    maxLines: 3,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
                new Container(
                    child: new Row(
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.only(
                          left: 10, top: 1, right: 10, bottom: 1),
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.green, width: 1),
                          borderRadius: new BorderRadius.vertical(
                              top: Radius.elliptical(3, 3),
                              bottom: Radius.elliptical(3, 3))),
                      child: new Text('项目',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              letterSpacing: 0,
                              fontSize: 9,
                              color: Colors.green)),
                    ),
                    Text(
                      model.author,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    new Container(
                      margin: EdgeInsets.only(left: 10),
                      child: new Text(
                          Utils.getTimeLine(context, model.publishTime),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic)),
                    ),
                    new Expanded(flex: 1, child: SizedBox()),
                    new Container(
                      margin: EdgeInsets.only(right: 5),
                      child: new LikeButton(
                        width: 30.0,
                        duration: Duration(milliseconds: 500),
                      ),
                    ),
                  ],
                ))
              ],
            )),
            new Container(
                margin: EdgeInsets.only(left: 18),
                width: 72,
                alignment: Alignment.center,
                child: new ClipRRect(
                  borderRadius: BorderRadius.all(Radius.elliptical(6, 6)),
                  child: new CachedNetworkImage(
                    width: 72,
                    height: 128,
                    fit: BoxFit.fill,
                    imageUrl: model.envelopePic,
                    placeholder: (BuildContext context, String url) {
                      return new SpinKitPulse(color: Colors.lightGreen);
                    },
                    errorWidget:
                        (BuildContext context, String url, Object error) {
                      return new Icon(Icons.error);
                    },
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
