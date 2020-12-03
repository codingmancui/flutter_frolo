import 'package:flutter/material.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/tab_list_bloc.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/project_list_item.dart';
import 'package:frolo/ui/widgets/refresh_scaffold.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:frolo/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectListWidget extends StatefulWidget {
  ProjectListWidget({Key key, this.cid}) : super(key: key);
  final int cid;

  @override
  State<StatefulWidget> createState() => new _ProjectListWidgetState(cid: cid);
}

class _ProjectListWidgetState extends State<ProjectListWidget>
    with AutomaticKeepAliveClientMixin {
  _ProjectListWidgetState({this.cid});

  String labelId;
  int cid;

  TabListBloc _tabListBloc;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    LogUtil.e('ProjectListWidget initState ' + cid.toString());
    _tabListBloc = BlocProvider.of<TabListBloc>(context);
    _tabListBloc.getData(cid: cid, page: 1);
    _tabListBloc.eventStream.listen((event) {
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
          {
            _refreshController.loadComplete();
            break;
          }
        case 2:
          {
            _refreshController.loadNoData();
            break;
          }
        case -1:
          {
            _refreshController.loadFailed();
            break;
          }
      }
      LogUtil.e('HomePage is refreshCompleted ${event.status}',
          tag: 'Homepage');
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    _tabListBloc.onRefresh(cid: cid);
  }

  void _onLoadMore() async {
    _tabListBloc.onLoadMore(cid: cid);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new StreamBuilder(
        stream: _tabListBloc.tabListStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          int status = Utils.getLoadStatus(snapshot.hasError, snapshot.data);
          return new RefreshScaffold(
              loadingStatus: status,
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: _onRefresh,
              onLoadMore: _onLoadMore,
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return new ProjectListItem(index, snapshot.data[index]);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(height: 0.5, color: Colors.grey[300]),
                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
              ));
        });
  }

  @override
  bool get wantKeepAlive => true;
}
