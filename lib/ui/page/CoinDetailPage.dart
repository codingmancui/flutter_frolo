import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/coin_bloc.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/CoinHeaderWidget.dart';
import 'package:frolo/ui/widgets/back_button.dart';
import 'package:frolo/ui/widgets/refresh_scaffold.dart';
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
    _coinBloc.coinStream.listen((event) {});
    super.initState();
  }

  void _loadMore() {}

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
                              return Text('data');
                            },
                            itemCount:
                                snapshot.hasData ? snapshot.data.length : 0));
                  }))
        ],
      ),
    );
  }
}
