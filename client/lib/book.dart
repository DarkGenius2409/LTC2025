class Book {
  final String id;
  final List<dynamic> authors;
  final String title;
  final String description;
  final int pageCount;
  final String cover;
  final String link;

  const Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.cover,
    required this.description,
    required this.link,
    required this.pageCount,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'authors': List<dynamic> authors,
        'title': String title,
        'description': String description,
        'pageCount': int pageCount,
        'cover': String cover,
        'link': String link
      } =>
        Book(
            id: id,
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
