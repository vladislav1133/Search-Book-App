import 'package:flutter/material.dart';
import '../data/repository.dart';
import '../models/Book.dart';
import 'package:rxdart/rxdart.dart';

class BookNotesPage extends StatefulWidget {

  final Book book;

  BookNotesPage(this.book);

  @override
  State<StatefulWidget> createState() => new _BookNotesPageState();
}

class _BookNotesPageState extends State<BookNotesPage> {

  TextEditingController _textEditingController;

  final subject = new PublishSubject<String>();

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = new TextEditingController(text: widget.book.notes);
    subject.stream
        .debounce((_) => TimerStream(true, const Duration(milliseconds: 400)))
    .listen((text) {
      widget.book.notes = text;
      Repository.get().updateBook(widget.book);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Hero(
                child: Image.network(widget.book.url),
                tag: widget.book.id
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                        maxLines: null,
                        decoration: null,
                        controller: _textEditingController,
                        onChanged: (text) => subject.add(text),
                      ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}