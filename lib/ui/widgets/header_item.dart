import 'package:flutter/material.dart';
import 'package:frolo/utils/ui_gaps.dart';

class HeaderItem extends StatelessWidget {
  const HeaderItem(
      {this.margin,
      this.titleColor,
      this.leftIcon,
      this.titleId: 'title_repos',
      this.title,
      this.extraId: 'more',
      this.extra,
      this.rightIcon,
      this.onTap,
      Key key})
      : super(key: key);

  final EdgeInsetsGeometry margin;
  final Color titleColor;
  final IconData leftIcon;
  final String titleId;
  final String title;
  final String extraId;
  final String extra;
  final IconData rightIcon;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 56.0,
      decoration: new BoxDecoration(
          color: Colors.lime[50],
          border: new Border(
              bottom: new BorderSide(width: 0.33, color: Colors.lime[50]))),
      child: new ListTile(
        title: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Icon(
              leftIcon ?? Icons.whatshot,
              color: Colors.green,
            ),
            Gaps.hGap10,
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.green, fontSize: 18),
            )
          ],
        ),
        trailing: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(
              '更多',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            new Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
              size: 18,
            )
          ],
        ),
      ),
    );
  }
}
