import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:content_manage_apps/globals.dart' as globals;
import 'package:content_manage_apps/model/posts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PostDetailsPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  const PostDetailsPage({
    super.key,
    required this.post_id,
  });
  // ignore: non_constant_identifier_names
  final int post_id;
  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  late Future<Posts> futurePost;
  @override
  @override
  void initState() {
    futurePost = fetchPost(widget.post_id);
    super.initState();
  }

  Future<Posts> fetchPost(int postID) async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/post/$postID'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': "*/*",
          'connection': 'keep-alive',
          // ignore: prefer_interpolation_to_compose_strings
        });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Posts.fromJson(jsonData);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        body: FutureBuilder<Posts>(
            future: futurePost,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                final post = snapshot.data!;
                final createdDate = DateFormat('dd MMMM yyyy')
                    .format(DateTime.parse(post.createdAt.toString()));
                //final updatedDate = DateFormat('dd MMMM yyyy').format(DateTime.parse(post.updatedAt.toString()));

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          post.images,
                          width: 500,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          post.title,
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Color.fromARGB(255, 65, 65, 65),
                            ),
                            Text(" ผู้เขียน: ${post.username}"),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Text('หมวดหมู่ ${post.category}'),
                          ),
                          const Divider(),
                          const Icon(Icons.access_time),
                          Text('สร้างเมื่อ: ${createdDate}'),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(post.details),
                      ),
                    ],
                  ),
                );
              }
            }));
  }
}
