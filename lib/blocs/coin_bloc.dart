import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/data/repository/wan_repository.dart';
import 'package:frolo/event/event.dart';
import 'package:rxdart/subjects.dart';

class CoinBloc extends BlocBase {
  WanRepository _wanRepository = new WanRepository();

  BehaviorSubject<List<CoinModel>> _behaviorSubject = new BehaviorSubject();

  Sink<List<CoinModel>> get coinSink => _behaviorSubject.sink;

  Stream<List<CoinModel>> get coinStream => _behaviorSubject.stream;

  BehaviorSubject<StatusEvent> _event = BehaviorSubject<StatusEvent>();

  Sink<StatusEvent> get eventSink => _event.sink;

  Stream<StatusEvent> get eventStream => _event.stream.asBroadcastStream();

  List<CoinModel> dataList = new List();
  int _page = 1;

  @override
  void dispose() {
    _behaviorSubject.close();
    _event.close();
  }

  @override
  Future getData({int page}) {
    return getCoinList(1);
  }

  Future getCoinList(int page) {
    return _wanRepository.getCoinList(page: page).then((data) {
      dataList.addAll(data.list);
      coinSink.add(dataList);
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
    return getCoinList(_page);
  }

  @override
  Future onRefresh({String labelId}) {}
}
