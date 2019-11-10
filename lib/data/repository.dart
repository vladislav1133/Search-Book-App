import 'dart:async';
import 'dart:convert';

import 'package:book_app/data/datatabase.dart';
import 'package:book_app/models/Book.dart';
import 'package:http/http.dart' as http;

import 'datatabase.dart';
import '../models/Book.dart';

const int NO_INTERNET = 404;

class ParsedResponse<T> {
  ParsedResponse(this.statusCode, this.body);

  final int statusCode;
  final T body;


  bool isOk() {
    return statusCode >= 200 && statusCode < 300;
  }
}

class Repository {

  static final Repository _repo = new Repository._internal();

  BookDatabase database;

  static Repository get() {
    return _repo;
  }

  Repository._internal() {
    database = BookDatabase.get();
  }

  /// Fetches the books from the Google Books Api with the query parameter being input.
  /// If a book also exists in the local storage (eg. a book with notes/ stars) that version of the book will be used instead

  Future<ParsedResponse<List<Book>>> getBooks(String input) async {
    //http request, catching error like no internet connection.
    //If no internet is available for example response is
    http.Response response = await http.get("https://www.googleapis.com/books/v1/volumes?q=$input")
        .catchError((resp) {});

    if(response == null) {
      return new ParsedResponse(NO_INTERNET, []);
    }

    //If there was an error return an empty list
    if(response.statusCode < 200 && response.statusCode >= 300) {
      return new ParsedResponse(response.statusCode, []);
    }

    // Decode and go to the items part where the necessary book information is
    List<dynamic> list = json.decode(response.body)['items'];

    Map<String, Book> networkBooks = {};

    for(dynamic jsonBook in list) {

      String url = 'https://via.placeholder.com/120x180';
      if(jsonBook['volumeInfo']['imageLinks'] != null) {
        url = jsonBook['volumeInfo']['imageLinks']['smallThumbnail'];
      }
      Book book = new Book(
        title: jsonBook['volumeInfo']['title'],
        url: url,
        id: jsonBook['id']
      );

      networkBooks[book.id] = book;
    }

    //print([]..addAll(networkBooks.keys));

    List<Book> databaseBook = await database.getBooks([]..addAll(networkBooks.keys));

    for(Book book in databaseBook) {
      networkBooks[book.id] = book;
    }

    return new ParsedResponse(response.statusCode, []..addAll(networkBooks.values));
  }

  Future updateBook(Book book) async {
    database.updateBook(book);
  }

  Future<List<Book>> getFavoriteBooks() {
    return database.getFavoriteBooks();
  }

  Future close() async {
    return database.close();
  }
}