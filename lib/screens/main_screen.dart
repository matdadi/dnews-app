import 'package:deltanews/providers/main_provider.dart';
import 'package:deltanews/screens/category/category_screen.dart';
import 'package:deltanews/screens/home/home_screen.dart';
import 'package:deltanews/screens/recommendation/recommendation_screen.dart';
import 'package:deltanews/screens/watch/watch_screen.dart';
import 'package:deltanews/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<MainProvider>();

    return PersistentTabView(
      navBarHeight: 56,
      navBarBuilder: (navBarConfig) => Style7BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: const NavBarDecoration(
          color: primaryColor,
        ),
      ),
      tabs: [
        tabConfig(const HomeScreen(), 'icon_home.svg', 'Home'),
        tabConfig(const RecommendationScreen(), 'icon_recommendation.svg',
            'Rekomendasi'),
        tabConfig(const CategoryScreen(), 'icon_category.svg', 'Kategori'),
        tabConfig(const WatchScreen(), 'icon_watch.svg', 'Watch'),
      ],
      resizeToAvoidBottomInset: false,
      controller: providerRead.controller,
      onTabChanged: (index) => providerRead.changeSelectedIndex(index),
    );
  }

  PersistentTabConfig tabConfig(Widget screen, String icon, String title) {
    return PersistentTabConfig(
        screen: screen,
        item: ItemConfig(
            icon: SvgPicture.asset('assets/icons/$icon'),
            title: title,
            activeForegroundColor: Colors.white,
            inactiveIcon: SvgPicture.asset('assets/icons/$icon',
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.srcIn))));
  }
}
