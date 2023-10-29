import 'dart:convert';

import 'package:content_manage_apps/login.dart';
import 'package:content_manage_apps/model/request_res.dart';
import 'package:content_manage_apps/model/user.dart';
import 'package:content_manage_apps/page/user/change_password.dart';
import 'package:content_manage_apps/page/user/edit_profile.dart';
import 'package:content_manage_apps/page/my_postList.dart';
import 'package:content_manage_apps/provider/posts_data.dart';
import 'package:content_manage_apps/services/userService.dart';
import 'package:content_manage_apps/widget/post_user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:content_manage_apps/globals.dart' as globals;

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Future<User> user;
  @override
  void initState() {
    super.initState();
    user = getUser();
  }

  Future<RequestResponse> dropAccount() async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/api/delete-user'), //
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Authorization': 'Bearer ' + globals.jwtToken
      },
    );

    return RequestResponse.fromJson(
        jsonDecode(response.body), response.statusCode);
  }

  Widget test(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
              child: Container(
            child: ListTile(
              leading:
                  Icon(Icons.lock, color: Color.fromARGB(255, 118, 90, 255)),
              title: Text("เปลี่ยนรหัสผ่าน"),
              onTap: () {},
            ),
          )),
          PopupMenuItem(
              child: Container(
            child: ListTile(
              leading:
                  Icon(Icons.lock, color: Color.fromARGB(255, 118, 90, 255)),
              title: Text("ลบบัญชี่"),
              onTap: () {},
            ),
          )),
          PopupMenuItem(
              child: Container(
            child: ListTile(
              leading:
                  Icon(Icons.lock, color: Color.fromARGB(255, 118, 90, 255)),
              title: Text("ออกจากระบบ"),
              onTap: () {},
            ),
          )),
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            child: PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      child: Container(
                    child: ListTile(
                      leading: Icon(Icons.lock,
                          color: Color.fromARGB(255, 118, 90, 255)),
                      title: Text("เปลี่ยนรหัสผ่าน"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePasswordPage()));
                      },
                    ),
                  )),
                  PopupMenuItem(
                      child: Container(
                    child: ListTile(
                      leading: Icon(
                        Icons.delete_forever,
                        color: Color.fromARGB(255, 118, 90, 255),
                      ),
                      title: Text("ลบบัญชีนี้"),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String confirmationText =
                                ""; // ตัวแปรสำหรับเก็บข้อความยืนยัน

                            return AlertDialog(
                              title: Text("ยืนยันการลบบัญชี"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                      "โปรดพิมพ์ 'drop' เพื่อยืนยันการลบบัญชีนี้"),
                                  TextField(
                                    onChanged: (value) {
                                      confirmationText = value;
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("ยกเลิก"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 220, 50, 38)),
                                  onPressed: () {
                                    if (confirmationText == 'drop') {
                                      // ทำการลบบัญชีที่คุณต้องการที่นี่

                                      dropAccount().then((response) {
                                        if (response.status == 200) {
                                          print("ลบแล้ว");
                                          globals.jwtToken = '';
                                          globals.isLoggedIn = false;
                                          globals.isActive = false;
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) => LoginPage(),
                                            ),
                                            (Route<dynamic> route) => false,
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              showCloseIcon: true,
                                              content: Text('ลบบัญชีไม่สำเร็จ'),
                                              duration: Duration(seconds: 1),
                                              // กำหนดระยะเวลาที่ SnackBar จะแสดง
                                            ),
                                          );
                                        }
                                      });
                                      // ปิดหน้าต่างยืนยัน
                                    }
                                  },
                                  child: Text(
                                    "ยืนยัน",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  )),
                  PopupMenuItem(
                      child: Container(
                    child: ListTile(
                      leading: Icon(Icons.exit_to_app,
                          color: Color.fromARGB(255, 118, 90, 255)),
                      title: Text("ออกจากระบบ"),
                      onTap: () async {
                        final res = await logout();
                        if (res.status == 200) {
                          globals.jwtToken = '';
                          globals.isLoggedIn = false;
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        }
                      },
                    ),
                  )),
                ];
              },
            ),
          )
        ],
      ),
      body: FutureBuilder<User>(
          future: user,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(); // You can replace this with a loading indicator.
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final user = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(fit: StackFit.loose, children: [
                      const Positioned(
                        child: CircleAvatar(
                          radius: 50,

                          //https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png
                          backgroundImage: NetworkImage(
                            'https://image.winudf.com/v2/image1/bmV0LndsbHBwci5ib3lzX3Byb2ZpbGVfcGljdHVyZXNfc2NyZWVuXzJfMTY2NzUzNzYxOF8wNDY/screen-2.webp?fakeurl=1&type=.webp',
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 50),
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                colors: [
                                  Color.fromARGB(255, 114, 33, 243),
                                  Color.fromARGB(255, 173, 32, 198)
                                ]),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                      ),
                    ]),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${user.name}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    // ignore: unnecessary_null_comparison
                    user.bio != null ? Text(user.bio) : const Text("....."),
                    Text(
                      '${user.email}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("บทความของฉัน"),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                final postProvider = Provider.of<PostProvider>(
                                    context,
                                    listen: false);
                                postProvider.loadPostsUser();
                              });
                            },
                            icon: Icon(Icons.refresh_outlined)),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfilePage()));
                            },
                            child: Row(
                              children: [
                                Icon(Icons.edit),
                                Text("แก้ไขโปรไฟล์")
                              ],
                            ))
                      ],
                    ),
                    const Divider(),
                    PostUser(),
                  ],
                ),
              );
            }
          }),
    );
  }
}
