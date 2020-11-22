import 'package:flutter/material.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/utils/ui_gaps.dart';

class NaviItem extends StatelessWidget {
  final NaviModel model;

  const NaviItem(this.model);

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
            children: buildTags(),
          )
        ],
      ),
    );
  }

  List<Widget> buildTags() {
    return model.articles.map((e) {
      return new InkWell(
        onTap: () {},
        borderRadius: new BorderRadius.circular(12.0),
        child: new Container(
          padding: EdgeInsets.only(left: 12, top: 4, right: 12, bottom: 4),
          decoration: BoxDecoration(
              color: Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(12)),
          child: Text(
            e.title,
            style: const TextStyle(color: Color(0xFF444444), fontSize: 14),
          ),
        ),
      );
    }).toList();
  }
}
