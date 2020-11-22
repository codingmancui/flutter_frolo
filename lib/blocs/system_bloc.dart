import 'dart:collection';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/data/repository/wan_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc_provider.dart';

class SystemBloc implements BlocBase {
  BehaviorSubject<List<SystemModel>> _tabTree =
      BehaviorSubject<List<SystemModel>>();

  Sink<List<SystemModel>> get _tabTreeSink => _tabTree.sink;

  Stream<List<SystemModel>> get tabTreeStream => _tabTree.stream;

  BehaviorSubject<List<NaviModel>> _tabNavi =
      BehaviorSubject<List<NaviModel>>();

  Sink<List<NaviModel>> get _tabNaviSink => _tabNavi.sink;

  Stream<List<NaviModel>> get tabNaviStream => _tabNavi.stream;

  WanRepository wanRepository = new WanRepository();

  @override
  Future getData({String labelId, int page}) {
    if (labelId == '0') {
      return getTreeData();
    }
    return getNaviData();
  }

  @override
  Future onLoadMore({String labelId}) {
    return null;
  }

  @override
  Future onRefresh({String labelId}) {
    return null;
  }

  Future getTreeData() {
    return wanRepository.getSystemList().then((list) {
      _tabTreeSink.add(UnmodifiableListView<SystemModel>(list));
    });
  }

  Future getNaviData() {
    return wanRepository.getNaviList().then((list) {
      _tabNaviSink.add(UnmodifiableListView<NaviModel>(list));
    });
  }

  @override
  void dispose() {
    _tabTree.close();
    _tabNavi.close();
  }
}
