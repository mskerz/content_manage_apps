import 'dart:convert';

import 'package:content_manage_apps/model/api_res.dart';
import 'package:content_manage_apps/model/login.dart';
import 'package:content_manage_apps/page/post_list.dart';
import 'package:content_manage_apps/register.dart';
import 'package:content_manage_apps/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

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
    if (globals.jwtToken == '' && globals.isLoggedIn == false) {
      print("ออกจากระบบสำเร็จ");
    }
    if (globals.isActive == false) {
      print("ลบบัญชีสำเร็จ");
    }
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
    return LoginResponse.fromJson(
        jsonDecode(response.body), response.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          Container(
            width: 331.32,
            height: 119.81,
            child: Stack(
              children: [
                Positioned(
                  left: 25,
                  top: 26,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(0.0, 0.0)
                      ..rotateZ(0.01),
                    child: Text(
                      'GU  RU',
                      style: GoogleFonts.prompt(
                          color: Colors.black, fontSize: 80, height: 0),
                      // style: TextStyle(
                      //   color: Colors.black,
                      //   fontSize: 96,
                      //   fontFamily: 'Inter',
                      //   fontWeight: FontWeight.w400,
                      //   height: 0,
                      // ),
                    ),
                  ),
                ),
                Positioned(
                  left: 130,
                  top: 130,
                  right: 1,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(0.0, 0.0)
                      ..rotateZ(-1.56),
                    child: Text(
                      ' ไม่',
                      style: GoogleFonts.prompt(
                          color: const Color.fromARGB(255, 129, 129, 129),
                          fontSize: 50,
                          height: 0),
                    ),
                  ),
                ),
              ],
            ),
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
                      decoration: const InputDecoration(
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
                SizedBox(
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text("ยังไม่ได้เป็นสมาชิก ? "),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()));
                          },
                          child: const Text("สมัครเลย"))
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
                        print("status:  ${res.statusCode}");
                        if (res.statusCode == 200) {
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
                        } else if (res.statusCode == 403) {
                          displayDialog(context, "Error", "ไม่พบผู้ใช้งาน");
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
