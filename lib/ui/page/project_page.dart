import 'package:flutter/material.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/tab_bloc.dart';
import 'package:frolo/blocs/tab_list_bloc.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/project_item_list.dart';
import 'package:frolo/ui/widgets/loading/square_circle.dart';
import 'package:frolo/utils/ui_gaps.dart';
import 'package:frolo/utils/utils.dart';

class ProjectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with SingleTickerProviderStateMixin {
  TabBloc _bloc;
  bool _init = true;
  List<BlocProvider<TabListBloc>> _children = new List();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<TabBloc>(context);
    if (_init) {
      _init = false;
      _bloc.getProjectTree();
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (int i = 0, length = _children.length; i < length; i++) {
      _children[i].bloc.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        toolbarHeight: 0,
        elevation: 0.0,
        brightness: Brightness.dark,
      ),
      body: new StreamBuilder(
          stream: _bloc.tabTreeStream,
          builder:
              (BuildContext context, AsyncSnapshot<List<TreeModel>> snapshot) {
            if (snapshot.data == null) {
              return new SpinKitSquareCircle(
                  size: 24,
                  color: Colors.lime,
                  duration: Duration(milliseconds: 500));
            }
            _children = snapshot.data
                .map((TreeModel model) {
                  return new BlocProvider(
                      child: ProjectListWidget(cid: model.id),
                      bloc: TabListBloc());
                })
                .cast<BlocProvider<TabListBloc>>()
                .toList();
            return new DefaultTabController(
                length: snapshot.data == null ? 0 : snapshot.data.length,
                child: new Column(children: <Widget>[
                  new Material(
                    color: Utils.createMaterialColor(Color(0xFFFAFAFA)),
                    elevation: 0.0,
                    child: new Container(
                      color: Utils.createMaterialColor(Color(0xFF8BC34A)),
                      height: 48.0,
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: new TabBar(
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Colors.white,
                        labelPadding: EdgeInsets.only(
                            top: 0, bottom: 0, left: 10, right: 10),
                        indicatorPadding: EdgeInsets.only(bottom: 6),
                        labelColor: Colors.white,
                        unselectedLabelColor: Color(0xFFF2F2F2),
                        unselectedLabelStyle: TextStyle(fontSize: 15),
                        labelStyle: new TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        indicatorWeight: 2.0,
                        tabs: snapshot.data
                            ?.map(
                                (TreeModel model) => new Tab(text: model.name))
                            ?.toList(),
                      ),
                    ),
                  ),
                  new Expanded(child: new TabBarView(children: _children))
                ]));
          }),
    );
  }
}
