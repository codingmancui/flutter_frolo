import 'package:frolo/data/api/apis.dart';
import 'package:frolo/data/common/common.dart';
import 'package:frolo/data/net/dio_util.dart';
import 'package:frolo/data/protocol/base_resp.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:sp_util/sp_util.dart';

class UserRepository {
  Future<UserModel> login(LoginParam param) async {
    BaseRespR<Map<String, dynamic>> baseResp = await DioUtil()
        .requestR<Map<String, dynamic>>(Method.post, WanAndroidApi.user_login,
            data: param.toJson());
    if (baseResp.code != Constant.status_success) {
      return Future.error(baseResp.msg);
    }
    baseResp.response.headers.forEach((String name, List<String> values) {
      if (name == "set-cookie") {
        String cookie = values.toString();
        SpUtil.putString(Constant.keyAppToken, cookie).then((value) {
          LogUtil.e("set-cookie: " + cookie + "Cookie save $value");
        });
        DioUtil().setCookie(cookie);
      }
    });
    UserModel model = UserModel.fromJson(baseResp.data);
    SpUtil.putObject(Constant.keyUserModel, model);
    return model;
  }

  Future<UserCoinModel> getCoinUserInfo() async {
    BaseRespR<Map<String, dynamic>> baseResp = await DioUtil()
        .requestR<Map<String, dynamic>>(Method.get,
            WanAndroidApi.getPath(path: WanAndroidApi.lg_coin_userinfo));
    if (baseResp.code != Constant.status_success) {
      return Future.error(baseResp.msg);
    }
    UserCoinModel model = UserCoinModel.fromJson(baseResp.data);
    return model;
  }

  Future<UserModel> register(RegisterParam req) async {
    BaseRespR<Map<String, dynamic>> baseResp = await DioUtil()
        .requestR<Map<String, dynamic>>(
            Method.post, WanAndroidApi.user_register,
            data: req.toJson());
    if (baseResp.code != Constant.status_success) {
      return Future.error(baseResp.msg);
    }
    baseResp.response.headers.forEach((String name, List<String> values) {
      if (name == "set-cookie") {
        String cookie = values.toString();
        LogUtil.e("set-cookie: " + cookie);
        SpUtil.putString(Constant.keyAppToken, cookie);
        DioUtil().setCookie(cookie);
      }
    });
    UserModel model = UserModel.fromJson(baseResp.data);
    SpUtil.putObject(Constant.keyUserModel, model);
    return model;
  }
}
