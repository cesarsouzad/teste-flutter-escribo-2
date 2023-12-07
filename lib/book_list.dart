import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:teste2/books.dart';
import 'package:http/http.dart' as http;
import 'package:teste2/favorite_book.dart';

class BookList extends StatefulWidget {
  const BookList({Key? key}) : super(key: key);

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  late List<Book> books = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('https://escribo.com/books.json'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          books = data.map((json) => Book.fromJson(json)).toList();
        });
        print(data);
      } else {
        throw Exception('Falha ao carregar o livro');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Livros'),
      ),
      body: Stack(
        children: [
          books.isNotEmpty
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    return buildBookCard(books[index]);
                  },
                )
              : Center(child: CircularProgressIndicator()),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.redAccent.shade400,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoritesScreen(
                          favoriteBooks:
                              books.where((book) => book.isFavorite).toList(),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Favoritos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBookCard(Book book) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Card(
        elevation: 5.0,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 300.0,
              child: Image.network(
                book.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              color: Color.fromARGB(150, 203, 203, 203),
              height: 140.0,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      book.title,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Autor: ${book.author}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Color.fromARGB(200, 100, 100, 100),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: IconButton(
                icon: Icon(
                  book.isFavorite ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  // Alternar o status do favorito ao clicar no ícone
                  setState(() {
                    book.isFavorite = !book.isFavorite;
                  });
                },
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 70, 70, 70),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  print('Baixar ${book.downloadUrl}');
                },
                child: Text(
                  'Baixar',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
