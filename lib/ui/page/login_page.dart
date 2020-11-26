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
  AnimationController controller;
  Animation opacityLogin;
  Animation opacityRegister;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    opacityLogin = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.0, 0.5, curve: Curves.linear)))
      ..addListener(() {
        setState(() {});
      });
    opacityRegister = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.5, 1, curve: Curves.linear)))
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  void _userLogin(String userName, String password) {
    UserRepository userRepository = new UserRepository();
    LoginParam param = new LoginParam(userName, password);
    userRepository.login(param).then((UserModel model) {
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

  @override
  void dispose() {
    controller.dispose();
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
          new Stack(
            children: <Widget>[
              new Opacity(
                opacity: opacityLogin.value == null ? 1 : opacityLogin.value,
                child: new LoginWidget((username, password) {
                  _userLogin(username, password);
                }, () {
                  controller.forward();
                }),
              ),
              new Opacity(
                opacity:
                    opacityRegister.value == null ? 0 : opacityRegister.value,
                child: RegisterWidget((username, password, repassword) {}),
              )
            ],
          )
        ],
      ),
    );
  }
}
