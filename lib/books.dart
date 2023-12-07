class Book {
  final String title;
  final String author;
  final String imageUrl;
  final String downUrl;

  Book(
      {required this.title,
      required this.author,
      required this.imageUrl,
      required this.downUrl});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
        title: json['title'] ?? '',
        author: json['author'] ?? '',
        imageUrl: json['cover_url'] ?? '',
        downUrl: json['download_url'] ?? '');
  }
}
