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
      height: 36.0,
      padding: EdgeInsets.only(left: 15),
      alignment: Alignment.center,
      decoration: new BoxDecoration(color: Colors.grey[200]),
      child: new Row(
        children: <Widget>[
          new Icon(
            leftIcon ?? Icons.whatshot,
            color: Colors.red[400],
            size: 16,
          ),
          Gaps.hGap5,
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: titleColor ?? Colors.green,
                fontSize: 13.5,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
