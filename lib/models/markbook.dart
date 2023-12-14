// To parse this JSON data, do
//
//     final markBook = markBookFromJson(jsonString);

import 'dart:convert';

List<MarkBook> markBookFromJson(String str) => List<MarkBook>.from(json.decode(str).map((x) => MarkBook.fromJson(x)));

String markBookToJson(List<MarkBook> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MarkBook {
    String model;
    int pk;
    Fields fields;

    MarkBook({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory MarkBook.fromJson(Map<String, dynamic> json) => MarkBook(
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
    int book;
    String review;

    Fields({
        required this.user,
        required this.book,
        required this.review,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        book: json["book"],
        review: json["review"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "book": book,
        "review": review,
    };
}
