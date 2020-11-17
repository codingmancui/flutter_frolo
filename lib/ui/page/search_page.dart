import 'package:flutter/material.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/search_bloc.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/back_button.dart';
import 'package:frolo/ui/widgets/search_hot_tag.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:frolo/utils/ui_gaps.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new BlocProvider(
        child: new _SearchPageWidget(), bloc: new SearchBloc());
  }
}

class _SearchPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SearchStateWidget();
  }
}

class _SearchStateWidget extends State<_SearchPageWidget> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<bool> _showClose = ValueNotifier<bool>(false);
  SearchBloc _searchBloc;

  @override
  void initState() {
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    _searchBloc.getData();
    _searchController.addListener(() {
      LogUtil.v('searchController text $_searchController', tag: 'SearchPage');

      var length = _searchController.text.length;
      if (length > 0) {
        _showClose.value = true;
      } else {
        _showClose.value = false;
      }
      LogUtil.v('searchController text $length', tag: 'SearchPage');
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void _doSearch() {}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        brightness: Brightness.dark,
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          new Container(
            margin: EdgeInsets.only(right: 10),
            child: new IconButton(
                icon: new Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  _doSearch();
                  LogUtil.v('on home search click', tag: 'SearchPage');
                }),
          )
        ],
        leading: BackButtonV2(color: Colors.white),
        title: buildSearchContainer(),
      ),
      body: new Column(
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
                        return new SearchHotTagWidget(snapshot.data);
                      } else {
                        return new Container(
                          width: 0,
                          height: 0,
                        );
                      }
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildSearchContainer() {
    return new Container(
      padding: EdgeInsets.only(left: 10),
      width: 260,
      decoration: new BoxDecoration(
          color: Color(0x22000000), borderRadius: BorderRadius.circular(20)),
      height: 32,
      child: new Row(children: <Widget>[
        new Expanded(
            child: TextField(
          maxLines: 1,
          // autofocus: true,
          controller: _searchController,
          decoration: new InputDecoration(
              hintText: '用空格隔开多个关键字',
              hintMaxLines: 1,
              // contentPadding: EdgeInsets.all(10),
              hintStyle: TextStyle(color: Color(0xBBFFFFFF), fontSize: 15),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero),
          style: new TextStyle(
              fontWeight: FontWeight.normal, color: Colors.white, fontSize: 15),
        )),
        ValueListenableBuilder<bool>(
            valueListenable: _showClose,
            builder: (context, value, _) {
              return value
                  ? new IconButton(
                      icon: new Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                      onPressed: () {
                        _searchController.clear();
                      })
                  : new Container(
                      width: 15,
                      height: 0,
                    );
            }),
      ]),
    );
  }
}
