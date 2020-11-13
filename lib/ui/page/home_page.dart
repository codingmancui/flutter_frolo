import 'package:cached_network_image/cached_network_image.dart';
import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/main_bloc.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/article_item.dart';
import 'package:frolo/ui/widgets/header_item.dart';
import 'package:frolo/ui/widgets/number_swiper_indicator.dart';
import 'package:frolo/ui/widgets/pulse.dart';
import 'package:frolo/ui/widgets/repos_item.dart';
import 'package:frolo/ui/widgets/square_circle.dart';
import 'package:frolo/ui/widgets/waterdrop_header_v2.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:frolo/utils/navigator_util.dart';
import 'package:frolo/utils/object_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  bool _isHomeInit = true;
  MainBloc _bloc;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _bloc = BlocProvider.of<MainBloc>(context);
    if (_isHomeInit) {
      _isHomeInit = false;
      _bloc.getHomeData('home');
    }
    _bloc.homeEventStream.listen((event) {
      _refreshController.refreshCompleted();
      LogUtil.e('HomePage is refreshCompleted', tag: 'Homepage');
    });
    super.initState();
  }

  void _onRefresh() async {
    // monitor network fetch
    _bloc.onRefresh(labelId: 'home', isReload: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: StreamBuilder(
                  stream: _bloc.bannerStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<BannerModel>> snapshot) {
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
            new SmartRefresher(
              enablePullDown: true,
              onRefresh: _onRefresh,
              controller: _refreshController,
              header: WaterDropHeaderV2(),
              child: new ListView(
                children: <Widget>[
                  StreamBuilder(
                      stream: _bloc.bannerStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<BannerModel>> snapshot) {
                        return buildBanner(context, snapshot.data);
                      }),
                  StreamBuilder(
                      stream: _bloc.recReposStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ReposModel>> snapshot) {
                        return buildRepos(context, snapshot.data);
                      }),
                  StreamBuilder(
                      stream: _bloc.recWxArticleStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ReposModel>> snapshot) {
                        return buildWxArticle(context, snapshot.data);
                      }),
                ],
              ),
            )
          ],
        ));
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
                    new SpinKitPulse(color: Colors.lightGreen),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            );
          }).toList(),
        ));
  }

  Widget buildRepos(BuildContext context, List<ReposModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }
    List<Widget> _children = list.map((model) {
      return new ReposItem(
        model,
        isHome: true,
      );
    }).toList();
    List<Widget> children = new List();
    children.add(new HeaderItem(
      leftIcon: Icons.book,
      titleId: 'rec_repos',
      title: '推荐项目',
      onTap: () {
        // NavigatorUtil.pushTabPage(context,
        //     labelId: Ids.titleReposTree, titleId: Ids.titleReposTree);
      },
    ));
    children.addAll(_children);
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget buildWxArticle(BuildContext context, List<ReposModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }
    List<Widget> _children = list.map((model) {
      return new ArticleItem(
        model,
        isHome: true,
      );
    }).toList();
    List<Widget> children = new List();
    children.add(new HeaderItem(
      titleColor: Colors.green,
      leftIcon: Icons.library_books,
      titleId: 'rec_wxarticle',
      title: '推荐公众号',
      onTap: () {
        // NavigatorUtil.pushTabPage(context,
        //     labelId: Ids.titleWxArticleTree, titleId: Ids.titleWxArticleTree);
      },
    ));
    children.addAll(_children);
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
