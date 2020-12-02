import 'dart:collection';

import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/data/repository/wan_repository.dart';
import 'package:frolo/event/event.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:frolo/utils/object_util.dart';
import 'package:rxdart/subjects.dart';
import 'package:sp_util/sp_util.dart';

typedef FetchSuccess = void Function(bool success);

class SearchBloc implements BlocBase {
  static const String LOCAL_HOT_TAG = 'local_hot_tag';
  WanRepository _wanRepository = new WanRepository();

  BehaviorSubject<StatusEvent> _event = BehaviorSubject();

  Sink<StatusEvent> get eventSink => _event.sink;

  Stream<StatusEvent> get eventStream => _event.stream.asBroadcastStream();

  BehaviorSubject<List<SearchTagModel>> _netTagsSubject = BehaviorSubject();

  Sink<List<SearchTagModel>> get netTagsSink => _netTagsSubject.sink;

  Stream<List<SearchTagModel>> get netTagsStream => _netTagsSubject.stream;

  BehaviorSubject<List<String>> _localTagsSubject = BehaviorSubject();

  Sink<List<String>> get localTagsSink => _localTagsSubject.sink;

  Stream<List<String>> get localTagsStream => _localTagsSubject.stream;

  BehaviorSubject<List<ArticleModel>> _searchSubject = BehaviorSubject();

  Sink<List<ArticleModel>> get searchSink => _searchSubject.sink;

  Stream<List<ArticleModel>> get searchStream => _searchSubject.stream;

  List<String> _localTags;
  int _page = 0;
  String _key = '';
  List<ArticleModel> _listData = new List();
  FetchSuccess _callback;

  void setCallback(FetchSuccess callback) {
    this._callback = callback;
  }

  void _getTagDatas() {
    Future.wait([_wanRepository.getSearchHotTag(), getLocalHotTag()])
        .then((datas) {
      netTagsSink.add(UnmodifiableListView<SearchTagModel>(
          datas.first as List<SearchTagModel>));
      localTagsSink
          .add(UnmodifiableListView<String>(datas.last as List<String>));
      _callback(true);
    }).catchError((e) {
      LogUtil.v('getHotTag list on error', tag: 'SearchBloc');
    });
  }

  Future<List<String>> getLocalHotTag() async {
    _localTags = SpUtil.getStringList(LOCAL_HOT_TAG);
    return _localTags;
  }

  void saveLocalTag(String key) async {
    if (ObjectUtil.isEmptyList(_localTags)) {
      _localTags = new List<String>();
    }
    if (_localTags.contains(key)) {
      _localTags.remove(key);
    }
    _localTags.insert(0, key);
    SpUtil.putStringList(LOCAL_HOT_TAG, _localTags).then((value) {
      if (value) {
        localTagsSink.add(UnmodifiableListView<String>(_localTags));
      }
    });
  }

  void clearLocalTags() {
    _localTags.clear();
    SpUtil.putStringList(LOCAL_HOT_TAG, _localTags);
    localTagsSink.add(UnmodifiableListView<String>(_localTags));
  }

  ///清空上一次记录
  void clearSearchResult() {
    searchSink.add(null);
  }

  _loadMoreData(int page, String key) {
    getSearchList(key, page);
  }

  Future getSearchList(String key, int page) {
    this._key = key;
    this.saveLocalTag(key);
    return _wanRepository
        .getSearchList(page: page, data: {'k': key}).then((data) {
      if (page == 0) {
        _listData.clear();
      }
      _listData.addAll(data.list);
      searchSink.add(_listData);

      if (page == 0) {
        eventSink.add(
            new StatusEvent(noMore: data.curPage == data.pageCount, status: 0));
      } else {
        data.curPage == data.pageCount
            ? eventSink.add(new StatusEvent(status: 2))
            : eventSink.add(new StatusEvent(status: 1));
      }
      LogUtil.v(
          'getSearch list on success page  ${data.curPage}   ${data.pageCount}',
          tag: 'SearchBloc');
    }).catchError((e) {
      _page--;
      eventSink.add(new StatusEvent(status: -1));
      LogUtil.v('getSearch list on error', tag: 'SearchBloc');
    });
  }

  @override
  void dispose() {
    _netTagsSubject.close();
    _localTagsSubject.close();
    _searchSubject.close();
    _event.close();
    _callback = null;
  }

  @override
  Future getData({String labelId, int page}) async {
    return _getTagDatas();
  }

  @override
  Future onLoadMore({String labelId}) {
    int page = ++_page;
    return _loadMoreData(page, _key);
  }

  @override
  Future onRefresh({String labelId}) {
    _listData.clear();
    _page = 0;
    return getSearchList(_key, _page);
  }
}
