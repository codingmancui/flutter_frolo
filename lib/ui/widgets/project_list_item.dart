import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/collect_widget.dart';
import 'package:frolo/utils/navigator_util.dart';
import 'package:frolo/utils/object_util.dart';
import 'package:frolo/utils/ui_gaps.dart';

import 'loading/pulse.dart';

class ProjectListItem extends StatelessWidget {
  final int position;
  final ArticleModel model;

  const ProjectListItem(this.position, this.model);

  @override
  Widget build(BuildContext context) {
    bool isNew = DateTime.now().millisecondsSinceEpoch - model.publishTime <
        24 * 60 * 60 * 1000;
    return new InkWell(
      onTap: () {
        NavigatorUtil.pushWeb(context,
            title: model.title, url: model.link, isHome: true);
      },
      child: new Container(
        decoration: new BoxDecoration(
            border: new Border(
                bottom: new BorderSide(color: Colors.grey[300], width: 0.35))),
        padding: EdgeInsets.only(left: 20, top: 12, right: 20, bottom: 12),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Text(
                  isNew ? '新' : '',
                  style: new TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                Gaps.getHGap(isNew ? 5 : 0),
                new Container(
                  padding:
                      EdgeInsets.only(left: 5, top: 2, right: 5, bottom: 2),
                  decoration: BoxDecoration(
                      color: Color(0xFFecf6ff),
                      borderRadius: BorderRadius.circular(4)),
                  child: new Text(
                    ObjectUtil.isEmptyString(model.author)
                        ? model.shareUser
                        : model.author,
                    style:
                        new TextStyle(color: Color(0xB32d97fe), fontSize: 13),
                  ),
                ),
                new Expanded(flex: 1, child: Container()),
                new Text(
                  model.niceDate,
                  style: new TextStyle(color: Color(0xFF666666), fontSize: 12),
                ),
              ],
            ),
            new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Gaps.vGap10,
                new Text(
                  model.title,
                  maxLines: ObjectUtil.isEmptyString(model.desc) ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                      color: Color(0xFF444444),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Gaps.getVGap(ObjectUtil.isEmptyString(model.desc) ? 0 : 10),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      child: new CachedNetworkImage(
                        width: 48,
                        height: 72,
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
                    ),
                    Gaps.getHGap(20.0),
                    new Expanded(
                        child: new Text(
                      model.desc,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style:
                          new TextStyle(color: Color(0xFF666666), fontSize: 14),
                    )),
                  ],
                ),
              ],
            ),
            Gaps.vGap15,
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Text('${model.superChapterName} - ${model.chapterName}',
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      color: Colors.grey[500],
                      fontSize: 10,
                    )),
                new Expanded(flex: 1, child: new Container()),
                new CollectWidget(model),
                Gaps.hGap10
              ],
            )
          ],
        ),
      ),
    );
  }
}
