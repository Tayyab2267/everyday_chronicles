import 'package:everyday_chronicles/src/constants/colors.dart';
import 'package:everyday_chronicles/src/features/core/screens/home/home.dart';
import 'package:everyday_chronicles/src/features/core/screens/insight/insight_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../calender/calender_screen.dart';
import '../setting/setting_screen.dart';
import 'home_add_screen.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  final _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreen() {
    return [
      const Home(),
      const CalenderScreen(),
      const HomeAddScreen(),
      const InsightScreen(),
      const SettingScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: 'Home',
        inactiveColorPrimary: Colors.white,
        activeColorPrimary: Colors.greenAccent,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.calendar_month_outlined),
        title: 'Calender',
        inactiveColorPrimary: Colors.white,
        activeColorPrimary: Colors.greenAccent,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.cancel,
          color: Colors.greenAccent,
          size: 40.0,
        ),
        inactiveIcon: const Icon(
          Icons.add_box_rounded,
          color: Colors.white,
          size: 40.0,
        ),
        //title: 'Add',
        activeColorPrimary: myBackgroundDark2Color,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.add_chart),
        title: 'Insights',
        inactiveColorPrimary: Colors.white,
        activeColorPrimary: Colors.greenAccent,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings),
        title: 'Setting',
        inactiveColorPrimary: Colors.white,
        activeColorPrimary: Colors.greenAccent,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PersistentTabView(
          resizeToAvoidBottomInset: true,
          context,
          screens: _buildScreen(),
          items: _navBarItems(),
          controller: _controller,
          backgroundColor: myBackgroundDarkColor,
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          navBarHeight: 70.0,
          navBarStyle: NavBarStyle.style15,
        ),
      ),
    );
  }
}
