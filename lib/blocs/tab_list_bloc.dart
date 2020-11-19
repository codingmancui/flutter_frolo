import 'dart:collection';

import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/data/repository/wan_repository.dart';
import 'package:frolo/event/event.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:rxdart/subjects.dart';

class TabListBloc extends BlocBase {
  BehaviorSubject<StatusEvent> _event = BehaviorSubject<StatusEvent>();

  Sink<StatusEvent> get eventSink => _event.sink;

  Stream<StatusEvent> get eventStream => _event.stream.asBroadcastStream();

  BehaviorSubject<List<ArticleModel>> _tabList =
      BehaviorSubject<List<ArticleModel>>();

  Sink<List<ArticleModel>> get _tabListSink => _tabList.sink;

  Stream<List<ArticleModel>> get tabListStream => _tabList.stream;

  List<ArticleModel> tabList;
  int _tabListPage = 1;

  WanRepository wanRepository = new WanRepository();

  @override
  void dispose() {
    _tabList.close();
    _event.close();
  }

  @override
  Future getData({String labelId, int cid, int page}) =>
      getRepos(labelId, cid, page);

  @override
  Future onLoadMore({String labelId, int cid}) {
    int _page = 0;
    _page = ++_tabListPage;
    return getData(labelId: labelId, cid: cid, page: _page);
  }

  @override
  Future onRefresh({String labelId, int cid}) {
    _tabListPage = 1;
    return getData(labelId: labelId, cid: cid, page: _tabListPage);
  }

  Future getRepos(String labelId, int cid, int page) async {
    ComReq _comReq = new ComReq(cid);
    return wanRepository
        .getProjectList(page: page, data: _comReq.toJson())
        .then((data) {
      if (tabList == null) tabList = new List();
      if (page == 1) {
        tabList.clear();
      }
      tabList.addAll(data.list);
      LogUtil.e(
          'TabListWidget is getRepos curPage: ${data.curPage}   pageCount: ${data.pageCount}',
          tag: 'TabListBloc');
      _tabListSink.add(UnmodifiableListView<ArticleModel>(tabList));
      if (page == 1) {
        eventSink.add(
            new StatusEvent(noMore: data.curPage == data.pageCount, status: 0));
      } else {
        data.curPage == data.pageCount
            ? eventSink.add(new StatusEvent(status: 2))
            : eventSink.add(new StatusEvent(status: 1));
      }
    }).catchError((_) {
      _tabListPage--;
      eventSink.add(new StatusEvent(status: -1));
    });
  }
}
