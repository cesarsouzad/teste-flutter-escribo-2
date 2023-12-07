import 'package:flutter/material.dart';
import 'package:teste2/books.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Book> favoriteBooks;

  const FavoritesScreen({Key? key, required this.favoriteBooks})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livros Favoritos'),
      ),
      body: favoriteBooks.isNotEmpty
          ? ListView.builder(
              itemCount: favoriteBooks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(favoriteBooks[index].title),
                  subtitle: Text(favoriteBooks[index].author),
                );
              },
            )
          : Center(
              child: Text('Nenhum livro favorito'),
            ),
    );
  }
}
