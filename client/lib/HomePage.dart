import 'dart:convert';

import 'package:client/book.dart';
import 'package:client/book_card.dart';
import 'package:client/book_display.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int numBooks = 5;
  late Future<List<Book>> futureBooks;
  User? user = FirebaseAuth.instance.currentUser;
  int startIndex = 0;
  List<Book> books = [];
  CardSwiperController cardSwiperController = CardSwiperController();
  final dio = Dio();

  Future<List<Book>> fetchBooks(int num) async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8000/books/${user!.email}-$num'));
    if (response.statusCode == 200) {
      final jsonresponse = json.decode(response.body);
      List<Book> books = [];
      for (int i = 0; i < jsonresponse.length; i++) {
        final currentBook = jsonresponse[i] as Map<String, dynamic>;
        books.add(Book(
            bookID: currentBook['bookID'],
            authors: currentBook['authors'],
            title: currentBook["title"],
            description: currentBook['description'],
            pageCount: currentBook["pageCount"],
            cover: currentBook['cover'],
            link: currentBook['link']));
        print(books[i].title);
      }
      return books;
    } else {
      throw Exception('Failed to fetch books');
    }
  }

  Future<void> updateHistory(int index, CardSwiperDirection direction) async {
    bool like = false;
    bool dislike = false;
    bool superlike = false;
    String bookID = books[index].bookID;
    if (direction == CardSwiperDirection.right) {
      like = true;
    } else if (direction == CardSwiperDirection.left) {
      dislike = true;
    } else if (direction == CardSwiperDirection.top) {
      superlike = true;
    }
    Map<String, dynamic> bookHistory = {
      "like": like,
      "dislike": dislike,
      "superlike": superlike,
      "bookID": bookID
    };
    final response = await dio.post(
        'http://10.0.2.2:8000/updateHistory/${user!.email}',
        data: bookHistory);
  }

  @override
  void initState() {
    super.initState();
    futureBooks = fetchBooks(numBooks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App"),
        backgroundColor: ThemeData().primaryColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: futureBooks,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              books = snapshot.data!;
              return CardSwiper(
                cardBuilder:
                    (context, index, percentThresholdX, percentThresholdY) =>
                        GestureDetector(
                  onLongPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            BookDisplay(bookID: books[index].bookID)));
                  },
                  child: BookCard(
                    title: books[index].title,
                    authors: books[index].authors,
                    pages: books[index].pageCount,
                    cover: books[index].cover,
                  ),
                ),
                controller: cardSwiperController,
                cardsCount: books.length,
                allowedSwipeDirection: const AllowedSwipeDirection.only(
                    up: true, left: true, right: true),
                onSwipe: ((previousIndex, currentIndex, direction) async {
                  updateHistory(previousIndex, direction);
                  startIndex++;
                  if (startIndex % numBooks == 0 && startIndex != 0) {
                    books.clear();
                    books = await fetchBooks(numBooks);
                  }
                  // cardSwiperController.moveTo(previousIndex);
                  return true;
                }),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
