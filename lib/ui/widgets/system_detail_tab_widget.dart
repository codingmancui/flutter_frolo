import 'package:flutter/material.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/system_detail_bloc.dart';
import 'package:frolo/data/common/common.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/refresh_scaffold.dart';
import 'package:frolo/ui/widgets/system_detail_item.dart';
import 'package:frolo/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'loading/square_circle.dart';

class SystemDetailTabWidget extends StatefulWidget {
  final int cid;
  final String modelName;

  const SystemDetailTabWidget(this.cid, this.modelName);

  @override
  State<StatefulWidget> createState() => new _SystemTabWidgetState();
}

class _SystemTabWidgetState extends State<SystemDetailTabWidget>
    with AutomaticKeepAliveClientMixin {
  SystemDetailBloc _systemDetailBloc;
  RefreshController _refreshController;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    _systemDetailBloc = BlocProvider.of<SystemDetailBloc>(context);
    Future.delayed(new Duration(milliseconds: 500), () {
      _systemDetailBloc.getData(page: 0, cid: widget.cid);
    });
    _systemDetailBloc.systemEventStream.listen((event) {
      switch (event.status) {
        case 0:
          _refreshController.refreshCompleted(resetFooterState: true);
          if (event.noMore) {
            _refreshController.loadNoData();
          }
          break;
        case 1:
          _refreshController.loadComplete();
          break;
        case 2:
          _refreshController.loadNoData();
          break;
        case -1:
          break;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new StreamBuilder(
        stream: _systemDetailBloc.systemDetailStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<Article>> asyncSnapshot) {
          return buildSmartRefresher(asyncSnapshot);
        });
  }

  void _onRefresh() {
    _systemDetailBloc.onRefresh(cid: widget.cid);
  }

  void _onLoadMore() {
    _systemDetailBloc.onLoadMore(cid: widget.cid);
  }

  Widget buildSmartRefresher(AsyncSnapshot<List<Article>> asyncSnapshot) {
    int loadingStatus =
        Utils.getLoadStatus(asyncSnapshot.hasError, asyncSnapshot.data);
    return new RefreshScaffold(
        loadingStatus: loadingStatus,
        controller: _refreshController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: _onRefresh,
        onLoadMore: _onLoadMore,
        child: ListView.builder(
          itemBuilder: ((BuildContext context, int index) {
            return new SystemDetailItem(
                asyncSnapshot.data[index], widget.modelName);
          }),
          itemCount: asyncSnapshot.data == null ? 0 : asyncSnapshot.data.length,
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
