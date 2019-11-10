import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/Book.dart';

class BookDatabase {
  // Create singleton instance
  static final BookDatabase _bookDatabase = new BookDatabase._internal();

  final String tableName = "Books";

  Database db;

  bool didInit = false;

  static BookDatabase get() {
    return _bookDatabase;
  }

  BookDatabase._internal();

  /// Use this method to access the database, because initialization of the database (it has to go through the method channel)
  Future<Database> _getDb() async {
    if(!didInit) await _init();
    return db;
  }


  Future _init() async {
    // Get location thru path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "book.db");
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute("CREATE TABLE $tableName ("
          "${Book.dbId} STRING PRIMARY KEY,"
          "${Book.dbTitle} TEXT,"
          "${Book.dbUrl} TEXT,"
          "${Book.dbStar} BIT,"
          "${Book.dbNotes} TEXT"
          ")");
    });

    didInit = true;
  }

  // Get a book by id
//  Future<Book> getBook(String id) async {
//
//    print('----------------------------------------');
//    print ('BEFORE QUERY DB');
//    print(db);
//    var result = await db
//        .rawQuery('SELECT * FROM $tableName WHERE ${Book.dbId} = "$id"');
//
//    if (result.length == 0) return null;
//
//    return new Book.fromMap(result[0]);
//  }

  // Get all books with ids, will return a list with all the books found
  Future<List<Book>> getBooks(List<String> ids) async {
    var db = await _getDb();
    // Building SELECT * FROM TABLE WHERE ID IN (id1, id2...)
    List<Book> books = [];
    var idsString = ids.map((it) => '"$it"').join(',');
    var result = await db.rawQuery('SELECT * FROM $tableName WHERE ${Book.dbId} IN  ($idsString)');

    for(Map<String, dynamic> item in result) {
      books.add(new Book.fromMap(item));
    }

    return books;
  }

  Future<List<Book>> getFavoriteBooks() async {
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM $tableName WHERE ${Book.dbStar} = "1"');
    if(result.length == 0) return [];
    List<Book> books = [];

    for(Map<String, dynamic> map in result) {
      books.add(new Book.fromMap(map));
    }

    return books;
  }

  // Inserts or replace the book
  Future updateBook(Book book) async {
    var db = await _getDb();

    await db.transaction((txn) async {

      await txn.rawInsert('INSERT OR REPLACE INTO '
          '$tableName(${Book.dbId}, ${Book.dbTitle}, ${Book.dbUrl},  ${Book.dbStar}, ${Book.dbNotes})'
          ' VALUES(?, ?, ?, ?, ?)',
          [book.id, book.title, book.url, book.starred, book.notes]);
    });
  }

  Future close() async {
    var db = await _getDb();
    return db.close();
  }
}
