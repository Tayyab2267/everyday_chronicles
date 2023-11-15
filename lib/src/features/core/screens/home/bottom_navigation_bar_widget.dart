import 'package:everyday_chronicles/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'home.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  final _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreen() {
    return [
      const Home(),
      //here Replace Text with widget and then save that widget to screens folder
      //Text("Home", style: Theme.of(context).textTheme.headlineLarge),
      Text("Chart", style: Theme.of(context).textTheme.headlineLarge),
      Text("Add", style: Theme.of(context).textTheme.headlineLarge),
      Text("Insight", style: Theme.of(context).textTheme.headlineLarge),
      Text("Setting", style: Theme.of(context).textTheme.headlineLarge)
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.home,
          //color: myWhiteColor,
        ),
        title: 'Home',
        inactiveColorPrimary: Colors.white,
        activeColorPrimary: Colors.greenAccent,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.calendar_month_outlined,
          //color: myWhiteColor,
        ),
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
        icon: const Icon(
          Icons.add_chart,
          //color: myWhiteColor,
        ),
        title: 'Insight',
        inactiveColorPrimary: Colors.white,
        activeColorPrimary: Colors.greenAccent,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.settings,
          //color: myWhiteColor,
        ),
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
        //body is not home screen it is bottom navigation bar
        body: PersistentTabView(
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
