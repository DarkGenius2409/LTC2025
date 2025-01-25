import 'package:shelfmate/book_display.dart';
import 'package:flutter/material.dart';

class BookGridItem extends StatelessWidget {
  final String title;
  final String cover;
  final List<dynamic> authors;
  final String bookID;
  const BookGridItem(
      {super.key,
      required this.title,
      required this.cover,
      required this.authors,
      required this.bookID});

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
            debugPrint(bookID);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookDisplay(bookID: bookID)));
          },
          child: SizedBox.expand(
              child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (cover != "")
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 9,
                      child: Image.network(cover, fit: BoxFit.fill),
                    ),
                  ),
                Flexible(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Flexible(
                  child: Text(
                    listToString(authors),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ))),
    );
  }
}
