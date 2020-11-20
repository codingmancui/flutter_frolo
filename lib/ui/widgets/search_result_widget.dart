import 'package:flutter/material.dart';
import 'package:frolo/blocs/search_bloc.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/home_top_item.dart';
import 'package:frolo/ui/widgets/refresh_scaffold.dart';
import 'package:frolo/ui/widgets/search_item.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:frolo/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchResultWidget extends StatefulWidget {
  final SearchBloc _searchBloc;

  SearchResultWidget(this._searchBloc) {
    LogUtil.v('SearchResultWidget init');
  }

  @override
  State<StatefulWidget> createState() => SearchResultWidgetState();
}

class SearchResultWidgetState extends State<SearchResultWidget> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    widget._searchBloc.eventStream.listen((event) {
      switch (event.status) {
        case 0:
          {
            _refreshController.refreshCompleted(resetFooterState: true);
            if (event.noMore) {
              _refreshController.loadNoData();
            }
            break;
          }
        case 1:
          _refreshController.loadComplete();
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

  void _onRefresh() async {
    widget._searchBloc.onRefresh();
  }

  void _onLoadMore() async {
    widget._searchBloc.onLoadMore();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Color(0xFFFAFAFA),
      child: new StreamBuilder(
          stream: widget._searchBloc.searchStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<ArticleModel>> asyncSnapshot) {
            return _buildSmartRefresher(asyncSnapshot);
          }),
    );
  }

  Widget _buildSmartRefresher(AsyncSnapshot<List<ArticleModel>> snapshot) {
    int status = Utils.getLoadStatus(snapshot.hasError, snapshot.data);
    LogUtil.v("_buildSmartRefresher status $status");
    return new RefreshScaffold(
        loadingStatus: status,
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoadMore: _onLoadMore,
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return new SearchItem(index, snapshot.data[index]);
          },
          separatorBuilder: (BuildContext context, int index) =>
              Divider(height: 0.5, color: Colors.grey[300]),
          itemCount: snapshot.data == null ? 0 : snapshot.data.length,
        ));
  }
}
