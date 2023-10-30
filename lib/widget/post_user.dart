import 'dart:convert';

import 'package:content_manage_apps/model/request_res.dart';
import 'package:content_manage_apps/page/post_edit.dart';
import 'package:content_manage_apps/page/post_list.dart';
import 'package:content_manage_apps/page/posts_detail.dart';
import 'package:content_manage_apps/provider/posts_data.dart';
import 'package:content_manage_apps/services/postsService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:content_manage_apps/globals.dart' as globals;

class PostUser extends StatefulWidget {
  const PostUser({super.key});

  @override
  State<PostUser> createState() => _PostUserState();
}

class _PostUserState extends State<PostUser> {
  @override
  void initState() {
    super.initState();
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.loadPostsUser();
  }

  Future<RequestResponse> deletePost(int postId) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/api/user/delete/post/$postId'), //
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

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        final posts = postProvider.posts;
        if (posts.isEmpty) {
          return Container(
            child: const Center(
              child: Text("ไม่บทความของคุณ"),
            ),
          );
        } else {
          return Expanded(
            child: SizedBox(
              child: SafeArea(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [
                    Column(
                      children: postProvider.posts.map((post) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PostDetailsPage(post_id: post.id),
                              ),
                            );
                          },
                          child: Container(
                            height: 120,
                            margin: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              border: Border.all(
                                  color: Color.fromARGB(255, 197, 197, 197)),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        "${post.username} · ${formatDate(post.updatedAt)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      SizedBox(height: 2),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.delete_outlined),
                                            onPressed: () {
                                              // ใช้ showDialog เพื่อแสดงหน้าต่างยืนยันการลบ
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        Colors.white,
                                                    surfaceTintColor:
                                                        Colors.white,
                                                    title: Text(
                                                        'ยืนยันการลบโพสต์'),
                                                    content: Text(
                                                        'คุณแน่ใจหรือไม่ที่ต้องการลบโพสต์นี้?'),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .black),
                                                        child: Text(
                                                          'ยืนยัน',
                                                          style: GoogleFonts
                                                              .prompt(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        onPressed: () {
                                                          // เรียกฟังก์ชันที่ลบโพสต์

                                                          Navigator.of(context)
                                                              .pop(); // ปิดหน้าต่างยืนยัน

                                                          deletePost(post.id)
                                                              .then((res) {
                                                            if (res.status ==
                                                                200) {
                                                              print(
                                                                  "ลบโพสต์แล้ว");
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              PostListPage()));
                                                            }
                                                          });
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          'ยกเลิก',
                                                          style: GoogleFonts
                                                              .prompt(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // ปิดหน้าต่างยืนยัน
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {});
                                            },
                                            icon: Icon(Icons.bookmark),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditPostPage(
                                                            postId: post.id,
                                                          )));
                                            },
                                            icon: Icon(Icons.edit),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(post.images),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
