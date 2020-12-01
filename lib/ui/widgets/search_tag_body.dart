import 'package:flutter/material.dart';
import 'package:frolo/blocs/search_bloc.dart';
import 'package:frolo/ui/widgets/search_hot_tag.dart';
import 'package:frolo/utils/ui_gaps.dart';

import 'loading/square_circle.dart';

typedef Search = void Function(String key);
typedef Clear = void Function();

class SearchTagBodyWidget extends StatefulWidget {
  final Search _search;
  final SearchBloc _searchBloc;
  final Clear _clear;

  SearchTagBodyWidget(this._search, this._clear, this._searchBloc);

  @override
  State<StatefulWidget> createState() => new _SearchTagBodyWidgetState();
}

class _SearchTagBodyWidgetState extends State<SearchTagBodyWidget> {
  ValueNotifier<bool> _loading = new ValueNotifier(true);

  @override
  Widget build(BuildContext context) => buildTagsBody();

  Widget buildTagsBody() {
    return new Stack(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          margin: EdgeInsets.only(top: 10, bottom: 10),
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new StreamBuilder(
                  stream: widget._searchBloc.netTagsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.hasData) {
                      _loading.value = false;
                      return new Column(
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
                          new SearchHotTagWidget(snapshot.data, (key) {
                            widget._search(key);
                          })
                        ],
                      );
                    }
                    return new Container(
                      width: 0,
                      height: 0,
                    );
                  }),
              Gaps.vGap20,
              new StreamBuilder(
                  stream: widget._searchBloc.localTagsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<dynamic>> snapshot) {
                    return snapshot.hasData && snapshot.data.isNotEmpty
                        ? new Container(
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
                                    new Expanded(
                                        flex: 1, child: new Container()),
                                    new InkWell(
                                      onTap: () {
                                        widget._clear();
                                      },
                                      child: new Text(
                                        '清空',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                Gaps.vGap20,
                                new SearchHotTagWidget(snapshot.data, (key) {
                                  widget._search(key);
                                }),
                              ],
                            ),
                          )
                        : new Container(
                            width: 0,
                            height: 0,
                          );
                  }),
            ],
          ),
        ),
        new ValueListenableBuilder<bool>(
            valueListenable: _loading,
            builder: (context, value, _) {
              return new Offstage(
                offstage: !value,
                child: new Align(
                  alignment: Alignment.center,
                  child: new SpinKitSquareCircle(
                      size: 35,
                      color: Colors.lime,
                      duration: Duration(milliseconds: 500)),
                ),
              );
            })
      ],
    );
  }
}
