import 'dart:collection';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/data/repository/wan_repository.dart';
import 'package:frolo/event/event.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc_provider.dart';

class SystemDetailBloc implements BlocBase {
  WanRepository wanRepository = new WanRepository();

  BehaviorSubject<List<ArticleModel>> _systemDetail =
      BehaviorSubject<List<ArticleModel>>();

  Sink<List<ArticleModel>> get _systemDetailSink => _systemDetail.sink;

  Stream<List<ArticleModel>> get systemDetailStream => _systemDetail.stream;

  BehaviorSubject<StatusEvent> _systemEvent = BehaviorSubject();

  Sink<StatusEvent> get _systemEventSink => _systemEvent.sink;

  Stream<StatusEvent> get systemEventStream =>
      _systemEvent.stream.asBroadcastStream();

  int _page = 0;
  bool _isRefresh = false;
  List<ArticleModel> datas = new List();

  @override
  Future getData({int page, int cid}) {
    return getArticleList(page, cid);
  }

  @override
  Future onLoadMore({int cid}) {
    _isRefresh = false;
    ++_page;
    return getArticleList(_page, cid);
  }

  @override
  Future onRefresh({int cid}) {
    _page = 0;
    _isRefresh = true;
    return getArticleList(_page, cid);
  }

  Future getArticleList(int page, int cid) {
    return wanRepository
        .getSystemDetailList(page: page, data: {'cid': cid}).then((data) {
      if (_page == 0) {
        datas.clear();
        _systemEventSink.add(
            new StatusEvent(noMore: data.curPage == data.pageCount, status: 0));
      }
      if (_page != 0) {
        data.curPage == data.pageCount
            ? _systemEventSink.add(new StatusEvent(status: 2))
            : _systemEventSink.add(new StatusEvent(status: 1));
      }
      datas.addAll(data.list);
      _systemDetailSink.add(datas);
      LogUtil.v('get system detail list ${data.curPage}  ${data.pageCount}',
          tag: 'SystemDetailBloc');
    }).catchError(() {
      _page--;
      _systemEventSink.add(new StatusEvent(status: -1));
      LogUtil.v('get system detail list list on error',
          tag: 'SystemDetailBloc');
    });
  }

  @override
  void dispose() {
    _systemDetail.close();
    _systemEvent.close();
  }
}
