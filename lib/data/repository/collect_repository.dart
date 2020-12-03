import 'package:frolo/data/api/apis.dart';
import 'package:frolo/data/common/common.dart';
import 'package:frolo/data/net/dio_util.dart';
import 'package:frolo/data/protocol/base_resp.dart';
import 'package:frolo/data/protocol/models.dart';

class CollectRepository {
  Future<ArticlePageModel> getCollectList(int page) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.get,
            WanAndroidApi.getPath(
                path: WanAndroidApi.LG_COLLECT_LIST, page: page));
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    List<Article> list;
    ComData comData;
    if (baseResp.data != null) {
      comData = ComData.fromJson(baseResp.data);
      list = comData.datas?.map((value) {
        Article model = Article.fromJson(value);
        model.collect = true;
        return model;
      })?.toList();
    }
    return ArticlePageModel.fromData(list, comData.pageCount, comData.curPage);
  }

  Future<bool> collect(int id) async {
    BaseResp baseResp = await DioUtil().request(Method.post,
        WanAndroidApi.getPath(path: WanAndroidApi.LG_COLLECT, page: id));
    if (baseResp.code != Constant.status_success) {
      return Future.error(baseResp.msg);
    }
    return true;
  }

  Future<bool> unCollect(int id) async {
    BaseResp baseResp = await DioUtil().request(
        Method.post,
        WanAndroidApi.getPath(
            path: WanAndroidApi.LG_UNCOLLECT_ORIGINID, page: id));
    if (baseResp.code != Constant.status_success) {
      return Future.error(baseResp.msg);
    }
    return true;
  }
}
