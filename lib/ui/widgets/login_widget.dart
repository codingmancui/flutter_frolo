import 'package:flutter/material.dart';
import 'package:frolo/utils/ui_gaps.dart';
import 'package:frolo/utils/utils.dart';

typedef Login = void Function(String username, String password);
typedef ToRegister = void Function();

class LoginWidget extends StatefulWidget {
  final Login _login;
  final ToRegister _toRegister;

  const LoginWidget(this._login, this._toRegister);

  @override
  State<StatefulWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _username = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _pwd = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _pwdVisible = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _clickable = ValueNotifier<bool>(false);

  @override
  void initState() {

    _usernameController.addListener(() {
      var length = _usernameController.text.trim().length;
      var pwdLength = _passwordController.text.trim().length;
      _username.value = length > 0;
      if (length > 0 && pwdLength > 0) {
        _clickable.value = true;
      }
      if (length == 0 || pwdLength == 0) {
        _clickable.value = false;
      }
    });
    _passwordController.addListener(() {
      var length = _passwordController.text.trim().length;
      var nameLength = _usernameController.text.trim().length;
      _pwd.value = length > 0;
      if (length > 0 && nameLength > 0) {
        _clickable.value = true;
      }
      if (length == 0 || nameLength == 0) {
        _clickable.value = false;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Gaps.getVGap(80),
        new Container(
          height: 36,
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 50, right: 50),
          decoration: BoxDecoration(
              // 下滑线浅灰色，宽度1像素
              border: Border(
                  bottom: BorderSide(color: Colors.grey[200], width: 1.0))),
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
                  bottom: BorderSide(color: Colors.grey[200], width: 1.0))),
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
                          hintStyle:
                              TextStyle(color: Color(0xFFDCDCDC), fontSize: 18),
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
                          builder:
                              (BuildContext context, bool value, Widget child) {
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
                                    : Utils.getImgPath('ic_visibility_off'),
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
        Gaps.vGap10,
        new Container(
          margin: EdgeInsets.only(right: 50),
          child: new InkWell(
            onTap: () {
              widget._toRegister();
            },
            child: new Text(
              '去注册',
              style: new TextStyle(
                fontSize: 12,
                color: Colors.lightGreen,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        Gaps.getVGap(65),
        new Container(
          width: double.infinity,
          height: 42,
          margin: EdgeInsets.only(left: 50, right: 50),
          child: new ValueListenableBuilder(
              valueListenable: _clickable,
              builder: (context, value, _) {
                return new FlatButton(
                  disabledColor: Color(0xFFC5E1A5),
                  color: Colors.lightGreen,
                  colorBrightness: Brightness.dark,
                  child: new Text(
                    "登录",
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0)),
                  onPressed: value
                      ? () {
                          widget._login(_usernameController.text.trim(),
                              _passwordController.text.trim());
                        }
                      : null,
                );
              }),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
