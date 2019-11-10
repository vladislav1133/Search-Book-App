import 'package:flutter/material.dart';
import '../data/repository.dart';
import 'bookNotesPage.dart';
import '../models/Book.dart';
import '../utils/utils.dart';
import '../widgets/BookCard.dart';

class CollectionPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<Book> _items = List();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    Repository.get().getFavoriteBooks().then((books) {
      setState(() {
        _items = books;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Collection')),
        body: Container(
          padding: EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              _isLoading ? CircularProgressIndicator() : Container(),
              ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: _items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return BookCard(
                        book: _items[index],
                        onCardClick: () {
                          Navigator.of(context).push(
                              FadeRoute(
                                  builder: (BuildContext context) => new BookNotesPage(_items[index]),
                                  settings: new RouteSettings(name: '/notes', isInitialRoute: false)
                              )
                          );
                        },
                        onStarClick: () {
                          setState(() {
                            _items[index].starred = !_items[index].starred;
                          });
                          Repository.get().updateBook(_items[index]);
                        });
                  })
            ],
          ),
        ));
  }
}
