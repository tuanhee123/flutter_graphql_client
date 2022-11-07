import 'dart:developer';

import 'post_model.dart';

class User {
  String id = "";
  String name = "";
  String email = "";
  String createdAt = "";
  String updatedAt = "";
  List<Post> posts = [];

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.posts,
  });

  User.empty();
  
  User fromJson(Map<String, dynamic> parsedJson) {
    return User.fromJson(parsedJson);
  }

  User.fromJson(Map<String, dynamic> parsedJson) {
    try {
      id = parsedJson['id'] != null ? parsedJson['id'] as String : '';
      name = parsedJson['name'] != null ? parsedJson['name'] as String : '';
      email = parsedJson['email'] != null ? parsedJson['email'] as String : '';
      createdAt = parsedJson['created_at'] != null ? parsedJson['created_at'] as String : '';
      updatedAt = parsedJson['updated_at'] != null ? parsedJson['updated_at'] as String : '';
      posts = parsedJson['posts'] != null && parsedJson['posts'] is List ? postListFromJson(parsedJson['posts']) : [] ;
    } catch (e) {
      inspect(e.toString());
    }
  }

  List<Post> postListFromJson(List postMapList) {
    List<Post> postList  = [];
    for (final Map<String, dynamic> post in postMapList) {
      postList.add(Post.fromJson(post));
    }
    return postList;
  }

}