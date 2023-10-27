import 'dart:convert';

import 'package:content_manage_apps/model/category.dart';
import 'package:http/http.dart' as http;
 

  
Future<List<Category>> fetchCategories() async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/categories'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': "*/*",
          'connection': 'keep-alive',
           
        });
    print("response: ");
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      return <Category>[];
    }
  }