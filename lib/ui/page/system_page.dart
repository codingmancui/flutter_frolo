import 'package:flutter/material.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/system_bloc.dart';
import 'package:frolo/ui/widgets/system_tab_widget.dart';
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
                new Container(
                    height: 48,
                    color: Utils.createMaterialColor(Color(0xFF8BC34A)),
                    width: double.infinity,
                    child: new Center(
                      child: new TabBar(
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Colors.white,
                        labelPadding: EdgeInsets.only(
                            top: 0, bottom: 0, left: 10, right: 10),
                        indicatorPadding: EdgeInsets.only(bottom: 6),
                        labelColor: Colors.white,
                        unselectedLabelColor: const Color(0xFFF2F2F2),
                        unselectedLabelStyle: const TextStyle(fontSize: 15),
                        labelStyle: new TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        indicatorWeight: 2.0,
                        tabs: titles
                            .map((String title) => new Tab(text: title))
                            ?.toList(),
                      ),
                    )),
                new Expanded(child: new TabBarView(children: children))
              ])),
    );
  }
}
