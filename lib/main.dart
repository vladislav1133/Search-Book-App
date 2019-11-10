import 'package:book_app/pages/collectionPage.dart';
import 'package:book_app/pages/homePage.dart';
import 'package:book_app/pages/searchBookPage.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book search',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        '/': (BuildContext context) => HomePage(),
        '/search': (BuildContext context) => SearchBookPage(),
        '/collection': (BuildContext context) => CollectionPage()
      }
    );
  }
}