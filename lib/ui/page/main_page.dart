import 'package:flutter/material.dart';
import 'package:frolo/blocs/bloc_provider.dart';
import 'package:frolo/blocs/main_bloc.dart';
import 'package:frolo/blocs/tab_bloc.dart';
import 'package:frolo/ui/page/home_page.dart';
import 'package:frolo/ui/page/me_page.dart';
import 'package:frolo/ui/page/system_page.dart';
import 'package:frolo/ui/page/project_page.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<Widget> _bottomNavPages = List();

  @override
  void initState() {
    _bottomNavPages
      ..add(BlocProvider(child: HomePage(), bloc: MainBloc()))
      ..add(BlocProvider(child: ProjectPage(), bloc: TabBloc()))
      ..add(SystemPage())
      ..add(MePage());
    super.initState();
  }

  var _pageController = PageController();

  void onTabTapped(int index) {
    _pageController.jumpToPage(index);
  }

  void _pageChanged(int index) {
    setState(() {
      if (_selectedIndex != index) _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: _pageChanged,
          itemCount: _bottomNavPages.length,
          itemBuilder: (context, index) => _bottomNavPages[index]),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('主页')),
          BottomNavigationBarItem(
              icon: Icon(Icons.my_library_books), title: Text('项目')),
          BottomNavigationBarItem(icon: Icon(Icons.reorder), title: Text('体系')),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('我')),
        ],
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          onTabTapped(index);
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
