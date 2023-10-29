import 'package:content_manage_apps/login.dart';
import 'package:content_manage_apps/model/login.dart';
import 'package:content_manage_apps/page/post_list.dart';
import 'package:content_manage_apps/page/posts_list.dart';
import 'package:content_manage_apps/provider/categories_data.dart';
import 'package:content_manage_apps/provider/posts_data.dart';
import 'package:content_manage_apps/provider/user_pvd.dart';
import 'package:content_manage_apps/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:content_manage_apps/globals.dart' as globals;
//import 'package:shared_preferences/shared_preferences.dart';

 import 'package:provider/provider.dart';
// import 'package:mobileapp_20230921/src/post_list.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => PostProvider()),
    ChangeNotifierProvider(create: (_) => CategoryProvider()),
    ChangeNotifierProvider(create: (_)=> UserProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        colorScheme:
            ColorScheme.light(primary: Color.fromARGB(255, 118, 90, 255)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
