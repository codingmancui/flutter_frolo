import 'package:flutter/material.dart';
import 'package:frolo/blocs/search_bloc.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/home_top_item.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'loading/footer_v2.dart';
import 'loading/square_circle.dart';
import 'loading/waterdrop_header_v2.dart';

class SearchResultWidget extends StatefulWidget {
  final SearchBloc _searchBloc;

  SearchResultWidget(this._searchBloc){
    LogUtil.v('SearchResultWidget init');
  }

  @override
  State<StatefulWidget> createState() => SearchResultWidgetState();
}

class SearchResultWidgetState extends State<SearchResultWidget> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    widget._searchBloc.onRefresh(labelId: 'home');
  }

  void _onLoadMore() async {
    widget._searchBloc.onLoadMore(labelId: 'home');
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
    LogUtil.v("_buildSmartRefresher $snapshot");
    if (snapshot.hasData) {
      return new SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoadMore,
        controller: _refreshController,
        header: WaterDropHeaderV2(),
        footer: ClassicFooterV2(),
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return new HomeTopItem(index, snapshot.data[index]);
          },
          separatorBuilder: (BuildContext context, int index) =>
              Divider(height: 0.5, color: Colors.grey[300]),
          itemCount: snapshot.data.length,
        ),
      );
    } else if (snapshot.hasError) {
      return new Text('发生错误');
    } else {
      return new SpinKitSquareCircle(
          size: 35, color: Colors.lime, duration: Duration(milliseconds: 500));
    }
  }
}
