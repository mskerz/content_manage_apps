
  import 'dart:convert';

import 'package:content_manage_apps/model/user.dart';
  import 'package:http/http.dart' as http;
  import 'package:content_manage_apps/globals.dart' as globals;

Future<User> getUser() async {
    final res = await http.get(Uri.parse('http://10.0.2.2:8000/api/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': "*/*",
          'connection': 'keep-alive',
          // ignore: prefer_interpolation_to_compose_strings
          'Authorization': 'Bearer ' + globals.jwtToken
        });
    if (res.statusCode == 200) {
      final user = jsonDecode(res.body);
      return User.fromJson(user);
    }
    throw Exception('Don\'t Found User');
}