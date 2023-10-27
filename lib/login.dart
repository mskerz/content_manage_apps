import 'dart:convert';

import 'package:content_manage_apps/model/api_res.dart';
import 'package:content_manage_apps/model/login.dart';
import 'package:content_manage_apps/page/post_list.dart';
import 'package:content_manage_apps/register.dart';
import 'package:content_manage_apps/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginForm = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
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
          Text(
            "Forum App",
            style: TextStyle(fontSize: 30),
          ),
          Form(
            key: _loginForm,
            child: Column(
              children: [
                SizedBox(height: 50),
                SizedBox(
                    width: 300,
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
                  width: 300,
                  child: TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        prefixIcon: Icon(Icons.security),
                        border: OutlineInputBorder()),
                    onChanged: (String value) {},
                    validator: (value) {
                      return value!.isEmpty
                          ? 'Please enter your passsord'
                          : null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            "ลืมรหัสผ่าน?",
                            style: TextStyle(fontSize: 13),
                          )),
                      Row(
                        children: [
                          const Text("ยังไม่ได้เป็นสมาชิก ? "),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()));
                              },
                              child: const Text("สมัครเลย")),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FilledButton(
                    onPressed: () async {
                      //
                      if (_loginForm.currentState!.validate()) {
                        print('Login in Progress');
                        LoginResponse res = await verifyLogin();

                        if (res.loginStatus == 1) {
                          // ignore: avoid_print
                          print('Login Success');

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
