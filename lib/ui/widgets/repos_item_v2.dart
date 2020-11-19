import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/loading/pulse.dart';
import 'package:frolo/utils/ui_gaps.dart';

class ReposItemV2 extends StatelessWidget {
  const ReposItemV2(this.model, {Key key}) : super(key: key);
  final ArticleModel model;

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 152,
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
                  imageUrl: model.envelopePic,
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
                  margin: EdgeInsets.only(top: 20, left: 10),
                  child: Text(model.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF313131),
                        fontWeight: FontWeight.bold,
                      )),
                ),
                new Expanded(
                  child: new Container(
                    margin: EdgeInsets.only(top: 8, left: 10),
                    child: Text(model.desc,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF999999),
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(left: 10, top: 15, bottom: 20),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        alignment: Alignment.center,
                        height: 18,
                        padding: EdgeInsets.only(left: 6, right: 6),
                        decoration: new BoxDecoration(
                            border: new Border.all(
                                color: Colors.lightGreen, width: 0.6),
                            borderRadius: new BorderRadius.circular(3)),
                        child: new Text(model.chapterName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                letterSpacing: 0,
                                fontSize: 9,
                                color: Colors.green)),
                      ),
                      new Container(
                        alignment: Alignment.center,
                        height: 18,
                        margin: EdgeInsets.only(left: 5),
                        padding: EdgeInsets.only(left: 6, right: 6),
                        decoration: new BoxDecoration(
                            border: new Border.all(
                                color: Color(0xFF999999), width: 0.5),
                            borderRadius: new BorderRadius.circular(3)),
                        child: new Text(model.author,
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
                          new Text(Random().nextInt(100).toString(),
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
