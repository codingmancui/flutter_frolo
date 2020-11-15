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

  BehaviorSubject<List<BannerModel>> _banner =
      BehaviorSubject<List<BannerModel>>();

  Stream<List<BannerModel>> get bannerStream => _banner.stream;

  Sink<List<BannerModel>> get _bannerSink => _banner.sink;

  BehaviorSubject<List<ReposModel>> _recRepos =
      BehaviorSubject<List<ReposModel>>();

  Sink<List<ReposModel>> get _recReposSink => _recRepos.sink;

  Stream<List<ReposModel>> get recReposStream => _recRepos.stream;

  BehaviorSubject<List<ReposModel>> _recWxArticle =
      BehaviorSubject<List<ReposModel>>();

  Sink<List<ReposModel>> get _recWxArticleSink => _recWxArticle.sink;

  Stream<List<ReposModel>> get recWxArticleStream => _recWxArticle.stream;

  BehaviorSubject<List<dynamic>> _allData = BehaviorSubject<List<dynamic>>();

  Sink<List<dynamic>> get allSink => _allData.sink;

  Stream<List<dynamic>> get allStream => _allData.stream;

  int _page = 0;

  @override
  Future getData({String labelId, int page}) {
    return getHomeData(labelId);
  }

  Future getHomeData(String labelId) {
    getRecWxArticle(labelId);
    getRecRepos(labelId);
    return getBanner(labelId);
  }

  @override
  Future onLoadMore({String labelId}) {
    return getData(labelId: labelId, page: _page);
  }

  @override
  Future onRefresh({String labelId, bool isReload}) {
    return getData(labelId: labelId, page: 0);
  }

  Future getBanner(String labelId) {
    return wanRepository.getBanner().then((list) {
      _bannerSink.add(UnmodifiableListView<BannerModel>(list));
      homeEventSink.add(new StatusEvent(status: 0));
    }).catchError((_) {
      homeEventSink.add(new StatusEvent(status: -1));
    });
  }

  Future _getBanner() {
    return wanRepository.getBanner();
  }

  /// 首页列表获取
  Future getAllData() async {
    Future.wait([_getBanner(), _getTop(), _getArticle()]).then((data) {
      var dataWrapper = new List();
      for (int i = 0; i < data.length; i++) {
        if (i == 0) {
          dataWrapper.add(data.first);
        } else if (i == 1) {
          dataWrapper.add(ReposModel.itemType(1));
          dataWrapper.addAll(data[i]);
        } else if (i == data.length - 1) {
          dataWrapper.add(ReposModel.itemType(2));
          dataWrapper.addAll(data[i]);
        }
      }
      allSink.add(dataWrapper);
      LogUtil.e(dataWrapper.length, tag: 'MainBloc');
    }).catchError((e) {
      LogUtil.e(e, tag: 'MainBloc');
    });
  }

  Future<List<ReposModel>> _getTop() async {
    return wanRepository.getTopList();
  }

  Future<List<ReposModel>> _getArticle() async {
    return wanRepository.getArticleList();
  }

  Future<List<ReposModel>> getRecWxArticleV2() async {
    int _id = 408;
    return wanRepository.getWxArticleList(id: _id);
  }

  Future getRecRepos(String labelId) async {
    ComReq _comReq = new ComReq(402);
    wanRepository.getRecReposList(data: _comReq.toJson()).then((list) {
      if (list.length > 10) {
        list = list.sublist(0, 10);
      }
      _recReposSink.add(UnmodifiableListView<ReposModel>(list));
    });
  }

  Future getRecWxArticle(String labelId) async {
    int _id = 408;
    wanRepository.getWxArticleList(id: _id).then((list) {
      if (list.length > 10) {
        list = list.sublist(0, 10);
      }
      _recWxArticleSink.add(UnmodifiableListView<ReposModel>(list));
    });
  }

  @override
  void dispose() {
    _banner.close();
    _recRepos.close();
    _recWxArticle.close();
    _homeEvent.close();
    _allData.close();
  }
}
