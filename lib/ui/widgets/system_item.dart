import 'package:flutter/material.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/page/system_detail_page.dart';
import 'package:frolo/utils/navigator_util.dart';
import 'package:frolo/utils/ui_gaps.dart';

class SystemItem extends StatelessWidget {
  final SystemModel model;

  const SystemItem(this.model);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(top: 25, bottom: 10, left: 20, right: 20),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            model.name,
            style: TextStyle(color: Color(0xFF444444), fontSize: 16),
          ),
          Gaps.vGap10,
          new Wrap(
            spacing: 20,
            runSpacing: 15,
            children: buildTags(context),
          )
        ],
      ),
    );
  }

  List<Widget> buildTags(BuildContext context) {
    return model.children.map((e) {
      return new InkWell(
        onTap: () {
          NavigatorUtil.pushPage(context, new SystemDetailPage(model));
        },
        borderRadius: new BorderRadius.circular(12.0),
        child: new Container(
          padding: EdgeInsets.only(left: 12, top: 4, right: 12, bottom: 4),
          decoration: BoxDecoration(
              color: Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(12)),
          child: Text(
            e.name,
            style: const TextStyle(color: Color(0xFF444444), fontSize: 14),
          ),
        ),
      );
    }).toList();
  }
}
