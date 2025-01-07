import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class MainProvider extends ChangeNotifier {
  final PersistentTabController _controller = PersistentTabController();
  PersistentTabController get controller => _controller;

  int _selectedTab = 0;
  int get selectedTab => _selectedTab;

  void changeSelectedIndex(int index) {
    _selectedTab = index;
    notifyListeners();
  }
}
