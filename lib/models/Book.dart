import 'package:meta/meta.dart';

class Book {
  static final dbTitle = "title";
  static final dbUrl = "url";
  static final dbId = "id";
  static final dbNotes = "notes";
  static final dbStar = "star";

  String title, url, id, notes;
  bool starred;

  Book({
    @required this.title,
    @required this.url,
    @required this.id,
    this.starred = false,
    this.notes = "",
  });

  Book.fromMap(Map<String, dynamic> map): this(
    title: map[dbTitle],
    url: map[dbUrl],
    id: map[dbId],
    starred: map[dbStar] == 1,
    notes: map[dbNotes] 
  );

  Map<String, dynamic> toMap() {
    return {
      dbTitle: title,
      dbUrl: url,
      dbId: id,
      dbNotes: notes,
      dbStar: starred ? 1 : 0
    };
  }
}
