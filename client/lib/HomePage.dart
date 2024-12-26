import 'dart:convert';

import 'package:client/book.dart';
import 'package:client/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Book>> futureBooks;
  List<Book> books = [];
  List<BookCard> bookCards = [
    const BookCard(
      title: "Title 1",
      authors: ["Author 1"],
      pages: 500,
    ),
    const BookCard(
      title: "Title 2",
      authors: ["Author 2"],
      pages: 150,
    ),
    const BookCard(
      title: "Title 3",
      authors: ["Author 3"],
      pages: 375,
    )
  ];
  Future<List<Book>> fetchBooks(int num) async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:5001/ltc2025-81ee7/us-central1/books/1-$num'));
    if (response.statusCode == 200) {
      final jsonresponse = json.decode(response.body);
      List<Book> books = [];
      for (int i = 0; i < jsonresponse.length; i++) {
        final currentBook = jsonresponse[i] as Map<String, dynamic>;
        books.add(Book(
            id: currentBook['id'],
            authors: currentBook['authors'],
            title: currentBook["title"],
            description: currentBook['description'],
            pageCount: currentBook["pageCount"],
            cover: currentBook['cover'],
            link: currentBook['link']));
      }
      return books;
    } else {
      throw Exception('Failed to fetch books');
    }
  }

  @override
  void initState() {
    super.initState();
    futureBooks = fetchBooks(5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App"),
      ),
      body: FutureBuilder(
          future: futureBooks,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              books = snapshot.data!;
              return CardSwiper(
                cardBuilder:
                    (context, index, percentThresholdX, percentThresholdY) =>
                        BookCard(
                  title: books[index].title,
                  authors: books[index].authors,
                  pages: books[index].pageCount,
                  cover: books[index].cover,
                ),
                cardsCount: books.length,
                allowedSwipeDirection: const AllowedSwipeDirection.only(
                    up: true, left: true, right: true),
                onSwipe: ((previousIndex, currentIndex, direction) async {
                  // books.add((await fetchBooks(1))[0]);
                  return true;
                }),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          }),
    );
  }
}
