import 'dart:convert';
import 'package:animations/animations.dart';
import 'package:content_manage_apps/login.dart';
import 'package:content_manage_apps/model/request_res.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:content_manage_apps/globals.dart' as globals;

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
  final bio = TextEditingController();

  late int statusCode;
  @override
  void initState() {
    super.initState();
    bio.text = 'bio  here ';
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    email.dispose();
    password.dispose();
    bio.dispose();
  }

  Future<RequestResponse> register() async {
    final body = {
      'name': name.text,
      'email': email.text,
      'bio': bio.text,
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

    return RequestResponse.fromJson(
        jsonDecode(response.body), response.statusCode);
  }

  void displayDialog(context, title, text, Icon icon) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), icon: icon, content: Text(text)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text("Register")),
        body: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Form(
              key: _registerForm,
              child: Column(
                children: [
                  Text(
                    "ลงทะเบียนผู้ใช้",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                      width: 360,
                      child: TextFormField(
                        controller: name,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter Name',
                          prefixIcon: Icon(Icons.person_2_outlined),
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
                          prefixIcon: Icon(Icons.email_outlined),
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
                        controller: bio,
                        keyboardType: TextInputType.text,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Bio',
                          hintText: 'Fill your bio information',
                          prefixIcon: Icon(FontAwesomeIcons.message),
                        ),
                        onChanged: (String value) {},
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
                        prefixIcon: Icon(Icons.lock_outline),
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
                    child: FilledButton(
                      onPressed: () async {
                        //
                        if (_registerForm.currentState!.validate()) {
                          // เรียกฟังก์ชัน register เมื่อข้อมูลถูกต้อง
                          final res = await register();
                          print(res.status);
                          if (res.status == 200) {
                            // แสดง SnackBar ด้วย ScaffoldMessenger
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                showCloseIcon: true,
                                content: Text('ลงทะเบียนสำเร็จ'),
                                duration: Duration(seconds: 2),
                                // กำหนดระยะเวลาที่ SnackBar จะแสดง
                              ),
                            );
                            globals.isActive = true;
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                            // หลังจากแสดง SnackBar ให้กลับไปหน้า login โดยใช้ Navigator
                          } else if (res.status == 400) {
                            // ignore: use_build_context_synchronously
                            displayDialog(
                                context,
                                'อีเมลซ้ำ',
                                'อีเมลนี้มีผู้ใช้แล้ว !',
                                const Icon(Icons.warning_amber));
                          }
                        } else {}
                      },
                      child: const Text(
                        'ลงทะเบียน',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ]),
        ));
  }
}
