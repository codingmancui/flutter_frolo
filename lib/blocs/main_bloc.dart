import 'dart:collection';

import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/data/repository/wan_repository.dart';
import 'package:frolo/event/event.dart';
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
  }
}
