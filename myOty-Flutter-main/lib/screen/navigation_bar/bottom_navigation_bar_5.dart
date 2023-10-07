import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:myoty/main.dart';
import 'package:myoty/screen/navigation_bar/first_tab/map_page/map_page.dart';
import 'package:myoty/screen/navigation_bar/second_tab/statistic_page.dart';
import 'package:myoty/screen/navigation_bar/third_tab/settings_page.dart';
import 'package:myoty/services/shared_pref_manager.dart';
import 'package:myoty/utils/extension.dart';

class BotNavBar extends StatefulWidget {
  const BotNavBar({super.key});

  @override
  State<BotNavBar> createState() => _BotNavBarState();
}

class _BotNavBarState extends State<BotNavBar> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  void changePage(int index) {
    setState(() {
      _pageController.jumpToPage(index);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (SharedPrefs.networkColor != null) {
        final p = HexColor.fromHex(SharedPrefs.networkColor!);
        ThemeProvider.of(context).updateTheme(p);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const tabPages = [
      MapPage(),
      StatisticsPage(),
      SettingsPage(),
    ];
    const tabIcons = [
      //BottomNavigationBarItem(icon: icon)
      Icon(
        Icons.location_on,
        size: 30,
        color: Colors.white,
      ),
      Icon(
        Icons.pie_chart,
        size: 30,
        color: Colors.white,
      ),
      Icon(
        Icons.settings,
        size: 30,
        color: Colors.white,
      ),
    ];
    assert(tabIcons.length == tabPages.length, "Number of tab icons != pages");

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        animationDuration: const Duration(milliseconds: 300),
        buttonBackgroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.white,
        color: Theme.of(context).colorScheme.primary,
        items: tabIcons,
        onTap: changePage,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: tabPages,
      ),
    );
  }
}
