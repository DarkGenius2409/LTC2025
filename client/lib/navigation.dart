import 'package:client/BrowsePage.dart';
import 'package:client/HomePage.dart';
import 'package:client/LibraryPage.dart';
import 'package:client/PreferenceQuizPage.dart';
import 'package:client/ProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Stream<DocumentSnapshot> checkNewUser() async* {
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference userPreferences =
        FirebaseFirestore.instance.collection("userPreferences");
    yield* userPreferences.doc(user!.email).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: checkNewUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool newUser = !snapshot.data!.exists;
            return newUser
                ? PreferenceQuizPage()
                : Scaffold(
                    bottomNavigationBar: NavigationBar(
                      labelBehavior:
                          NavigationDestinationLabelBehavior.onlyShowSelected,
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
                        // NavigationDestination(
                        //   icon: Icon(CupertinoIcons.flame),
                        //   selectedIcon: Icon(CupertinoIcons.flame_fill),
                        //   label: 'Trending',
                        // ),
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
                      // const TrendingPage(),

                      /// Browse page
                      const BrowsePage(),
                      const LibraryPage(),
                      const ProfilePage(),
                    ][currentPageIndex],
                  );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
