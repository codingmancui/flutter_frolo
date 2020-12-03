import 'package:cached_network_image/cached_network_image.dart';
import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/main_bloc.dart';
import 'package:frolo/blocs/search_bloc.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/page/search_page.dart';
import 'package:frolo/ui/widgets/header_item.dart';
import 'package:frolo/ui/widgets/home_top_item.dart';
import 'package:frolo/ui/widgets/number_swiper_indicator.dart';
import 'package:frolo/ui/widgets/loading/pulse.dart';
import 'package:frolo/ui/widgets/refresh_scaffold.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:frolo/utils/navigator_util.dart';
import 'package:frolo/utils/object_util.dart';
import 'package:frolo/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  bool _isHomeInit = true;
  MainBloc _bloc;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _bloc = BlocProvider.of<MainBloc>(context);
    if (_isHomeInit) {
      _isHomeInit = false;
      _bloc.getAllData();
    }
    _bloc.homeEventStream.listen((event) {
      if (event.status == 0) {
        _refreshController.refreshCompleted();
      } else if (event.status == 1) {
        _refreshController.loadComplete();
      }
      LogUtil.e('HomePage is refreshCompleted', tag: 'Homepage');
    });
    super.initState();
  }

  void _onRefresh() async {
    // monitor network fetch
    _bloc.onRefresh(isReload: true);
  }

  void _onLoadMore() async {
    _bloc.onLoadMore();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.dark,
          actions: <Widget>[
            new Container(
              margin: EdgeInsets.only(right: 15),
              child: new IconButton(
                  icon: new Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    NavigatorUtil.pushPage(
                        context,
                        new BlocProvider(
                            child: new SearchPage(), bloc: new SearchBloc()));
                    LogUtil.v('on home search click', tag: 'HomePage');
                  }),
            )
          ],
          toolbarHeight: 48,
          centerTitle: true,
          title: Text(
            '首页',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.normal),
          ),
        ),
        body: buildListView());
  }

  Widget buildListView() {
    return StreamBuilder(
        stream: _bloc.allStream,
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          int status = Utils.getLoadStatus(snapshot.hasError, snapshot.data);
          return RefreshScaffold(
              loadingStatus: status,
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onLoadMore: _onLoadMore,
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemBuilder: (BuildContext context, int position) {
                  return itemBuilder(position, snapshot);
                },
                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
              ));
        });
  }

  Widget itemBuilder(int position, AsyncSnapshot<List<dynamic>> snapshot) {
    if (snapshot.hasData) {
      var data = snapshot.data[position];
      if (data is List) {
        return buildBanner(context, data as List<BannerModel>);
      } else {
        var item = data as Article;
        switch (item.itemType) {
          case 0:
            {
              return HomeTopItem(position, item);
            }
          case 1:
            {
              return const HeaderItem(
                leftIcon: Icons.book,
                titleColor: Color(0xFFEF5350),
                titleId: 'rec_repos',
                title: '置顶文章',
              );
            }
          case 2:
            {
              return const HeaderItem(
                leftIcon: Icons.library_books,
                titleColor: Color(0xFFEF5350),
                titleId: 'rec_repos',
                title: '热门博文',
              );
            }
          default:
            {
              return new Container(
                height: 0,
              );
            }
        }
      }
    } else {
      return new Container(
        height: 0,
      );
    }
  }

  Widget buildBanner(BuildContext context, List<BannerModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0);
    }
    return new AspectRatio(
        aspectRatio: 16.0 / 9.0,
        child: Swiper(
          indicatorAlignment: AlignmentDirectional.bottomEnd,
          circular: true,
          interval: const Duration(seconds: 5),
          indicator: NumberSwiperIndicator(),
          children: list.map((model) {
            return new InkWell(
              onTap: () {
                NavigatorUtil.pushWeb(context,
                    title: model.title, url: model.url);
              },
              child: new CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: model.imagePath,
                placeholder: (context, url) =>
                    const SpinKitPulse(color: Colors.lightGreen),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            );
          }).toList(),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
