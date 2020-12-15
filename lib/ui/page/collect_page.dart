import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/collect_bloc.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/back_button.dart';
import 'package:frolo/ui/widgets/loading/pulse.dart';
import 'package:frolo/ui/widgets/refresh_scaffold.dart';
import 'package:frolo/utils/navigator_util.dart';
import 'package:frolo/utils/object_util.dart';
import 'package:frolo/utils/ui_gaps.dart';
import 'package:frolo/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CollectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  CollectBloc _collectBloc;
  RefreshController _refreshController = new RefreshController();

  @override
  void initState() {
    _collectBloc = BlocProvider.of<CollectBloc>(context);
    _collectBloc.getData();
    _collectBloc.eventStream.listen((event) {
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
    _collectBloc.onLoadMore();
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
          '我的收藏',
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal),
        ),
      ),
      body: new StreamBuilder(
          stream: _collectBloc.collectStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<Article>> snapshot) {
            int status = Utils.getLoadStatus(snapshot.hasError, snapshot.data);
            return new RefreshScaffold(
                loadingStatus: status,
                controller: _refreshController,
                enablePullDown: false,
                enablePullUp: true,
                onLoadMore: _loadMore,
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      var model = snapshot.data[index];
                      return new InkWell(
                        child: buildItem(model),
                        onTap: () {
                          NavigatorUtil.pushWeb(context,
                              title: model.title, url: model.link);
                        },
                      );
                    },
                    itemCount: snapshot.hasData ? snapshot.data.length : 0));
          }),
    );
  }

  Container buildItem(Article model) {
    return new Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: buildItemType(model),
    );
  }

  Widget buildItemType(Article model) {
    if (ObjectUtil.isEmptyString(model.envelopePic)) {
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Text(
                ObjectUtil.isEmptyString(model.author) ? '匿名' : model.author,
                style: new TextStyle(
                    fontSize: 12, color: Colors.black.withOpacity(0.5)),
              ),
              new Expanded(child: new Container()),
              new Text(
                model.niceDate,
                style: new TextStyle(
                    fontSize: 12, color: Colors.black.withOpacity(0.5)),
              )
            ],
          ),
          Gaps.vGap5,
          new Text(
            model.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(fontSize: 14),
          ),
          Gaps.getVGap(
            ObjectUtil.isEmptyString(model.desc) ? 0 : 6,
          ),
          new Text(
            model.desc,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(
                fontSize: 13, color: Colors.black.withOpacity(0.5)),
          ),
          Gaps.getVGap(5),
          new Text(
            model.chapterName,
            style: new TextStyle(fontSize: 12, color: Colors.lightGreen),
          )
        ],
      );
    } else {
      return new Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Text(
                ObjectUtil.isEmptyString(model.author) ? '匿名' : model.author,
                style: new TextStyle(
                    fontSize: 12, color: Colors.black.withOpacity(0.5)),
              ),
              new Expanded(child: new Container()),
              new Text(
                model.niceDate,
                style: new TextStyle(
                    fontSize: 12, color: Colors.black.withOpacity(0.5)),
              )
            ],
          ),
          Gaps.vGap10,
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                child: new CachedNetworkImage(
                  width: 72,
                  height: 56,
                  fit: BoxFit.fill,
                  imageUrl: model.envelopePic,
                  placeholder: (BuildContext context, String url) {
                    return new SpinKitPulse(color: Colors.lightGreen);
                  },
                  errorWidget:
                      (BuildContext context, String url, Object error) {
                    return new Icon(
                      Icons.error,
                      color: Colors.lightGreen,
                    );
                  },
                ),
              ),
              Gaps.hGap10,
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Gaps.getVGap(2),
                    new Text(model.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: new TextStyle(fontSize: 12)),
                    Gaps.getVGap(2),
                    new Text(model.desc,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: new TextStyle(
                            fontSize: 11, color: Colors.black.withOpacity(0.5)))
                  ],
                ),
              )
            ],
          ),
          Gaps.getVGap(10),
          new Text(
            model.chapterName,
            style: new TextStyle(fontSize: 12, color: Colors.lightGreen),
          )
        ],
      );
    }
  }
}
