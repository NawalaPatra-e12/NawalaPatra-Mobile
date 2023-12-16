// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    Model model;
    int pk;
    Fields fields;

    Product({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Reply {
  int user;
  String text;
  DateTime date;

  Reply({
    required this.user,
    required this.text,
    required this.date,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        user: json["user"],
        text: json["text"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "text": text,
        "date": date.toIso8601String(),
      };
}


class Fields {
  int user;
  DateTime date;
  String description;
  List<Reply> replies; // Change the type to List<Reply>

  Fields({
    required this.user,
    required this.date,
    required this.description,
    required this.replies,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        date: DateTime.parse(json["date"]),
        description: json["description"],
        replies: (json["replies"] as List<dynamic>)
            .map((replyJson) => Reply.fromJson(replyJson))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "description": description,
        "replies": replies.map((reply) => reply.toJson()).toList(),
      };
}


enum Model {
    FORUM_DISCUSSION
}

final modelValues = EnumValues({
    "forum.discussion": Model.FORUM_DISCUSSION
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
