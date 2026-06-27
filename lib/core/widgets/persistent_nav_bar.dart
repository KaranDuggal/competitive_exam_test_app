import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'package:exam_jyoti/screens/home_screen.dart';
import 'package:exam_jyoti/screens/points_screen.dart';
import 'package:exam_jyoti/screens/profile_screen.dart';

import '../../screens/leaderboard_screen.dart';

class PersistentNavBar extends StatelessWidget {
  const PersistentNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PersistentTabView(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      tabs: [
        PersistentTabConfig(
          screen: const HomeScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.home),
            title: 'Home',
            activeForegroundColor: Colors.blue,
            inactiveForegroundColor: Colors.grey,
          ),
        ),

        PersistentTabConfig(
          screen: const LeaderboardScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.leaderboard),
            title: 'Leaderboard',
            activeForegroundColor: Colors.blue,
            inactiveForegroundColor: Colors.grey,
          ),
        ),

        PersistentTabConfig(
          screen: const PointsScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.stars),
            title: 'Points',
            activeForegroundColor: Colors.blue,
            inactiveForegroundColor: Colors.grey,
          ),
        ),

        PersistentTabConfig(
          screen: const ProfileScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.person),
            title: 'Profile',
            activeForegroundColor: Colors.blue,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
      ],

      navBarBuilder: (navBarConfig) => Style2BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(0),
        ),
      ),
    );
  }
}