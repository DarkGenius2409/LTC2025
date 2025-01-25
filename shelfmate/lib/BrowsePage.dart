import 'package:shelfmate/category_card.dart';
import 'package:shelfmate/search_results.dart';
import 'package:flutter/material.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key});

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  final List<String> categories = [
    "Fantasy",
    "Science Fiction",
    "Historical",
    "Romance",
    "Thriller",
    "Drama",
    "Mystery"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Browse"),
        backgroundColor: ThemeData().primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 25, left: 15, right: 15),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Search"),
              onSubmitted: (value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchResults(search: value)));
              },
            ),
            SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.65,
                child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoryCard(category: categories[index]);
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
