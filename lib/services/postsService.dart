import 'dart:convert';

import 'package:content_manage_apps/model/posts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:content_manage_apps/globals.dart' as globals;

String formatDate(DateTime d) {
  Duration diff = DateTime.now().difference(d);
  if (diff.inDays > 365) {
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
  }
  if (diff.inDays > 30)
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
  if (diff.inDays > 7)
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
  if (diff.inDays > 0)
    return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
  if (diff.inHours > 0)
    return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
  if (diff.inMinutes > 0)
    return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
  return "just now";
}

Future<List<Posts>> loadPostsAll() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        // ignore: prefer_interpolation_to_compose_strings
      });

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((json) => Posts.fromJson(json)).toList();
  } else {
    return <Posts>[];
  }
}

// ignore: non_constant_identifier_names
Future<List<Posts>> loadPostsUser() async {
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
    return data.map((json) => Posts.fromJson(json)).toList();
  } else {
    return <Posts>[];
  }
}
