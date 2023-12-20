// To parse this JSON data, do
//
//     final bookReq = bookReqFromJson(jsonString);

import 'dart:convert';

List<BookReq> bookReqFromJson(String str) =>
    List<BookReq>.from(json.decode(str).map((x) => BookReq.fromJson(x)));

String bookReqToJson(List<BookReq> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookReq {
  int id;
  DateTime dateAdded;
  String bookTitle;
  String bookAuthor;
  String reason;
  int user;
  String username;

  BookReq({
    required this.id,
    required this.dateAdded,
    required this.bookTitle,
    required this.bookAuthor,
    required this.reason,
    required this.user,
    required this.username,
  });

  factory BookReq.fromJson(Map<String, dynamic> json) => BookReq(
        id: json["id"],
        dateAdded: DateTime.parse(json["date_added"]),
        bookTitle: json["book_title"],
        bookAuthor: json["book_author"],
        reason: json["reason"],
        user: json["user"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date_added":
            "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
        "book_title": bookTitle,
        "book_author": bookAuthor,
        "reason": reason,
        "user": user,
        "username": username,
      };
}
