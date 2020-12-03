import 'dart:collection';

import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/data/repository/wan_repository.dart';
import 'package:frolo/event/event.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:rxdart/rxdart.dart';

class MainBloc implements BlocBase {
  WanRepository wanRepository = new WanRepository();

  BehaviorSubject<StatusEvent> _homeEvent = BehaviorSubject<StatusEvent>();

  Sink<StatusEvent> get homeEventSink => _homeEvent.sink;

  Stream<StatusEvent> get homeEventStream =>
      _homeEvent.stream.asBroadcastStream();

  BehaviorSubject<List<Article>> _recRepos =
      BehaviorSubject<List<Article>>();

  Sink<List<Article>> get _recReposSink => _recRepos.sink;

  Stream<List<Article>> get recReposStream => _recRepos.stream;

  BehaviorSubject<List<Article>> _recWxArticle =
      BehaviorSubject<List<Article>>();

  Sink<List<Article>> get _recWxArticleSink => _recWxArticle.sink;

  Stream<List<Article>> get recWxArticleStream => _recWxArticle.stream;

  BehaviorSubject<List<dynamic>> _allData = BehaviorSubject<List<dynamic>>();

  Sink<List<dynamic>> get allSink => _allData.sink;

  Stream<List<dynamic>> get allStream => _allData.stream;

  int _page = 0;

  var _dataWrapper = new List();

  @override
  Future getData({int page}) {
    return null;
  }

  @override
  Future onLoadMore({String labelId}) {
    int page = ++_page;
    return _loadMoreData(page);
  }

  @override
  Future onRefresh({bool isReload}) {
    return getAllData();
  }

  Future _loadMoreData(int page) {
    return wanRepository.getArticleList().then((list) {
      List<Article> v = list;
      v.forEach((item) {
        item.isHotTag = true;
      });
      _dataWrapper.addAll(v);
      allSink.add(_dataWrapper);
      homeEventSink.add(new StatusEvent(status: 1));
    }).catchError((_) {
      _page--;
      homeEventSink.add(new StatusEvent(status: -1));
    });
  }

  Future _getBanner() {
    return wanRepository.getBanner();
  }

  /// 首页列表获取
  Future getAllData() async {
    Future.wait([_getBanner(), _getTop(), _getArticle()]).then((data) {
      _dataWrapper.clear();
      for (int i = 0; i < data.length; i++) {
        if (i == 0) {
          _dataWrapper.add(data.first);
        } else if (i == 1) {
          _dataWrapper.add(Article.itemType(1));
          _dataWrapper.addAll(data[i]);
        } else if (i == data.length - 1) {
          _dataWrapper.add(Article.itemType(2));
          List<Article> v = data[i] as List<Article>;
          v.forEach((value) {
            value.isHotTag = true;
          });
          _dataWrapper.addAll(v);
        }
      }
      allSink.add(_dataWrapper);
      homeEventSink.add(new StatusEvent(status: 0));
      LogUtil.e(_dataWrapper.length, tag: 'MainBloc');
    }).catchError((e) {
      LogUtil.e(e, tag: 'MainBloc');
      homeEventSink.add(new StatusEvent(status: -1));
    });
  }

  Future<List<Article>> _getTop() async {
    return wanRepository.getTopList();
  }

  Future<List<Article>> _getArticle() async {
    return wanRepository.getArticleList();
  }

  Future<List<Article>> getRecWxArticleV2() async {
    int _id = 408;
    return wanRepository.getWxArticleList(id: _id);
  }

  Future getRecRepos(String labelId) async {
    ComReq _comReq = new ComReq(402);
    wanRepository.getRecReposList(data: _comReq.toJson()).then((list) {
      if (list.length > 10) {
        list = list.sublist(0, 10);
      }
      _recReposSink.add(UnmodifiableListView<Article>(list));
    });
  }

  Future getRecWxArticle(String labelId) async {
    int _id = 408;
    wanRepository.getWxArticleList(id: _id).then((list) {
      if (list.length > 10) {
        list = list.sublist(0, 10);
      }
      _recWxArticleSink.add(UnmodifiableListView<Article>(list));
    });
  }

  @override
  void dispose() {
    _recRepos.close();
    _recWxArticle.close();
    _homeEvent.close();
    _allData.close();
  }
}
