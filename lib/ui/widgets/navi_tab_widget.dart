import 'package:flutter/material.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/system_bloc.dart';
import 'package:frolo/data/common/common.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/navi_item.dart';
import 'package:frolo/ui/widgets/system_item.dart';
import 'package:frolo/utils/utils.dart';

import 'loading/square_circle.dart';

class NaviTabWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _SystemTabWidgetState();
}

class _SystemTabWidgetState extends State<NaviTabWidget>
    with AutomaticKeepAliveClientMixin {
  SystemBloc _systemBloc;

  @override
  void initState() {
    _systemBloc = BlocProvider.of<SystemBloc>(context);
    _systemBloc.getData(labelId: '1');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new StreamBuilder(
        stream: _systemBloc.tabNaviStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<NaviModel>> asyncSnapshot) {
          return buildSmartRefresher(asyncSnapshot);
        });
  }

  Widget buildSmartRefresher(AsyncSnapshot<List<NaviModel>> asyncSnapshot) {
    int loadingStatus =
        Utils.getLoadStatus(asyncSnapshot.hasError, asyncSnapshot.data);
    switch (loadingStatus) {
      case LoadingStatus.fail:
        return new Text('发生错误');
        break;
      case LoadingStatus.empty:
        return new Text('暂无数据');
        break;
      case LoadingStatus.success:
        return ListView.builder(
          itemBuilder: ((BuildContext context, int index) {
            return new NaviItem(asyncSnapshot.data[index]);
          }),
          itemCount: asyncSnapshot.data == null ? 0 : asyncSnapshot.data.length,
        );
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

  @override
  bool get wantKeepAlive => true;
}
