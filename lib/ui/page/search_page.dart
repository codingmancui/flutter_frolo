import 'package:flutter/material.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/search_bloc.dart';
import 'package:frolo/ui/widgets/back_button.dart';
import 'package:frolo/ui/widgets/search_result_widget.dart';
import 'package:frolo/ui/widgets/search_tag_body.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:frolo/utils/object_util.dart';
import 'package:toast/toast.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SearchStateWidget();
  }
}

class _SearchStateWidget extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<bool> _showClose = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _inSearchMode = ValueNotifier<bool>(false);
  SearchBloc _searchBloc;

  @override
  void initState() {
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    Future.delayed(new Duration(milliseconds: 50), () {
      _searchBloc.getData();
    });
    _searchController.addListener(() {
      var length = _searchController.text.trim().length;
      _showClose.value = length > 0;
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _inSearchMode.dispose();
  }

  void _doSearch({String key = '', bool fromTag = false}) {
    if (ObjectUtil.isEmptyString(key)) {
      Toast.show("关键字不能为空！", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      return;
    }
    if (fromTag) {
      _searchController.text = key;
    }
    _setSearchMode(true);

    Future.delayed(new Duration(milliseconds: 500), () {
      _searchBloc.getSearchList(key, 0);
      FocusScope.of(context).requestFocus(FocusNode());
    });
    LogUtil.v('do search $key', tag: 'SearchPage');
  }

  void _doClear() {
    _searchBloc.clearLocalTags();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: new Scaffold(
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
                      _doSearch(key: _searchController.text);
                      LogUtil.v('on home search click', tag: 'SearchPage');
                    }),
              )
            ],
            leading: BackButtonV2(color: Colors.white),
            title: buildSearchTitle(),
          ),
          body: new Stack(
            children: <Widget>[
              new SearchTagBodyWidget((key) {
                _doSearch(key: key, fromTag: true);
              }, () {
                _doClear();
              }, _searchBloc),
              ValueListenableBuilder<bool>(
                  valueListenable: _inSearchMode,
                  builder: (context, value, _) {
                    return value
                        ? new SearchResultWidget(_searchBloc)
                        : new Container(
                            width: 0,
                            height: 0,
                          );
                  }),
            ],
          ),
        ),
        onWillPop: () {
          if (_getSearchMode()) {
            _setSearchMode(false);
            return new Future.value(false);
          }
          return new Future.value(true);
        });
  }

  void _setSearchMode(bool v) {
    _inSearchMode.value = v;
    if (!v) {
      _searchBloc.getLocalHotTag();
      _searchBloc.clearSearchResult();
    }
  }

  bool _getSearchMode() => _inSearchMode.value;

  Widget buildSearchTitle() {
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
          textInputAction: TextInputAction.search,
          onEditingComplete: () {
            _doSearch(key: _searchController.text);
          },
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
                      width: 0,
                      height: 0,
                    );
            }),
      ]),
    );
  }
}
