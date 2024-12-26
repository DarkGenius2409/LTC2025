import 'package:client/BrowsePage.dart';
import 'package:client/HomePage.dart';
import 'package:client/Library.dart';
import 'package:client/TrendingPage.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.flame),
            selectedIcon: Icon(CupertinoIcons.flame_fill),
            label: 'Trending',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.compass),
            selectedIcon: Icon(CupertinoIcons.compass_fill),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.book),
            selectedIcon: Icon(CupertinoIcons.book_fill),
            label: 'Shelf',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        const HomePage(),

        /// Trending page
        const TrendingPage(),

        /// Browse page
        const BrowsePage(),
        const LibraryPage(),
        ProfileScreen(
          actions: [
            SignedOutAction(
              (context) {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ][currentPageIndex],
    );
  }
}
