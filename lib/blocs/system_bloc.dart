import 'dart:collection';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/data/repository/wan_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc_provider.dart';

class SystemBloc implements BlocBase {
  BehaviorSubject<List<TreeModel>> _tabTree =
      BehaviorSubject<List<TreeModel>>();

  Sink<List<TreeModel>> get _tabTreeSink => _tabTree.sink;

  Stream<List<TreeModel>> get tabTreeStream => _tabTree.stream;

  WanRepository wanRepository = new WanRepository();

  @override
  Future getData({String labelId, int page}) {
    return null;
  }

  @override
  Future onLoadMore({String labelId}) {
    return null;
  }

  @override
  Future onRefresh({String labelId}) {
    return null;
  }

  Future getProjectTree() {
    return wanRepository.getProjectTree().then((list) {
      if (list.length > 6) {
        list = list.sublist(0, 6);
      }
      _tabTreeSink.add(UnmodifiableListView<TreeModel>(list));
    });
  }

  @override
  void dispose() {
    _tabTree.close();
  }
}
