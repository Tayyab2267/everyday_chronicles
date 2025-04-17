import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:everyday_chronicles/src/constants/colors.dart';
import 'package:everyday_chronicles/src/features/core/screens/home/home.dart';
import 'package:everyday_chronicles/src/features/core/screens/home/home_add_screen.dart';
import 'package:everyday_chronicles/src/features/core/screens/setting/setting_screen.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  late final List<Widget> _screens;
  late final List<PersistentBottomNavBarItem> _navBarsItems;

  @override
  void initState() {
    super.initState();

    _screens = [
      const Home(),
      const HomeAddScreen(),
      const SettingScreen(),
    ];

    _navBarsItems = [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: 'Home',
        activeColorPrimary: Colors.greenAccent,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(FontAwesomeIcons.pencil),
        title: 'Edit',
        activeColorPrimary: Colors.greenAccent,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings),
        title: 'Settings',
        activeColorPrimary: Colors.greenAccent,
        inactiveColorPrimary: Colors.white,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _screens,
      items: _navBarsItems,
      confineInSafeArea: true,
      backgroundColor: myBackgroundDarkColor,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(20),
        colorBehindNavBar: Colors.black,
      ),
      navBarStyle: NavBarStyle.style3, // You can change to style1, style2, etc.
    );
  }
}
