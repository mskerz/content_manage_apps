import 'package:content_manage_apps/model/posts.dart';
import 'package:content_manage_apps/model/user.dart';
import 'package:content_manage_apps/page/posts_detail.dart';
import 'package:content_manage_apps/services/bookmarkService.dart';
import 'package:content_manage_apps/services/postsService.dart';
import 'package:content_manage_apps/services/userService.dart';
import 'package:content_manage_apps/widget/drawer.dart';
import 'package:content_manage_apps/widget/post_user.dart';
import 'package:flutter/material.dart';

class UserPostListPage extends StatefulWidget {
  const UserPostListPage({super.key});

  @override
  State<UserPostListPage> createState() => _UserPostListPageState();
}

class _UserPostListPageState extends State<UserPostListPage> {
  late Future<User> user;
  late Future<List<Posts>> futureUserPosts;
  @override
  void initState() {
    user = getUser();
    futureUserPosts = loadPostsUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: userDrawer(user),
      appBar: AppBar(
        title: Text("โพสของฉัน"),
      ),
      body: Column(
        children: [
          PostUser()
        ],
      )
    );
  }
}
