import 'dart:collection';

import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/data/repository/wan_repository.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:rxdart/subjects.dart';

class SearchBloc implements BlocBase {
  WanRepository _wanRepository = new WanRepository();

  BehaviorSubject<List<SearchTagModel>> _searchSubject = BehaviorSubject();

  Sink<List<SearchTagModel>> get _searchSink => _searchSubject.sink;

  Stream<List<SearchTagModel>> get searchStream => _searchSubject.stream;

  Future getHotTag() {
    return _wanRepository.getSearchHotTag().then((list) {
      LogUtil.v('getHotTag list size ${list.length}', tag: 'SearchBloc');
      _searchSink.add(UnmodifiableListView<SearchTagModel>(list));
    }).catchError((e) {
      LogUtil.v('getHotTag list on error', tag: 'SearchBloc');
    });
  }

  @override
  void dispose() {
    _searchSubject.close();
  }

  @override
  Future getData({String labelId, int page}) {
    return getHotTag();
  }

  @override
  Future onLoadMore({String labelId}) {
    return null;
  }

  @override
  Future onRefresh({String labelId}) {
    return null;
  }
}
