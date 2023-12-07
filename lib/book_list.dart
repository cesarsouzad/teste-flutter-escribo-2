import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:teste2/books.dart';
import 'package:http/http.dart' as http;

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
      body: books.isNotEmpty
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
    );
  }

  Widget buildBookCard(Book book) {
    return Card(
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
            width: double.infinity, // Altura fixa para a parte superior do card
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
                print('Baixar ${book.downUrl}');
              },
              child: Text(
                'Baixar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
