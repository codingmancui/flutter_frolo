import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/tab_list_bloc.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/repos_item_v2.dart';
import 'package:frolo/ui/widgets/square_circle.dart';
import 'package:frolo/utils/log_util.dart';

class ProjectListWidget extends StatefulWidget {
  ProjectListWidget({Key key, this.cid}) : super(key: key);
  final int cid;

  @override
  State<StatefulWidget> createState() {
    return _ProjectListWidgetState(cid: cid);
  }
}

class _ProjectListWidgetState extends State<ProjectListWidget>
    with AutomaticKeepAliveClientMixin {
  _ProjectListWidgetState({this.cid});

  String labelId;
  int cid;

  TabListBloc _tabListBloc;

  @override
  void initState() {
    LogUtil.e('ProjectListWidget initState ' + cid.toString());
    _tabListBloc = BlocProvider.of<TabListBloc>(context);
    _tabListBloc.getData(cid: cid, page: 1);
    super.initState();
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
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return new ReposItemV2();
                    },
                    itemCount: 50,
                  );
                }))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
