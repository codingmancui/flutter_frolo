import 'dart:collection';
import 'package:frolo/data/common/common.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/data/repository/user_repository.dart';
import 'package:frolo/data/repository/wan_repository.dart';
import 'package:frolo/provider/user_info_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sp_util/sp_util.dart';
import 'bloc_provider.dart';

class MeBloc implements BlocBase {
  UserRepository _userRepository = new UserRepository();

  @override
  Future getData({int page}) {
    return null;
  }

  @override
  Future onLoadMore({String labelId}) {
    return null;
  }

  @override
  Future onRefresh({String labelId}) {
    return null;
  }

  Future getUserCoinInfo(UserInfoProvider userInfoProvider) {
    bool loadLocal = _loadLocalUserInfo(userInfoProvider);
    return _userRepository.getCoinUserInfo().then((data) {
      SpUtil.putObject(Constant.keyUserCoinModel, data);
      if (!loadLocal) {
        _loadLocalUserInfo(userInfoProvider);
      }
    });
  }

  bool _loadLocalUserInfo(UserInfoProvider userInfoProvider) {
    UserModel userModel =
        SpUtil.getObj(Constant.keyUserModel, (v) => UserModel.fromJson(v));
    if (userModel != null) {
      userInfoProvider.setUserName(userModel.username);
    }
    UserCoinModel userCoinModel = SpUtil.getObj(
        Constant.keyUserCoinModel, (v) => UserCoinModel.fromJson(v));
    if (userCoinModel != null) {
      userInfoProvider.setCoinCount(userCoinModel.coinCount);
      userInfoProvider.setRank(userCoinModel.rank);
      userInfoProvider.setLevel(userCoinModel.level);
    }
    return userCoinModel != null && userCoinModel != null;
  }

  @override
  void dispose() {}
}
