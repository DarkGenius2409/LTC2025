import 'package:client/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BookDisplay extends StatefulWidget {
  final String bookID;
  const BookDisplay({super.key, required this.bookID});

  @override
  State<BookDisplay> createState() => _BookDisplayState();
}

class _BookDisplayState extends State<BookDisplay> {
  late Future<Book> futureBook;
  final dio = Dio();
  User? user = FirebaseAuth.instance.currentUser;
  bool inLibrary = false;
  late CollectionReference userShelf;

  Future<Book> fetchBook() async {
    final response =
        await dio.get('http://10.0.2.2:8000/books/${widget.bookID}');
    if (response.statusCode == 200) {
      return Book(
          bookID: response.data['bookID'],
          authors: response.data['authors'],
          title: response.data['title'],
          description: response.data['description'],
          pageCount: response.data['pageCount'],
          cover: response.data['cover'],
          link: response.data['link']);
    } else {
      throw Exception('Failed to fetch book');
    }
  }

  Future<void> updateHistory(bool like, bool superlike, String id) async {
    Map<String, dynamic> bookHistory = {
      "like": like,
      "dislike": !like && !superlike,
      "superlike": superlike,
      "bookID": id
    };
    final response = await dio.post(
        'https://shelfmate-api-f882711e4206.herokuapp.com/updateHistory/${user!.email}',
        data: bookHistory);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureBook = fetchBook();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureBook,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final book = snapshot.data!;
            userShelf = FirebaseFirestore.instance
                .collection("bookshelves/${user!.email}/books");
            userShelf
                .where("bookID", isEqualTo: book.bookID)
                .get()
                .then((QuerySnapshot querySnapshot) {
              inLibrary = querySnapshot.docs.isNotEmpty;
            });
            return Scaffold(
              appBar: AppBar(
                title: Text(book.title),
                backgroundColor: ThemeData().primaryColor,
                foregroundColor: Colors.white,
                actions: [
                  IconButton(
                      onPressed: () {
                        if (inLibrary) {
                          userShelf
                              .where("bookID", isEqualTo: book.bookID)
                              .get()
                              .then((QuerySnapshot querySnapshot) {
                            for (DocumentSnapshot doc in querySnapshot.docs) {
                              doc.reference.delete();
                            }
                          });
                        } else {
                          userShelf.add({
                            "title": book.title,
                            "authors": book.authors,
                            "id": book.bookID,
                            "description": book.description,
                            "pageCount": book.pageCount,
                            "link": book.link,
                            "cover": book.cover
                          });
                          updateHistory(false, true, book.bookID);
                        }
                        Navigator.pop(context);
                      },
                      icon: Icon(inLibrary ? Icons.add : Icons.delete))
                ],
              ),
              body: Padding(
                padding: EdgeInsets.all(25),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      (book.cover != null)
                          ? Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: SizedBox(
                                  width: MediaQuery.sizeOf(context).width,
                                  child: Image.network(
                                    book.cover!,
                                    fit: BoxFit.fill,
                                  )),
                            )
                          : Text("Cover Unavailable"),
                      Text(
                        book.title,
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "By: ${book.authorString()}",
                      ),
                      Text(
                        "${book.pageCount} pages",
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 10),
                        child: Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      Html(
                          data: book.description ??
                              "<h1>NO DESCRIPTION AVAILABLE</h1>"),
                      Center(
                          child: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: (book.link != null)
                            ? ElevatedButton(
                                onPressed: () {
                                  launchUrlString(book.link!);
                                },
                                child: Text("Go to Book"))
                            : Text("No Link Available"),
                      ))
                    ],
                  ),
                ),
              ),
              // floatingActionButton: Padding(
              //   padding: EdgeInsets.only(left: 35),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       FloatingActionButton(
              //         onPressed: () {
              //           updateHistory(false, false, book.id);
              //           Navigator.of(context).pop();
              //         },
              //         heroTag: "dislikeBtn",
              //         child: Icon(Icons.thumb_down),
              //       ),
              //       Expanded(child: Container()),
              //       FloatingActionButton(
              //           onPressed: () {
              //             updateHistory(true, false, book.bookID);
              //             Navigator.of(context).pop();
              //           },
              //           heroTag: "likeBtn",
              //           child: Icon(Icons.thumb_up)),
              //     ],
              //   ),
              // ),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
                body: Center(
              child: Text(snapshot.error.toString()),
            ));
          }
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        });
  }
}
