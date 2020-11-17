import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frolo/blocs/search_bloc.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/search_hot_tag.dart';
import 'package:frolo/utils/ui_gaps.dart';

typedef Search = void Function(String key);
typedef Clear = void Function();

class SearchTagBodyWidget extends StatelessWidget {
  final Search _search;
  final SearchBloc _searchBloc;
  final Clear _clear;

  const SearchTagBodyWidget(this._search, this._clear, this._searchBloc);

  @override
  Widget build(BuildContext context) => buildTagsBody();

  Widget buildTagsBody() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          margin: EdgeInsets.only(top: 10),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Text(
                '热门搜索',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              Gaps.vGap10,
              new StreamBuilder(
                  stream: _searchBloc.searchStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<SearchTagModel>> snapshot) {
                    if (snapshot.hasData) {
                      return new SearchHotTagWidget(snapshot.data, (key) {
                        _search(key);
                      });
                    } else {
                      return new Container(
                        width: 0,
                        height: 0,
                      );
                    }
                  }),
              Gaps.vGap20,
              new Container(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          '历史搜索',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        new Expanded(flex: 1, child: new Container()),
                        new InkWell(
                          onTap: () {
                            _clear();
                          },
                          child: new Text(
                            '清空',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
