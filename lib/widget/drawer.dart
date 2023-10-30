import 'package:animations/animations.dart';
import 'package:content_manage_apps/login.dart';
import 'package:content_manage_apps/main.dart';
import 'package:content_manage_apps/page/my_bookmark.dart';
import 'package:content_manage_apps/page/my_postList.dart';
import 'package:content_manage_apps/page/post_list.dart';
import 'package:content_manage_apps/page/posts_list.dart';
import 'package:content_manage_apps/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:content_manage_apps/globals.dart' as globals;

import '../model/user.dart';

@override
Widget userDrawer(Future<User>? user) {
  return Drawer(
    surfaceTintColor: Colors.white,
    child: FutureBuilder<User>(
      future: user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // You can replace this with a loading indicator.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final user = snapshot.data!;

          return ListView(
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Profile"),
                ),
              ),
              Image.network(
                'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                width: 200,
                height: 100,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("${user.name}"), // Display the user's email.
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                      // ignore: unnecessary_string_interpolations
                      "${user.email}"), // Display the user's email.
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Status: "),
                  globals.isLoggedIn == true
                      ? const Text(
                          'success', // Display the user's status.
                          style: TextStyle(color: Colors.green, fontSize: 19),
                        )
                      : const Text("Failed"),
                ],
              ),
              SizedBox(
                width: 100,
                child: Divider(
                  height: 20,
                  color: const Color.fromARGB(139, 158, 158, 158),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text('แก้ไขโปรไฟล์'),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('บทความทั้งหมด'),
                    onTap: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              // สร้างหน้าที่คุณต้องการแสดง
                              return PostListPage();
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              // กำหนด animation ที่คุณต้องการ
                              return SharedAxisTransition(
                                animation: animation,
                                secondaryAnimation: secondaryAnimation,
                                transitionType: SharedAxisTransitionType
                                    .scaled, // หรือ vertical
                                child: child,
                              );
                            },
                          ));
                    },
                  ),
                  ListTile(
                    title: Text('บทความของฉัน'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserPostListPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('ออกจากระบบ'),
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
                ],
              ),
            ],
          );
        }
      },
    ),
  );
}
