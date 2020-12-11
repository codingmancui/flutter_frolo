import 'package:flutter/material.dart';
import 'package:frolo/data/db/data_base_singleton.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/back_button.dart';

class HistoryPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>new _HistoryPageState();

}

class _HistoryPageState extends State<HistoryPage>{
  @override
  void initState() {
    var articleDao =  DatabaseSingleton.instance.getArticleDao();
    Future<List<Article>> data= articleDao.findAllArticles();
    data.then((value) {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
      brightness: Brightness.dark,
      elevation: 0,
      toolbarHeight: 48,
      leading: BackButtonV2(color: Colors.white),
      centerTitle: true,
      title: Text(
        '历史',
        style: TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal),
      ),
    ),
    );
  }

}