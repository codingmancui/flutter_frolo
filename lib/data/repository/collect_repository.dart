import 'package:frolo/data/api/apis.dart';
import 'package:frolo/data/common/common.dart';
import 'package:frolo/data/net/dio_util.dart';
import 'package:frolo/data/protocol/base_resp.dart';
import 'package:frolo/data/protocol/models.dart';

class CollectRepository {
  Future<List<ArticleModel>> getCollectList(int page) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.get,
            WanAndroidApi.getPath(
                path: WanAndroidApi.lg_collect_list, page: page));
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    List<ArticleModel> list;
    if (baseResp.data != null) {
      ComData comData = ComData.fromJson(baseResp.data);
      list = comData.datas?.map((value) {
        ArticleModel model = ArticleModel.fromJson(value);
        model.collect = true;
        return model;
      })?.toList();
    }
    return list;
  }

  Future<bool> collect(int id) async {
    BaseResp baseResp = await DioUtil().request(Method.post,
        WanAndroidApi.getPath(path: WanAndroidApi.lg_collect, page: id));
    if (baseResp.code != Constant.status_success) {
      return Future.error(baseResp.msg);
    }
    return true;
  }

  Future<bool> unCollect(int id) async {
    BaseResp baseResp = await DioUtil().request(
        Method.post,
        WanAndroidApi.getPath(
            path: WanAndroidApi.lg_uncollect_originid, page: id));
    if (baseResp.code != Constant.status_success) {
      return Future.error(baseResp.msg);
    }
    return true;
  }
}
