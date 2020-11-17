import 'dart:collection';

import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/data/repository/wan_repository.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:rxdart/subjects.dart';
import 'package:sp_util/sp_util.dart';

class SearchBloc implements BlocBase {
  static const String LOCAL_HOT_TAG = 'local_hot_tag';
  WanRepository _wanRepository = new WanRepository();

  BehaviorSubject<List<SearchTagModel>> _searchSubject = BehaviorSubject();

  Sink<List<SearchTagModel>> get _searchSink => _searchSubject.sink;

  Stream<List<SearchTagModel>> get searchStream => _searchSubject.stream;

  Future getNetHotTag() {
    return _wanRepository.getSearchHotTag().then((list) {
      LogUtil.v('getHotTag list size ${list.length}', tag: 'SearchBloc');
      _searchSink.add(UnmodifiableListView<SearchTagModel>(list));
    }).catchError((e) {
      LogUtil.v('getHotTag list on error', tag: 'SearchBloc');
    });
  }

  Future getLocalHotTag() async {
    List<String> locals = await SpUtil.getStringList(LOCAL_HOT_TAG);
    LogUtil.v('getLocalHotTag values is  $locals', tag: 'SearchBloc');
  }

  @override
  void dispose() {
    _searchSubject.close();
  }

  @override
  Future getData({String labelId, int page}) async {
    getLocalHotTag();
    return getNetHotTag();
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
