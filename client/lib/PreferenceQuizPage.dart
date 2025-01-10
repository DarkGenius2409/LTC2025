import 'package:client/navigation.dart';
import 'package:client/preference_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PreferenceQuizPage extends StatefulWidget {
  const PreferenceQuizPage({super.key});

  @override
  State<PreferenceQuizPage> createState() => _PreferenceQuizPageState();
}

class _PreferenceQuizPageState extends State<PreferenceQuizPage> {
  final List<String> categories = [
    "Fantasy",
    "Science Fiction",
    "Historical",
    "Romance",
    "Thriller",
    "Drama",
    "Mystery"
  ];
  List<String> selectedCategories = [];

  void updatePreferences(List<String> categories) async {
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference userPreferences =
        FirebaseFirestore.instance.collection("userPreferences");
    await userPreferences.doc(user!.email).set({"genres": categories});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Please select at least one of the following genres",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return SizedBox.expand(
                          child: PreferenceCard(
                            category: categories[index],
                            onTap: () {
                              selectedCategories.add(categories[index]);
                            },
                          ),
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (selectedCategories.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text("Please select at least one genre to continue")));
            } else {
              updatePreferences(selectedCategories);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Navigation()));
            }
          },
          label: Text("Continue")),
    );
  }
}
