import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String title;
  final List<dynamic> authors;
  final int pages;
  final String? cover;

  const BookCard(
      {super.key,
      required this.title,
      required this.authors,
      required this.pages,
      this.cover});

  String listToString(List<dynamic> list) {
    String output = "";
    for (int i = 0; i < list.length; i++) {
      output += list[i] as String;
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: SizedBox.expand(
          child: Stack(
        children: [
          SizedBox.expand(child: Image.network(cover!)),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 22.5),
                  ),
                  Text(
                    listToString(authors),
                    style: const TextStyle(fontSize: 17.5),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "$pages pages",
                      style: const TextStyle(
                          fontSize: 17.5, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
