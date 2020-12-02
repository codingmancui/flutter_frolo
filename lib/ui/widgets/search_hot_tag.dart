import 'package:flutter/material.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/utils/object_util.dart';

typedef KeyWordFunc = void Function(String keyWord);

class SearchHotTagWidget extends StatelessWidget {
  final List<dynamic> _tagList;
  final KeyWordFunc keyWordCallback;

  const SearchHotTagWidget(this._tagList, this.keyWordCallback);

  @override
  Widget build(BuildContext context) {
    if (ObjectUtil.isEmptyList(_tagList)) {
      return new Container(
        width: 0,
        height: 0,
      );
    }
    return new Wrap(
      spacing: 20,
      runSpacing: 20,
      children: buildTags(),
    );
  }

  List<Widget> buildTags() {
    return _tagList.map((item) {
      var key = '';
      if (item is SearchTagModel) {
        key = item.name;
      } else {
        key = item;
      }
      return buildHotTagItem(key);
    }).toList();
  }

  Widget buildHotTagItem(String name) {
    return new InkWell(
      onTap: () {
        keyWordCallback(name);
      },
      child: new Container(
          height: 27,
          padding: EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 0),
          decoration: BoxDecoration(
              color: Colors.lime[600], borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                name,
                style: new TextStyle(
                  wordSpacing: 0,
                  letterSpacing: 0,
                  fontSize: 13,
                  color: Colors.white,
                ),
              )
            ],
          )),
    );
  }
}
