// To parse this JSON data, do
//
//     final bookmark = bookmarkFromJson(jsonString);

import 'dart:convert';

List<Bookmark> bookmarkFromJson(String str) => List<Bookmark>.from(json.decode(str).map((x) => Bookmark.fromJson(x)));

String bookmarkToJson(List<Bookmark> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bookmark {
    int pk;
    int user;
    Book book;
    String review;

    Bookmark({
        required this.pk,
        required this.user,
        required this.book,
        required this.review,
    });

    factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        pk: json["pk"],
        user: json["user"],
        book: Book.fromJson(json["book"]),
        review: json["review"],
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "user": user,
        "book": book.toJson(),
        "review": review,
    };
}

class Book {
    String title;
    String author;
    String category;
    String imageUrl;
    int rate;

    Book({
        required this.title,
        required this.author,
        required this.category,
        required this.imageUrl,
        required this.rate,
    });

    factory Book.fromJson(Map<String, dynamic> json) => Book(
        title: json["title"],
        author: json["author"],
        category: json["category"],
        imageUrl: json["image_url"],
        rate: json["rate"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "category": category,
        "image_url": imageUrl,
        "rate": rate,
    };
}
