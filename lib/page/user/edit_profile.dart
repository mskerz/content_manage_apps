import 'dart:convert';

import 'package:content_manage_apps/model/request_res.dart';
import 'package:content_manage_apps/model/user.dart';
import 'package:content_manage_apps/page/user/user_profile.dart';
import 'package:content_manage_apps/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:content_manage_apps/globals.dart' as globals;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _editForm = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final bio = TextEditingController();

  late User user;

  Future<RequestResponse> editprofile() async {
    final body = {
      'name': name.text,
      'email': email.text,
      'bio': bio.text,
    };

    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/api/edit-profile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Authorization': 'Bearer ' + globals.jwtToken
      },
      body: jsonEncode(body),
    );

    return RequestResponse.fromJson(
        jsonDecode(response.body), response.statusCode);
  }

  @override
  void initState() {
    super.initState();
    getUser().then((data) {
      setState(() {
        user = data;
        name.text = user.name;
        email.text = user.email;
        bio.text = user.bio;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('แก้ไข้โปรไฟล์'),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _editForm,
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
                            controller: bio,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Bio',
                              hintText: 'Please fill your bio',
                              prefixIcon: Icon(Icons.person_2),
                            ),
                            onChanged: (String value) {},
                          )),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: FilledButton(
                          onPressed: () async {
                            if (_editForm.currentState!.validate()) {
                              final res = await editprofile();
                              if (res.status == 200) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UserProfilePage()));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    showCloseIcon: true,

                                    content: Text('แก้ไขข้อมูลไม่สำเร็จ'),
                                    duration: Duration(seconds: 2),
                                    // กำหนดระยะเวลาที่ SnackBar จะแสดง
                                  ),
                                );
                              }
                            }
                            //
                            // if (_registerForm.currentState!.validate()) {

                            //   final res = await register();
                            //   print(res.status);
                            //   if (res.status == 200) {
                            //     // แสดง SnackBar ด้วย ScaffoldMessenger

                            //     Navigator.pop(context);
                            //     // หลังจากแสดง SnackBar ให้กลับไปหน้า login โดยใช้ Navigator
                            //   } else if (res.status == 400) {
                            //     // ignore: use_build_context_synchronously
                            //     displayDialog(
                            //         context,
                            //         'แจ้งเตือน',
                            //         'อีเมลนี้มีผู้ใช้แล้ว !',
                            //         const Icon(Icons.error));
                            //   }
                            // } else {}
                          },
                          child: const Text(
                            'แก้ไขโปรไฟล์',
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
