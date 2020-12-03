import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frolo/utils/log_util.dart';
import 'package:frolo/utils/navigator_util.dart';
import 'package:frolo/utils/utils.dart';

class CoinHeaderWidget extends StatefulWidget {
  final int coins;

  const CoinHeaderWidget(this.coins);

  @override
  State<StatefulWidget> createState() => new _CoinHeaderWidget();
}

class _CoinHeaderWidget extends State<CoinHeaderWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<int> _animation;

  @override
  void initState() {
    _controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    _animation = new IntTween(begin: 0, end: widget.coins).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInSine));
    _animation.addListener(() {
      LogUtil.v('AnimationController value ${_animation.value}');
    });
    Future.delayed(new Duration(milliseconds: 250)).then((value) {
      _controller.forward();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return new Stack(
            children: <Widget>[
              new Container(
                alignment: Alignment.center,
                color: Colors.lightGreen,
                width: double.infinity,
                height: 180,
                child: new Text(
                  _animation.value.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold),
                ),
              ),
              new Align(
                alignment: Alignment.topRight,
                child: new Container(
                  margin: EdgeInsets.only(right: 20),
                  child: new InkWell(
                      onTap: () {
                        NavigatorUtil.pushWeb(context,
                            title: '积分规则',
                            url: 'https://www.wanandroid.com/blog/show/2653');
                      },
                      child: Image.asset(
                        Utils.getImgPath('ic_rule'),
                        width: 18,
                        height: 18,
                      )),
                ),
              ),
            ],
          );
        });
  }
}
