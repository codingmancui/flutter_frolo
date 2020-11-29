import 'package:flutter/material.dart';
import 'package:frolo/utils/ui_gaps.dart';
import 'package:frolo/utils/utils.dart';

typedef Register = void Function(
    String username, String password, String repassword);

class RegisterWidget extends StatefulWidget {
  final Register _register;

  const RegisterWidget(this._register);

  @override
  State<StatefulWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();
  final ValueNotifier<bool> _username = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _pwd = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _rpwd = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _clickable = ValueNotifier<bool>(false);

  @override
  void initState() {
    _usernameController.addListener(() {
      var length = _usernameController.text.trim().length;
      var pwdLength = _passwordController.text.trim().length;
      var repwdLength = _repasswordController.text.trim().length;
      _username.value = length > 0;
      if (length > 0 && pwdLength > 0 && repwdLength > 0) {
        _clickable.value = true;
      }
      if (length == 0 || pwdLength == 0 || repwdLength == 0) {
        _clickable.value = false;
      }
    });
    _passwordController.addListener(() {
      var length = _passwordController.text.trim().length;
      var nameLength = _usernameController.text.trim().length;
      var repwdLength = _repasswordController.text.trim().length;
      _pwd.value = length > 0;
      if (length > 0 && nameLength > 0 && repwdLength > 0) {
        _clickable.value = true;
      }
      if (length == 0 || nameLength == 0 || repwdLength == 0) {
        _clickable.value = false;
      }
    });
    _repasswordController.addListener(() {
      var length = _passwordController.text.trim().length;
      var nameLength = _usernameController.text.trim().length;
      var repwdLength = _repasswordController.text.trim().length;
      _rpwd.value = repwdLength > 0;
      if (length > 0 && nameLength > 0 && repwdLength > 0) {
        _clickable.value = true;
      }
      if (length == 0 || nameLength == 0 || repwdLength == 0) {
        _clickable.value = false;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Column(
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
              new TextField(
                controller: _passwordController,
                maxLines: 1,
                obscureText: true,
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
              ),
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
                    ],
                  ))
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
              new TextField(
                controller: _repasswordController,
                maxLines: 1,
                obscureText: true,
                decoration: new InputDecoration(
                    hintText: '请再次输入密码',
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
                  child: new Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ValueListenableBuilder(
                          valueListenable: _rpwd,
                          builder:
                              (BuildContext context, bool value, Widget child) {
                            return new Offstage(
                              child: new InkWell(
                                onTap: () {
                                  _repasswordController.clear();
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
                    ],
                  ))
            ],
          ),
        ),
        Gaps.getVGap(80),
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
                    "注册",
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0)),
                  onPressed: value
                      ? () {
                          widget._register(
                              _usernameController.text.trim(),
                              _passwordController.text.trim(),
                              _repasswordController.text.trim());
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
}
