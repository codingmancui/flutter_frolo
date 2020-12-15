import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/data/repository/collect_repository.dart';
import 'package:frolo/data/repository/wan_repository.dart';
import 'package:frolo/event/event.dart';
import 'package:rxdart/subjects.dart';

class CollectBloc extends BlocBase {
  CollectRepository _repository = new CollectRepository();

  BehaviorSubject<List<Article>> _behaviorSubject = new BehaviorSubject();

  Sink<List<Article>> get collectSink => _behaviorSubject.sink;

  Stream<List<Article>> get collectStream => _behaviorSubject.stream;

  BehaviorSubject<StatusEvent> _event = BehaviorSubject<StatusEvent>();

  Sink<StatusEvent> get eventSink => _event.sink;

  Stream<StatusEvent> get eventStream => _event.stream.asBroadcastStream();

  List<Article> dataList = new List();
  int _page = 0;

  @override
  void dispose() {
    _behaviorSubject.close();
    _event.close();
  }

  @override
  Future getData({int page}) {
    return getCollectList(0);
  }

  Future getCollectList(int page) {
    return _repository.getCollectList(page).then((data) {
      dataList.addAll(data.list);
      collectSink.add(dataList);
      if (page == 1) {
        eventSink.add(
            new StatusEvent(noMore: data.curPage == data.pageCount, status: 0));
      } else {
        data.curPage == data.pageCount
            ? eventSink.add(new StatusEvent(status: 2))
            : eventSink.add(new StatusEvent(status: 1));
      }
    }).catchError((error) {
      if (_page > 1) {
        _page--;
      }
      eventSink.add(new StatusEvent(status: -1));
    });
  }

  @override
  Future onLoadMore({String labelId}) {
    ++_page;
    return getCollectList(_page);
  }

  @override
  Future onRefresh({String labelId}) {}
}
