import 'package:content_manage_apps/model/login.dart';
import 'package:content_manage_apps/page/post_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:content_manage_apps/globals.dart' as globals;
//import 'package:shared_preferences/shared_preferences.dart';

import 'package:content_manage_apps/model/api_res.dart';
// import 'package:mobileapp_20230921/src/post_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        colorScheme:
            ColorScheme.light(primary: Color.fromARGB(255, 255, 145, 0)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<ApiResponse> futureApiResponse;
  final _loginForm = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  Future<ApiResponse> fetchApi() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8000/api'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': "*/*",
      'connection': 'keep-alive'
    });

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      // ignore: avoid_print
      print('Failed to load data from API');
      throw Exception('Failed to load data from API');
    }
  }

  @override
  void initState() {
    super.initState();
    futureApiResponse = fetchApi();
  }

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  Future<LoginResponse> verifyLogin() async {
    final body = {
      'email': usernameController.text,
      'password': passwordController.text,
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive'
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to Login.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          FutureBuilder<ApiResponse>(
            future: futureApiResponse,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  snapshot.data!.textFromApi,
                  style: TextStyle(fontSize: 35),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
          Form(
            key: _loginForm,
            child: Column(
              children: [
                SizedBox(height: 50),
                SizedBox(
                    width: 360,
                    child: TextFormField(
                      controller: usernameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      onChanged: (String value) {},
                      validator: (value) {
                        return value!.isEmpty
                            ? 'Please enter your email'
                            : null;
                      },
                    )),
                SizedBox(height: 20),
                SizedBox(
                  width: 360,
                  child: TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter Password',
                      prefixIcon: Icon(Icons.security),
                    ),
                    onChanged: (String value) {},
                    validator: (value) {
                      return value!.isEmpty
                          ? 'Please enter your passsord'
                          : null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    onPressed: () async {
                      //
                      if (_loginForm.currentState!.validate()) {
                        print('Login in Progress');
                        LoginResponse res = await verifyLogin();

                        if (res.loginStatus == 1) {
                          // print('Login Success');

                          globals.isLoggedIn = true;
                          globals.jwtToken = res.jwtToken;
                          // print(globals.jwtToken);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PostListPage()),
                          );
                        } else {
                          displayDialog(context, "Error",
                              "Please check your email and password");
                        }
                      }
                    },
                    color: const Color.fromARGB(255, 255, 147, 24),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ])));
  }
}
