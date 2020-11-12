import 'package:flutter/material.dart';
import 'package:frolo/ui/page/home_page.dart';
import 'package:frolo/ui/page/me_page.dart';
import 'package:frolo/ui/page/rec_hot_page.dart';
import 'package:frolo/ui/page/repos_page.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomNavigationBarState();
  }
}

class _BottomNavigationBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  List<Widget> _bottomNavPages = List();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _bottomNavPages
      ..add(HomePage())
      ..add(RecHotPage())
      ..add(ReposPage())
      ..add(MePage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _bottomNavPages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('主页')),
          BottomNavigationBarItem(
              icon: Icon(Icons.description_sharp), title: Text('项目')),
          BottomNavigationBarItem(icon: Icon(Icons.message), title: Text('推荐')),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('我')),
        ],
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          _onItemTapped(index);
        },
        currentIndex: _selectedIndex,
        //当前页面索引,高亮
        selectedItemColor: Colors.green,
        unselectedFontSize: 11,
        selectedFontSize: 11,
      ),
    );
  }
}
