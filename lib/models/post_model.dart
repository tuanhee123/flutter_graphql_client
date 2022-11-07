import 'dart:developer';

import 'user_model.dart';

class Post {
  String id = "";
  String name = "";
  String category = "";
  String createdAt = "";
  String updatedAt = "";
  User user = User.empty();

  Post({
    required this.id,
    required this.name,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  Post.empty();

  Post fromJson(Map<String, dynamic> parsedJson) {
    return Post.fromJson(parsedJson);
  }

  Post.fromJson(Map<String, dynamic> parsedJson) {
    try {
      id = parsedJson['id'] != null ? parsedJson['id'] as String : '';
      name = parsedJson['name'] != null ? parsedJson['name'] as String : '';
      category = parsedJson['category'] != null ? parsedJson['category'] as String : '';
      createdAt = parsedJson['created_at'] != null ? parsedJson['created_at'] as String : '';
      updatedAt = parsedJson['updated_at'] != null ? parsedJson['updated_at'] as String : '';
      user = parsedJson['user'] != null ? User.fromJson(parsedJson['user']) : User.empty();
    } catch (e) {
      inspect(e.toString());
    }
  }

}