import 'package:flutter/material.dart';
import 'package:frolo/data/common/common.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/data/repository/user_repository.dart';
import 'package:frolo/event/event.dart';
import 'package:frolo/ui/widgets/login_widget.dart';
import 'package:frolo/ui/widgets/register_widget.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:frolo/utils/ui_gaps.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool _showFirst = true;
  UserRepository _userRepository = new UserRepository();

  @override
  void initState() {
    super.initState();
  }

  void _userLogin(String userName, String password) {
    LoginParam param = new LoginParam(userName, password);
    _userRepository.login(param).then((UserModel model) {
      LogUtil.e("LoginResp: ${model.toString()}");
      Toast.show("登录成功～", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      Event.sendAppEvent(context, Constant.type_login_success);

      Future.delayed(new Duration(milliseconds: 500), () {
        Navigator.pop(context);
      });
    }).catchError((error) {
      Toast.show("${error.toString()}～", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    });
  }

  void _register(String userName, String password, String repassword) {
    if (password != repassword) {
      Toast.show("密码输入不一致～", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      return;
    }
    RegisterParam param = new RegisterParam(userName, password, repassword);
    _userRepository.register(param).then((UserModel model) {
      LogUtil.e("RegisterResp: ${model.toString()}");
      Toast.show("登录成功～", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      Event.sendAppEvent(context, Constant.type_login_success);

      Future.delayed(new Duration(milliseconds: 500), () {
        Navigator.pop(context);
      });
    }).catchError((error) {
      Toast.show("${error.toString()}～", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            height: 48,
            width: 48,
            margin: EdgeInsets.only(top: 50, left: 10),
            child: new InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: new BackButtonIcon(),
            ),
          ),
          Gaps.getVGap(45),
          new Container(
            margin: EdgeInsets.only(left: 50, right: 50),
            child: new Column(
              children: <Widget>[
                new Text(
                  '欢迎登录玩安卓',
                  style: new TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF262626)),
                )
              ],
            ),
          ),
          AnimatedCrossFade(
            duration: Duration(
              milliseconds: 1000,
            ),
            crossFadeState: _showFirst
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: new LoginWidget((username, password) {
              _userLogin(username, password);
            }, () {
              setState(() {
                _showFirst = !_showFirst;
              });
            }),
            secondChild: RegisterWidget((username, password, repassword) {
              _register(username, password, repassword);
            }),
          ),
        ],
      ),
    );
  }
}
