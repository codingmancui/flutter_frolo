import 'package:flutter/material.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/utils/navigator_util.dart';
import 'package:frolo/utils/object_util.dart';
import 'package:frolo/utils/ui_gaps.dart';

class SystemDetailItem extends StatelessWidget {
  final Article model;

  final String modelName;

  const SystemDetailItem(this.model, this.modelName);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        NavigatorUtil.pushWeb(context, title: model.title, url: model.link);
      },
      child: new Container(
        padding: EdgeInsets.only(left: 20, top: 12, right: 20, bottom: 12),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                    child: new Text(
                  ObjectUtil.isEmptyString(model.author)
                      ? model.shareUser
                      : model.author,
                  style:
                      const TextStyle(color: Color(0xFF545454), fontSize: 14),
                )),
                new Text(
                  model.niceDate,
                  style:
                      const TextStyle(color: Color(0xFF949494), fontSize: 14),
                )
              ],
            ),
            Gaps.vGap5,
            new Text(
              model.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: new TextStyle(fontSize: 16, color: Color(0xFF323232)),
            ),
            Gaps.vGap10,
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Text(
                  '${model.superChapterName}ㆍ$modelName',
                  style:
                      const TextStyle(color: Color(0xFF949494), fontSize: 12),
                ),
                new Expanded(child: new Container()),
                new Icon(
                  Icons.grade_sharp,
                  size: 18,
                  color: Colors.lightGreen,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
