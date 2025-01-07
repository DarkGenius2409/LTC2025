import 'dart:convert';

import 'package:client/book.dart';
import 'package:client/book_display.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchResults extends StatefulWidget {
  final String? subject;
  final String? search;
  const SearchResults({super.key, this.subject, this.search});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final int _pageSize = 10;
  final dio = Dio();
  final PagingController<int, Book> _pagingController =
      PagingController<int, Book>(firstPageKey: 0);

  Future<List<Book>> fetchBooks(int pageKey) async {
    String endpoint;
    if (widget.subject != null) {
      endpoint =
          'http://10.0.2.2:8000/search/subject/${widget.subject}-${pageKey * _pageSize}-$_pageSize';
      debugPrint(endpoint);
    } else if (widget.search != null) {
      endpoint =
          'http://10.0.2.2:8000/search/${widget.search}-${pageKey * _pageSize}-$_pageSize';
    } else {
      throw Exception("Invalid Search");
    }
    debugPrint(endpoint);

    final response = await http.get(Uri.parse(endpoint));
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
      }
      return books;
    } else {
      throw Exception(response.statusCode);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      fetchBooks(pageKey).then((items) {
        _pagingController.appendPage(items, pageKey + 1);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Searching for ${widget.subject ?? widget.search}"),
      ),
      body: PagedListView<int, Book>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Book>(
              itemBuilder: (context, book, index) => ListTile(
                    title: Text(book.title),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BookDisplay(bookID: book.bookID)));
                    },
                  ))),
    );
  }
}
