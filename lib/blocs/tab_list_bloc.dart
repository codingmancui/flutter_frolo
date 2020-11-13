import 'dart:collection';

import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/data/repository/wan_repository.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:rxdart/subjects.dart';

class TabListBloc extends BlocBase {
  BehaviorSubject<List<ReposModel>> _tabList =
      BehaviorSubject<List<ReposModel>>();

  Sink<List<ReposModel>> get _tabListSink => _tabList.sink;

  Stream<List<ReposModel>> get tabListStream => _tabList.stream;

  List<ReposModel> tabList;
  int _tabListPage = 1;

  WanRepository wanRepository = new WanRepository();

  @override
  void dispose() {
    _tabList.close();
  }

  @override
  Future getData({String labelId, int cid, int page}) {
    return getRepos(labelId, cid, page);
  }

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
        .then((list) {
      if (tabList == null) tabList = new List();
      if (page == 1) {
        tabList.clear();
      }
      tabList.addAll(list);
      LogUtil.e(
          'TabListWidget is getRepos size:' +
              tabList.length.toString() +
              ' cid :' +
              cid.toString(),
          tag: 'TabListBloc');
      _tabListSink.add(UnmodifiableListView<ReposModel>(tabList));
      // _comListEventSink.add(new StatusEvent(labelId,
      //     ObjectUtil.isEmpty(list) ? RefreshStatus.noMore : RefreshStatus.idle,
      //     cid: cid));
    }).catchError((_) {
      _tabListPage--;
      // _comListEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
    });
  }
}
