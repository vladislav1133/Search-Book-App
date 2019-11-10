import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../models/Book.dart';

class BookCard extends StatefulWidget {
  final Book book;

  BookCard({
    this.book,
    @required this.onCardClick,
    @required this.onStarClick,
  });

  final VoidCallback onCardClick;
  final VoidCallback onStarClick;

  @override
  State<StatefulWidget> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: widget.onCardClick,
      child: Card(
        child: Container(
          height: 200.0,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                widget.book.url != null
                    ? Hero(
                        child: Image.network(widget.book.url),
                        tag: widget.book.id)
                    : Container(),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Align(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                                widget.book.title + " - " + widget.book.notes,
                                maxLines: 10)),
                        alignment: Alignment.center,
                      ),
                      Align(
                          child: IconButton(
                              icon: widget.book.starred
                                  ? Icon(Icons.star)
                                  : Icon(Icons.star_border),
                              color: Colors.black,
                              onPressed: widget.onStarClick),
                          alignment: Alignment.topRight)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
