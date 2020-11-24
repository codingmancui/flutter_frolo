import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frolo/utils/ui_gaps.dart';
import 'package:frolo/utils/utils.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _username = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _pwd = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _pwdVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    _usernameController.addListener(() {
      var length = _usernameController.text.trim().length;
      _username.value = length > 0;
    });
    _passwordController.addListener(() {
      var length = _passwordController.text.trim().length;
      _pwd.value = length > 0;
    });
    super.initState();
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
          new Column(
            children: <Widget>[
              Gaps.getVGap(80),
              new Container(
                height: 36,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 50, right: 50),
                decoration: BoxDecoration(
                    // 下滑线浅灰色，宽度1像素
                    border: Border(
                        bottom:
                            BorderSide(color: Colors.grey[200], width: 1.0))),
                child: new Stack(
                  children: <Widget>[
                    new TextField(
                      controller: _usernameController,
                      maxLines: 1,
                      decoration: new InputDecoration(
                          hintText: '请输入用户名',
                          hintMaxLines: 1,
                          // contentPadding: EdgeInsets.all(10),
                          hintStyle:
                              TextStyle(color: Color(0xFFDCDCDC), fontSize: 18),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none),
                      style: new TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF262626),
                          fontSize: 18),
                    ),
                    new Align(
                        alignment: Alignment.centerRight,
                        child: ValueListenableBuilder<bool>(
                            valueListenable: _username,
                            builder: (context, value, _) {
                              return new Offstage(
                                child: new InkWell(
                                  onTap: () {
                                    _usernameController.clear();
                                  },
                                  child: new Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                ),
                                offstage: !value,
                              );
                            }))
                  ],
                ),
              ),
              Gaps.getVGap(20),
              new Container(
                height: 36,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 50, right: 50),
                decoration: BoxDecoration(
                    // 下滑线浅灰色，宽度1像素
                    border: Border(
                        bottom:
                            BorderSide(color: Colors.grey[200], width: 1.0))),
                child: new Stack(
                  children: <Widget>[
                    new ValueListenableBuilder(
                        valueListenable: _pwdVisible,
                        builder: (context, value, _) {
                          return TextField(
                            controller: _passwordController,
                            maxLines: 1,
                            obscureText: value,
                            decoration: new InputDecoration(
                                hintText: '请输入密码',
                                hintMaxLines: 1,
                                // contentPadding: EdgeInsets.all(10),
                                hintStyle: TextStyle(
                                    color: Color(0xFFDCDCDC), fontSize: 18),
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none),
                            style: new TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF262626),
                                fontSize: 18),
                          );
                        }),
                    new Align(
                        alignment: Alignment.centerRight,
                        child: new Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new ValueListenableBuilder(
                                valueListenable: _pwd,
                                builder: (BuildContext context, bool value,
                                    Widget child) {
                                  return new Offstage(
                                    child: new InkWell(
                                      onTap: () {
                                        _passwordController.clear();
                                      },
                                      child: new Icon(
                                        Icons.close,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                    ),
                                    offstage: !value,
                                  );
                                }),
                            Gaps.hGap10,
                            new InkWell(
                              onTap: () {
                                _pwdVisible.value = !_pwdVisible.value;
                              },
                              child: new ValueListenableBuilder(
                                  valueListenable: _pwdVisible,
                                  builder: (BuildContext context, bool value,
                                      Widget child) {
                                    return new Image.asset(
                                      value
                                          ? Utils.getImgPath('ic_visibility')
                                          : Utils.getImgPath(
                                              'ic_visibility_off'),
                                      width: 18,
                                      height: 18,
                                    );
                                  }),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
              Gaps.getVGap(80),
              new Container(
                width: double.infinity,
                height: 48,
                margin: EdgeInsets.only(left: 50, right: 50),
                child: new FlatButton(
                  disabledColor: Color(0xFFC5E1A5),
                  color: Colors.lightGreen,
                  colorBrightness: Brightness.dark,
                  child: new Text(
                    "登录",
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0)),
                  onPressed: () {},
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
