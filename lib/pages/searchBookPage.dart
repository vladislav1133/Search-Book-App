import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../data/repository.dart';
import 'bookNotesPage.dart';
import '../models/Book.dart';
import '../utils/utils.dart';
import '../widgets/BookCard.dart';

class SearchBookPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _SearchBookState();
}

class _SearchBookState extends State<SearchBookPage> {

  List<Book> _items = new List();

  final subject = new PublishSubject();

  bool _isLoading = false;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  void _textChanged(dynamic text) {
    if(text.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      _clearList();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _clearList();
    Repository.get().getBooks(text)
    .then((books) {
      setState(() {
       _isLoading = false;
       if(books.isOk()) {
         _items = books.body;
       } else {
         scaffoldKey.currentState.showSnackBar(
             new SnackBar(
                 content: new Text('Something went wrong, check your internet connection')
             )
         );
       }
      });
    });
  }

  void _clearList() {
    setState(() {
      _items.clear();
    });
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    subject.stream
        .debounce((_) => TimerStream(true, const Duration(milliseconds: 600)))
    .listen(_textChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Book Search')
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: 'Choose a book'
              ),
              onChanged: (string) => (subject.add(string)),
            ),
            _isLoading ? CircularProgressIndicator() : Container(),
            Expanded(
              child: ListView.builder(
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
                    },
                  );
                  }
              ),
            )
          ],
        ),
      )
    );
  }
}