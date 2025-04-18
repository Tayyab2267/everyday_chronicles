import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:everyday_chronicles/src/constants/colors.dart';
import 'package:everyday_chronicles/src/features/core/screens/home/home.dart';
import 'package:everyday_chronicles/src/features/core/screens/home/home_add_screen.dart';
import 'package:everyday_chronicles/src/features/core/screens/setting/setting_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  late PersistentTabController _controller;

  final List<Widget> _screens = [
    const Home(),
    const HomeAddScreen(),
    const SettingScreen(),
  ];

  final List<PersistentBottomNavBarItem> _navBarsItems = [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home),
      title: 'Home',
      activeColorPrimary: Colors.greenAccent,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(FontAwesomeIcons.pencil),
      title: 'Edit',
      activeColorPrimary: Colors.greenAccent,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.settings),
      title: 'Settings',
      activeColorPrimary: Colors.greenAccent,
      inactiveColorPrimary: Colors.grey,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _screens,
      items: _navBarsItems,
      navBarStyle: NavBarStyle.style6,
      backgroundColor: myBackgroundDarkColor,
      confineInSafeArea: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(20),
        colorBehindNavBar: Colors.black,
      ),
    );
  }
}
