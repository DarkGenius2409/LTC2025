class Book {
  final String bookID;
  final List<dynamic>? authors;
  final String title;
  final String? description;
  final int? pageCount;
  final String? cover;
  final String? link;

  const Book({
    required this.bookID,
    required this.title,
    required this.authors,
    required this.cover,
    required this.description,
    required this.link,
    required this.pageCount,
  });

  String authorString() {
    String output = "";
    for (int i = 0; i < authors!.length; i++) {
      output += authors![i] as String;
    }
    return output;
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'bookID': String bookID,
        'authors': List<dynamic> authors,
        'title': String title,
        'description': String description,
        'pageCount': int pageCount,
        'cover': String cover,
        'link': String link
      } =>
        Book(
            bookID: bookID,
            title: title,
            authors: authors,
            description: description,
            pageCount: pageCount,
            cover: cover,
            link: link),
      _ => throw const FormatException('Failed to load book'),
    };
  }
}
