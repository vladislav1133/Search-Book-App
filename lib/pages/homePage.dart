import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {Navigator.pushNamed(context, '/search');}),
          IconButton(icon: Icon(Icons.collections), onPressed: () {Navigator.pushNamed(context, '/collection');})
        ],
      ),
      body: Center(
        child: Text("Its Home Page My Lord"),
      ),
    );
  }
}