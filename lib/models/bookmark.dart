// To parse this JSON data, do
//
//     final bookmark = bookmarkFromJson(jsonString);

import 'dart:convert';

Bookmark bookmarkFromJson(String str) => Bookmark.fromJson(json.decode(str));

String bookmarkToJson(Bookmark data) => json.encode(data.toJson());

class Bookmark {
    List<Result> result;

    Bookmark({
        required this.result,
    });

    factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
    };
}

class Result {
    int pk;
    int user;
    Book book;
    String review;

    Result({
        required this.pk,
        required this.user,
        required this.book,
        required this.review,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
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
