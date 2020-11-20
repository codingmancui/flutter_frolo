import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/system_bloc.dart';
import 'package:frolo/ui/widgets/system_tab_widget.dart';
import 'package:frolo/utils/ui_gaps.dart';
import 'package:frolo/utils/utils.dart';

class SystemPage extends StatelessWidget {
  final List<String> titles = ['体系', '导航'];

  @override
  Widget build(BuildContext context) {
    final List<BlocProvider> children = titles.map((String model) {
      return new BlocProvider(child: SystemTabWidget(), bloc: SystemBloc());
    }).toList();
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        brightness: Brightness.dark,
        toolbarHeight: 0,
      ),
      body: new DefaultTabController(
          length: titles.length,
          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Gaps.vGap5,
                new Container(
                    width: double.infinity,
                    child: new TabBar(
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelPadding: EdgeInsets.only(
                          top: 0, bottom: 0, left: 10, right: 10),
                      // indicatorPadding: EdgeInsets.only(bottom: 10),
                      labelColor: Colors.lightGreen,
                      unselectedLabelColor: Color(0xFF4c4c4c),
                      unselectedLabelStyle: TextStyle(fontSize: 15),
                      labelStyle: new TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                      indicatorWeight: 2.0,
                      tabs: titles
                          .map((String title) => new Tab(text: title))
                          ?.toList(),
                    )),
                new Container(
                  color: Colors.grey[300],
                  height: 0.5,
                ),
                new Expanded(child: new TabBarView(children: children))
              ])),
    );
  }
}
