// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'dart:convert';

List<Item> itemFromJson(String str) => List<Item>.from(json.decode(str).map((x) => Item.fromJson(x)));

String itemToJson(List<Item> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Item {
    String model;
    int pk;
    Fields fields;

    Item({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
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
    String username;
    DateTime date;
    String title;
    String story;
    int prompt;

    Fields({
        required this.user,
        required this.username,
        required this.date,
        required this.title,
        required this.story,
        required this.prompt,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        username: json["username"],
        date: DateTime.parse(json["date"]),
        title: json["title"],
        story: json["story"],
        prompt: json["prompt"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "username": username,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "title": title,
        "story": story,
        "prompt": prompt,
    };
}
