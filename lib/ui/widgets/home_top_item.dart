import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/utils/navigator_util.dart';
import 'package:frolo/utils/object_util.dart';
import 'package:frolo/utils/ui_gaps.dart';

class HomeTopItem extends StatelessWidget {
  final int position;
  final ReposModel model;

  const HomeTopItem(this.position, this.model);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        NavigatorUtil.pushWeb(context,
            title: model.title, url: model.link, isHome: true);
      },
      child: new Container(
        decoration: new BoxDecoration(
            border: new Border(
                bottom: new BorderSide(color: Colors.grey[300], width: 0.35))),
        padding: EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 15),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Text(
                  position == 2 ? '新' : position == 3 ? '新' : '',
                  style: new TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                Gaps.getHGap(position == 2 || position == 3 ? 5 : 0),
                new Text(
                  ObjectUtil.isEmptyString(model.author)
                      ? model.shareUser
                      : model.author,
                  style: new TextStyle(color: Color(0xFF666666), fontSize: 12),
                ),
                buildTag(0),
                model.tags.isNotEmpty && model.tags.length > 1
                    ? buildTag(1)
                    : new Container(
                        width: 0,
                        height: 0,
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
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Gaps.getVGap(ObjectUtil.isEmptyString(model.desc) ? 0 : 5),
                new Text(
                  model.desc,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(color: Color(0xFF666666), fontSize: 14),
                ),
              ],
            ),
            Gaps.vGap10,
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                buildTopTagContainer(),
                Gaps.getHGap(model.isHotTag ? 0 : 10),
                new Text('${model.superChapterName} - ${model.chapterName}',
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      color: Colors.grey[500],
                      fontSize: 10,
                    )),
                new Expanded(flex: 1, child: new Container()),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                      size: 16,
                    ),
                    Gaps.hGap5,
                    new Text(
                      model.zan.toString(),
                      style: new TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                Gaps.hGap10
              ],
            )
          ],
        ),
      ),
    );
  }

  Container buildTopTagContainer() {
    if (model.isHotTag) {
      return new Container(
        width: 0,
        height: 0,
      );
    }
    return new Container(
      padding: EdgeInsets.only(left: 6, top: 1, right: 6, bottom: 1),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.red, width: 1),
          borderRadius: new BorderRadius.circular(2)),
      child: new Text(
        '置顶',
        textAlign: TextAlign.center,
        style: new TextStyle(
            color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Container buildTag(int index) {
    return model.tags.isNotEmpty
        ? new Container(
            margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.only(left: 6, top: 1, right: 6, bottom: 1),
            decoration: new BoxDecoration(
                border: new Border.all(color: Colors.green, width: 1),
                borderRadius: new BorderRadius.circular(2)),
            child: new Text(
              model.tags[index].name,
              textAlign: TextAlign.center,
              style: new TextStyle(
                  color: Colors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          )
        : new Container(
            height: 0,
            width: 0,
          );
  }
}
