// To parse this JSON data, do
//
//     final posts = postsFromJson(jsonString);

import 'dart:convert';

List<Posts> postsFromJson(String str) =>
    List<Posts>.from(json.decode(str).map((x) => Posts.fromJson(x)));

String postsToJson(List<Posts> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Posts {
  int id;
  String title;
  String details;
  String username;
  String category;
  String images;
  DateTime createdAt;
  DateTime updatedAt;
  bool isBookmarked;

  Posts({
    required this.id,
    required this.title,
    required this.details,
    required this.username,
    required this.category,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    this.isBookmarked = false,
  });

  factory Posts.fromJson(Map<String, dynamic> json) => Posts(
        id: json["id"],
        title: json["title"],
        details: json["details"],
        username: json["username"],
        category: json["category"],
        images: json["images"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "details": details,
        "username": username,
        "category": category,
        "images": images,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
