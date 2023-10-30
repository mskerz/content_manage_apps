import 'package:content_manage_apps/model/posts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:content_manage_apps/globals.dart' as globals;

class PostProvider extends ChangeNotifier {
  List<Posts> _posts = [];
  List<Posts> _filterposts = [];

  List<Posts> get posts => _posts;
  List<Posts> get filterposts => _filterposts;
  Future<void> fetchPosts() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*',
        'connection': 'keep-alive',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      _posts = data.map((json) => Posts.fromJson(json)).toList();
      notifyListeners();
    } else {
      _posts = <Posts>[];
      notifyListeners();
    }
  }

  Future<void> loadPostsUser() async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/posts/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': "*/*",
          'connection': 'keep-alive',
          // ignore: prefer_interpolation_to_compose_strings
          'Authorization': 'Bearer ' + globals.jwtToken
        });
    print("Token: " + globals.jwtToken);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      _posts = data.map((json) => Posts.fromJson(json)).toList();
      notifyListeners();
    } else {
      _posts = <Posts>[];
      notifyListeners();
    }
  }

  Future<void> fetchPostsByCategory(int categoryId) async {
    if (categoryId == 0) {
      // Fetch all posts
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/posts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': '*/*',
          'connection': 'keep-alive',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _posts = data.map((json) => Posts.fromJson(json)).toList();
      } else {
        _posts = <Posts>[];
      }
    } else {
      // Fetch posts by category
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:8000/api/posts/filter?category_id=$categoryId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': '*/*',
          'connection': 'keep-alive',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _posts = data.map((json) => Posts.fromJson(json)).toList();
      } else {
        _posts = <Posts>[];
      }
    }
    notifyListeners();
  }

  Future<void> search(String query) async {
    _filterposts = _posts
        .where((post) => post.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
