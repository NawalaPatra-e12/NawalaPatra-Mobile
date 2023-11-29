// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

List<Book> bookFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
  String model;
  int pk;
  Fields fields;

  Book({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
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
  String imageUrl;
  String title;
  String author;
  String category;
  int rate;

  Fields({
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.category,
    required this.rate,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        imageUrl: json["image_url"],
        title: json["title"],
        author: (json["author"] != null) ? json["author"] : "",
        category: json["category"],
        rate: json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
        "title": title,
        "author": author,
        "category": category,
        "rate": rate,
      };
}
