// To parse this JSON data, do
//
//     final request = requestFromJson(jsonString);

import 'dart:convert';

List<Request> requestFromJson(String str) =>
    List<Request>.from(json.decode(str).map((x) => Request.fromJson(x)));

String requestToJson(List<Request> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Request {
  String model;
  int pk;
  Fields fields;

  Request({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int user;
  DateTime dateAdded;
  String bookTitle;
  String bookAuthor;
  String reason;

  Fields({
    required this.user,
    required this.dateAdded,
    required this.bookTitle,
    required this.bookAuthor,
    required this.reason,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        dateAdded: DateTime.parse(json["date_added"]),
        bookTitle: json["book_title"],
        bookAuthor: json["book_author"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "date_added":
            "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
        "book_title": bookTitle,
        "book_author": bookAuthor,
        "reason": reason,
      };
}
