import 'package:frolo/data/api/apis.dart';
import 'package:frolo/data/common/common.dart';
import 'package:frolo/data/net/dio_util.dart';
import 'package:frolo/data/protocol/base_resp.dart';
import 'package:frolo/data/protocol/models.dart';

class WanRepository {
  Future<List<BannerModel>> getBanner() async {
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.getPath(path: WanAndroidApi.BANNER));
    List<BannerModel> bannerList;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      bannerList = baseResp.data.map((value) {
        return BannerModel.fromJson(value);
      }).toList();
    }
    return bannerList;
  }

  Future<List<ArticleModel>> getTopList() async {
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.getPath(path: WanAndroidApi.TOP_LISt));
    List<ArticleModel> list;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }

    if (baseResp.data != null) {
      list = baseResp.data.map((value) {
        return ArticleModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<List<ArticleModel>> getArticleList({int page: 0, data}) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.get,
            WanAndroidApi.getPath(
                path: WanAndroidApi.ARTICLE_LIST, page: page));
    List<ArticleModel> list;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      ComData comData = ComData.fromJson(baseResp.data);
      list = comData.datas.map((value) {
        return ArticleModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<List<ArticleModel>> getRecReposList({int page: 1, data}) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.get,
            WanAndroidApi.getPath(path: WanAndroidApi.PROJECT_LIST, page: page),
            data: data);
    List<ArticleModel> list;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      ComData comData = ComData.fromJson(baseResp.data);
      list = comData.datas.map((value) {
        return ArticleModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<List<ArticleModel>> getWxArticleList(
      {int id, int page: 1, data}) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.get,
            WanAndroidApi.getPath(
                path: WanAndroidApi.WXARTICLE_LIST + '/$id', page: page),
            data: data);
    List<ArticleModel> list;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      ComData comData = ComData.fromJson(baseResp.data);
      list = comData.datas.map((value) {
        return ArticleModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<List<TreeModel>> getProjectTree() async {
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.getPath(path: WanAndroidApi.PROJECT_TREE));
    List<TreeModel> treeList;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      treeList = baseResp.data.map((value) {
        return TreeModel.fromJson(value);
      }).toList();
    }
    return treeList;
  }

  Future<DataPagingModel> getProjectList({int page: 1, data}) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.get,
            WanAndroidApi.getPath(path: WanAndroidApi.PROJECT_LIST, page: page),
            data: data);
    List<ArticleModel> list;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    ComData comData;
    if (baseResp.data != null) {
      comData = ComData.fromJson(baseResp.data);
      list = comData.datas.map((value) {
        return ArticleModel.fromJson(value);
      }).toList();
    }
    return DataPagingModel.fromData(list, comData.pageCount, comData.curPage);
  }

  Future<List<SearchTagModel>> getSearchHotTag() async {
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.getPath(path: WanAndroidApi.HOT_KEY));
    List<SearchTagModel> tagList;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      tagList = baseResp.data.map((value) {
        return SearchTagModel.fromJson(value);
      }).toList();
    }
    return tagList;
  }

  Future<DataPagingModel> getSearchList({int page: 0, data}) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.post,
            WanAndroidApi.getPath(path: WanAndroidApi.SEARCH_LIST, page: page),
            data: data);
    List<ArticleModel> list;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    ComData comData;
    if (baseResp.data != null) {
      comData = ComData.fromJson(baseResp.data);
      list = comData.datas.map((value) {
        return ArticleModel.fromJson(value);
      }).toList();
    }
    return DataPagingModel.fromData(list, comData.pageCount, comData.curPage);
  }

  Future<List<SystemModel>> getSystemList() async {
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.getPath(path: WanAndroidApi.TREE));
    List<SystemModel> list;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      list = baseResp.data.map((value) {
        return SystemModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<List<NaviModel>> getNaviList() async {
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.getPath(path: WanAndroidApi.NAVI));
    List<NaviModel> list;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      list = baseResp.data.map((value) {
        return NaviModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<DataPagingModel> getSystemDetailList({int page: 1, data}) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.get,
        WanAndroidApi.getPath(path: WanAndroidApi.ARTICLE_LIST, page: page),
        data: data);
    List<ArticleModel> list;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    ComData comData;
    if (baseResp.data != null) {
      comData = ComData.fromJson(baseResp.data);
      list = comData.datas.map((value) {
        return ArticleModel.fromJson(value);
      }).toList();
    }
    return DataPagingModel.fromData(list, comData.pageCount, comData.curPage);
  }
}
