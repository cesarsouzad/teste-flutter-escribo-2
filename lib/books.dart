class Book {
  final int id;
  final String title;
  final String author;
  final String imageUrl;
  final String downloadUrl;
  bool isFavorite; // Novo campo para indicar se o livro é favorito

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.downloadUrl,
    this.isFavorite = false, // Padrão: não é favorito
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      imageUrl: json['cover_url'] ?? '',
      downloadUrl: json['download_url'] ?? '',
    );
  }
}
