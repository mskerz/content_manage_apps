import 'package:content_manage_apps/model/category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
 
class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  int _selectedCategoryId = 0;

  List<Category> get categories => _categories;
  int get selectedCategoryId => _selectedCategoryId;

  set selectedCategoryId(int categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/categories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*',
        'connection': 'keep-alive',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      _categories = data.map((json) => Category.fromJson(json)).toList();
      notifyListeners();
    } else {
      _categories = <Category>[];
      notifyListeners();
    }
  }

}
