import 'package:flutter/material.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/system_detail_bloc.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/back_button.dart';
import 'package:frolo/ui/widgets/system_detail_tab_widget.dart';
import 'package:frolo/utils/utils.dart';

class SystemDetailPage extends StatelessWidget {
  final SystemModel model;

  const SystemDetailPage(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 48,
        elevation: 0,
        leading: BackButtonV2(color: Colors.white),
        title: Text(
          model.name,
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal),
        ),
      ),
      body: new DefaultTabController(
          initialIndex: 0,
          length: model.children.length,
          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Container(
                    height: 36,
                    color: Utils.createMaterialColor(Color(0xFF8BC34A)),
                    width: double.infinity,
                    child: new Center(
                      child: new TabBar(
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Colors.white,
                        indicator: const BoxDecoration(),
                        labelPadding: EdgeInsets.only(
                            top: 0, bottom: 0, left: 10, right: 10),
                        labelColor: Colors.white,
                        unselectedLabelColor: const Color(0xFFF2F2F2),
                        unselectedLabelStyle: const TextStyle(fontSize: 15),
                        labelStyle: new TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        tabs: model.children
                            .map((Children item) => new Tab(text: item.name))
                            ?.toList(),
                      ),
                    )),
                new Expanded(
                    child: new TabBarView(
                        children: model.children.map((item) {
                  return new BlocProvider(
                      child: SystemDetailTabWidget(item.id, item.name),
                      bloc: SystemDetailBloc());
                }).toList()))
              ])),
    );
  }
}
