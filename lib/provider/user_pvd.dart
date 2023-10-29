import 'dart:convert';

import 'package:content_manage_apps/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:content_manage_apps/globals.dart' as globals;

class UserProvider extends ChangeNotifier {
  late User _userInfo;

  User get userInfo => _userInfo;

  Future<void> getUser() async {
    final res = await http.get(Uri.parse('http://10.0.2.2:8000/api/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': "*/*",
          'connection': 'keep-alive',
          // ignore: prefer_interpolation_to_compose_strings
          'Authorization': 'Bearer ' + globals.jwtToken
        });
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      _userInfo = User.fromJson(data);
      notifyListeners();
    }

           
  }


  

   
}
