import 'package:client/PreferenceQuizPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        backgroundColor: ThemeData().primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 48),
              child: Text(
                "User Profile",
                style: TextStyle(fontSize: 36),
              ),
            ),
            ElevatedButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: const Text("Sign Out"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PreferenceQuizPage()));
              },
              child: const Text("Change Preferences"),
            ),
            ElevatedButton(
              onPressed: () {
                CollectionReference userHistory = FirebaseFirestore.instance
                    .collection('userHistory/${user!.email}/history');
                userHistory.get().then((QuerySnapshot querySnapshot) {
                  for (var i = 0; i < querySnapshot.docs.length; i++) {
                    final doc = querySnapshot.docs[i];
                    // if (i != 0) {
                    //   doc.reference.delete();
                    // }
                    doc.reference.delete();
                  }
                });
                CollectionReference userShelf = FirebaseFirestore.instance
                    .collection('bookshelves/${user!.email}/books');
                userShelf.get().then((QuerySnapshot querySnapshot) {
                  for (var i = 0; i < querySnapshot.docs.length; i++) {
                    final doc = querySnapshot.docs[i];
                    // if (i != 0) {
                    //   doc.reference.delete();
                    // }
                    doc.reference.delete();
                  }
                });
              },
              child: const Text("Clear History"),
            )
          ],
        ),
      ),
    );
  }
}
