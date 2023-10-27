import 'dart:convert';
import 'package:animations/animations.dart';
import 'package:content_manage_apps/login.dart';
import 'package:content_manage_apps/model/register_res.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // ignore: unused_field
  final _registerForm = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  late int statusCode;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    email.dispose();
    password.dispose();
  }

  Future<RegisterResponse> register() async {
    final body = {
      'name': name.text,
      'email': email.text,
      'password': password.text,
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive'
      },
      body: jsonEncode(body),
    );

    return RegisterResponse.fromJson(
        jsonDecode(response.body), response.statusCode);
  }

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Register")),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Form(
                key: _registerForm,
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    SizedBox(
                        width: 360,
                        child: TextFormField(
                          controller: name,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            hintText: 'Enter Name',
                            prefixIcon: Icon(Icons.person_2),
                          ),
                          onChanged: (String value) {},
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Please enter your name'
                                : null;
                          },
                        )),
                    SizedBox(height: 20),
                    SizedBox(
                        width: 360,
                        child: TextFormField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                          onChanged: (String value) {},
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Please enter your name'
                                : null;
                          },
                        )),
                    SizedBox(
                      width: 360,
                      child: TextFormField(
                        controller: password,
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
                      padding: const EdgeInsets.all(8),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        onPressed: () async {
                          //
                          if (_registerForm.currentState!.validate()) {
                            // เรียกฟังก์ชัน register เมื่อข้อมูลถูกต้อง
                            final res = await register();
                            print(res.status);
                            if (res.status == 200) {
                              print("status: + ${res.status} ลงทะเบียนสำเร็จ");
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            } else if (res.status == 400) {
                              print(
                                  "status: + ${res.status} อีเมลนี้มีผู้ใช้แล้ว");
                            }
                          } else {}
                        },
                        color: const Color.fromARGB(255, 255, 147, 24),
                        child: const Text(
                          'ลงทะเบียน',
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
