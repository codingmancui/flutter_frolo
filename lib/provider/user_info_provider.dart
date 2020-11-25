import 'package:flutter/material.dart';

class UserInfoProvider with ChangeNotifier {
  String _userName;
  String _email;
  String _icon;
  int _coinCount = 0;
  String _rank = '0';
  int _level = 0;

  String get userName => _userName;

  void setUserName(String name) {
    this._userName = name;
    notifyListeners();
  }

  int get coinCount => _coinCount;

  void setCoinCount(int coinCount) {
    this._coinCount = coinCount;
    notifyListeners();
  }

  String get rank => _rank;

  void setRank(String rank) {
    this._rank = rank;
    notifyListeners();
  }

  int get level => _level;

  void setLevel(int level) {
    this._level = level;
    notifyListeners();
  }
}
