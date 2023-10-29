import 'dart:convert';

import 'package:content_manage_apps/model/request_res.dart';
import 'package:content_manage_apps/page/user/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:content_manage_apps/globals.dart' as globals;

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _changePwdForm = GlobalKey<FormState>();
  final currentPassword = TextEditingController();
  final newpassword = TextEditingController();

  Future<RequestResponse> changePassword() async {
    final body = {
      'current_password': currentPassword.text,
      'new_password': newpassword.text
    };

    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/api/change-password'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เปลี่ยนรหัสผ่าน"),
      ),
      body: Center(
        child: Column(
          children: [
            Form(
              key: _changePwdForm,
              child: Column(
                children: [
                  SizedBox(height: 50),
                  SizedBox(
                    width: 360,
                    child: TextFormField(
                      controller: currentPassword,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: 'Currenr Password',
                        hintText: 'Enter Current Password',
                        prefixIcon: Icon(Icons.security),
                      ),
                      onChanged: (String value) {},
                      validator: (value) {
                        return value!.isEmpty
                            ? 'Please enter your Current passsord'
                            : null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 360,
                    child: TextFormField(
                      controller: newpassword,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        hintText: 'Enter New Password',
                        prefixIcon: Icon(Icons.security),
                      ),
                      onChanged: (String value) {},
                      validator: (value) {
                        return value!.isEmpty
                            ? 'Please enter your new passsord'
                            : null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: FilledButton(
                      onPressed: () async {
                        if (_changePwdForm.currentState!.validate()) {
                          final res = await changePassword();
                          if (res.status == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                showCloseIcon: true,

                                content: Text('เปลี่ยนรหัสผ่านสำเร็จ'),
                                duration: Duration(seconds: 3),
                                // กำหนดระยะเวลาที่ SnackBar จะแสดง
                              ),
                            );
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserProfilePage()));
                          // ignore: unnecessary_null_comparison
                          } else if (res.status == 401&&res.message ==null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                showCloseIcon: true,

                                content: Text('เปลี่ยนรหัสผ่านล้มเหลว'),
                                duration: Duration(seconds: 2),
                                // กำหนดระยะเวลาที่ SnackBar จะแสดง
                              ),
                            );
                          }
                        } else {}
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
          ],
        ),
      ),
    );
  }
}
