import 'package:shelfmate/search_results.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: InkWell(
          splashColor: ThemeData().primaryColor.withAlpha(30),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchResults(subject: category)));
          },
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 5,
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  category,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ))),
    );
  }
}
