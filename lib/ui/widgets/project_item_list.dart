import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/tab_list_bloc.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/repos_item_v2.dart';
import 'package:frolo/ui/widgets/square_circle.dart';
import 'package:frolo/ui/widgets/waterdrop_header_v2.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:frolo/utils/object_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'footer_v2.dart';

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
    _tabListBloc.onRefresh(labelId: 'home', cid: cid);
  }

  void _onLoadMore() async {
    _tabListBloc.onLoadMore(labelId: 'home', cid: cid);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Stack(
      children: <Widget>[
        Center(
          //加载动画
          child: new StreamBuilder(
              stream: _tabListBloc.tabListStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<ReposModel>> snapshot) {
                if (snapshot.hasData) {
                  return Container(height: 0);
                } else if (snapshot.hasError) {
                  return Text("报错啦");
                } else {
                  return SpinKitSquareCircle(
                      size: 60,
                      color: Colors.lime,
                      duration: Duration(milliseconds: 500));
                }
              }),
        ),
        new Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: new StreamBuilder(
                stream: _tabListBloc.tabListStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<ReposModel>> snapshot) {
                  return buildSmartRefresher(snapshot);
                }))
      ],
    );
  }

  Widget buildSmartRefresher(AsyncSnapshot<List<ReposModel>> snapshot) {
    if (ObjectUtil.isEmpty(snapshot.data)) {
      return new Container(
        height: 0,
        width: 0,
      );
    }

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
          return new ReposItemV2(snapshot.data[index]);
        },
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 0.5, color: Colors.grey[300]),
        itemCount: snapshot.data.length,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
