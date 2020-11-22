import 'dart:collection';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/data/repository/wan_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc_provider.dart';

class SystemDetailBloc implements BlocBase {
  BehaviorSubject<List<SystemModel>> _tabTree =
      BehaviorSubject<List<SystemModel>>();

  Sink<List<SystemModel>> get _tabTreeSink => _tabTree.sink;

  Stream<List<SystemModel>> get tabTreeStream => _tabTree.stream;

  WanRepository wanRepository = new WanRepository();

  @override
  Future getData({String labelId, int page, int cid}) {}

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

  @override
  void dispose() {
    _tabTree.close();
  }
}
