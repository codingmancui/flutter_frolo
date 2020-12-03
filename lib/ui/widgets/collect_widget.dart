import 'package:flutter/material.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/page/login_page.dart';
import 'package:frolo/utils/collect_utils.dart';
import 'package:frolo/utils/navigator_util.dart';
import 'package:frolo/utils/utils.dart';

class CollectWidget extends StatefulWidget {
  final Article model;

  const CollectWidget(this.model);

  @override
  State<StatefulWidget> createState() => new CollectState();
}

class CollectState extends State<CollectWidget> {
  ValueNotifier _valueNotifier = new ValueNotifier(false);
  Article _model;

  @override
  Widget build(BuildContext context) {
    _model = widget.model;
    _valueNotifier.value = widget.model.collect;
    return ValueListenableBuilder(
        valueListenable: _valueNotifier,
        builder: (context, value, child) {
          return new InkWell(
            onTap: () {
              if (!Utils.isLogin()) {
                NavigatorUtil.pushPage(context, new LoginPage());
                return;
              }

              _model.collect
                  ? CollectUtils.unCollect(_model.id, (success) {
                      _setCollect(false);
                    })
                  : CollectUtils.doCollect(_model.id, (success) {
                      _setCollect(true);
                    });
            },
            child: new Icon(
              Icons.favorite_rounded,
              color: value ? Colors.red : Colors.grey[500],
              size: 20,
            ),
          );
        });
  }

  void _setCollect(bool collect) {
    _valueNotifier.value = collect;
    _model.collect = collect;
  }
}
