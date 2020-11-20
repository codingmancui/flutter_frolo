import 'package:flutter/material.dart';
import 'package:frolo/data/common/common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'loading/load_more_footer.dart';
import 'loading/refresh_header.dart';
import 'loading/square_circle.dart';

typedef void OnLoadMore();
typedef void OnRefresh();

class RefreshScaffold extends StatelessWidget {
  const RefreshScaffold(
      {Key key,
      this.loadingStatus,
      @required this.controller,
      this.enablePullUp: false,
      this.enablePullDown: false,
      this.onRefresh,
      this.onLoadMore,
      @required this.child})
      : super(key: key);

  final int loadingStatus;
  final RefreshController controller;
  final bool enablePullUp;
  final bool enablePullDown;
  final OnRefresh onRefresh;
  final OnLoadMore onLoadMore;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: buildSmartRefresher());
  }

  Widget buildSmartRefresher() {
    switch (loadingStatus) {
      case LoadingStatus.fail:
        return new Text('发生错误');
        break;
      case LoadingStatus.empty:
        return new Text('暂无数据');
        break;
      case LoadingStatus.success:
        return new SmartRefresher(
            controller: controller,
            enablePullDown: enablePullDown,
            enablePullUp: enablePullUp,
            onRefresh: onRefresh,
            onLoading: onLoadMore,
            header: RefreshHeader(),
            footer: LoadMoreFooter(),
            child: child);
        break;
      case LoadingStatus.loading:
        return new SpinKitSquareCircle(
            size: 35,
            color: Colors.lime,
            duration: Duration(milliseconds: 600));
        break;
      default:
        return new Container(
          width: 0,
          height: 0,
        );
        break;
    }
  }
}
