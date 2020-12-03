import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/coin_bloc.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/CoinHeaderWidget.dart';
import 'package:frolo/ui/widgets/back_button.dart';
import 'package:frolo/ui/widgets/refresh_scaffold.dart';
import 'package:frolo/utils/date_util.dart';
import 'package:frolo/utils/ui_gaps.dart';
import 'package:frolo/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CoinDetailPage extends StatefulWidget {
  final int coins;

  const CoinDetailPage(this.coins);

  @override
  State<StatefulWidget> createState() => new _CoinDetailPageState();
}

class _CoinDetailPageState extends State<CoinDetailPage> {
  CoinBloc _coinBloc;
  RefreshController _refreshController = new RefreshController();

  @override
  void initState() {
    _coinBloc = BlocProvider.of<CoinBloc>(context);
    _coinBloc.getData();
    _coinBloc.eventStream.listen((event) {
      switch (event.status) {
        case 0:
          _refreshController.refreshCompleted(resetFooterState: true);
          if (event.noMore) {
            _refreshController.loadNoData();
          }
          break;
        case 2:
          _refreshController.loadNoData();
          break;
        case -1:
          _refreshController.loadFailed();
          break;
      }
    });
    super.initState();
  }

  void _loadMore() {
    _coinBloc.onLoadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        brightness: Brightness.dark,
        elevation: 0,
        toolbarHeight: 48,
        leading: BackButtonV2(color: Colors.white),
        centerTitle: true,
        title: Text(
          '我的积分',
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal),
        ),
      ),
      body: new Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new CoinHeaderWidget(widget.coins),
          new Expanded(
              child: new StreamBuilder(
                  stream: _coinBloc.coinStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<CoinModel>> snapshot) {
                    int status =
                        Utils.getLoadStatus(snapshot.hasError, snapshot.data);
                    return new RefreshScaffold(
                        loadingStatus: status,
                        controller: _refreshController,
                        enablePullDown: false,
                        enablePullUp: true,
                        onLoadMore: _loadMore,
                        child: ListView.builder(
                            itemBuilder: (context, index) {
                              return buildItem(snapshot.data[index]);
                            },
                            itemCount:
                                snapshot.hasData ? snapshot.data.length : 0));
                  }))
        ],
      ),
    );
  }

  Container buildItem(CoinModel model) {
    int index = model.desc.lastIndexOf('：');
    String s = model.desc.substring(index + 1);
    return new Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Text(
                '${model.reason}积分$s',
                style: new TextStyle(fontSize: 14),
              ),
              Gaps.vGap5,
              new Text(
                DateUtil.formatDateMs(model.date, format: 'MM-dd HH:mm')
                    .toString(),
                style: new TextStyle(
                    fontSize: 12, color: Colors.black.withOpacity(0.5)),
              )
            ],
          ),
          new Expanded(child: new Container()),
          new Text(
            '+${model.coinCount}',
            style: new TextStyle(
                color: Colors.lightGreen,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
