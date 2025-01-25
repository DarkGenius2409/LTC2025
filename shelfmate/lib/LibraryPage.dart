import 'package:shelfmate/book_grid_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  User? user = FirebaseAuth.instance.currentUser;
  late Query<Map<String, dynamic>> booksQuery;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    booksQuery = FirebaseFirestore.instance
        .collection("bookshelves/${user!.email}/books")
        .orderBy("title");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Shelf"),
          backgroundColor: ThemeData().primaryColor,
          foregroundColor: Colors.white,
        ),
        body: FirestoreQueryBuilder<Map<String, dynamic>>(
            query: booksQuery,
            builder: (context, snapshot, _) {
              if (snapshot.isFetching) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("Something went wrong! ${snapshot.error}"),
                );
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15),
                itemCount: snapshot.docs.length,
                itemBuilder: (context, index) {
                  if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                    snapshot.fetchMore();
                  }
                  final book = snapshot.docs[index].data();
                  return BookGridItem(
                    title: book["title"],
                    cover: book["cover"] ?? "",
                    authors: book["authors"],
                    bookID: book["bookID"],
                  );
                },
              );
            }));
  }
}
