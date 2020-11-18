import 'package:flutter/material.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/search_bloc.dart';
import 'package:frolo/ui/widgets/back_button.dart';
import 'package:frolo/ui/widgets/search_tag_body.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:frolo/utils/object_util.dart';
import 'package:toast/toast.dart';

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
      if (length > 0) {
        _showClose.value = true;
      } else {
        _showClose.value = false;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _inSearchMode.dispose();
  }

  void _doSearch({String key = ''}) {
    if (ObjectUtil.isEmptyString(key)) {
      Toast.show("关键字不能为空！", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      return;
    }
    _searchBloc.saveLocalTag(key);
    FocusScope.of(context).requestFocus(FocusNode());
    _setSearchMode(true);
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
                _doSearch(key: key);
              }, () {
                _doClear();
              }, _searchBloc),
              ValueListenableBuilder<bool>(
                  valueListenable: _inSearchMode,
                  builder: (context, value, _) {
                    return value
                        ? new Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Color(0xFFFAFAFA),
                            child: new Text('search list'),
                          )
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
                      width: 15,
                      height: 0,
                    );
            }),
      ]),
    );
  }
}
