import 'dart:convert';

// import 'package:content_manage_apps/config.dart';
import 'package:content_manage_apps/main.dart';
import 'package:content_manage_apps/model/category.dart';
import 'package:content_manage_apps/model/posts.dart';
import 'package:content_manage_apps/model/user.dart';
import 'package:content_manage_apps/page/my_bookmark.dart';
import 'package:content_manage_apps/page/post_create.dart';
import 'package:content_manage_apps/page/posts_detail.dart';
import 'package:content_manage_apps/services/bookmarkService.dart';
import 'package:content_manage_apps/services/categoriesService.dart';
import 'package:content_manage_apps/services/postsService.dart';
import 'package:content_manage_apps/services/userService.dart';
import 'package:content_manage_apps/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:content_manage_apps/globals.dart' as globals;

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  late Future<List<Category>> futureCategories;
  late Future<List<Posts>> futurePosts;
  late Future<User> user;
  late Future<List<Posts>> bookmarks;

  bool isLoaded = false;
  // ignore: non_constant_identifier_names, unused_field
  int _currentIndex = 0;

  void fetchPost(int categoryId) {
    setState(() {
      isLoaded = false;
    });
    if (categoryId == 0) {
      futurePosts = loadPostsAll();
      //re render ui
      setState(() {
        isLoaded = true;
      });
    } else {
      futurePosts = loadPostsByCategory(categoryId);
      //re render ui
      setState(() {
        isLoaded = true;
      });
    }
  }

  Future<void> refreshPosts() async {
    setState(() {
      futurePosts = loadPostsAll(); // Call your method to fetch posts here.
    });
  }

  //load post by category
  Future<List<Posts>> loadPostsByCategory(int categoryId) async {
    print("Loading posts for category ID: $categoryId");
    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:8000/api/posts/user/{user_id}/filter?category_id=$categoryId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      return data.map((json) => Posts.fromJson(json)).toList();
    } else {
      return <Posts>[];
    }
  }
//end

  @override
  void initState() {
    // TODO: implement initState
    futurePosts = loadPostsAll();
    user = getUser();
    futureCategories = fetchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: userDrawer(user),
        appBar: AppBar(
          iconTheme: IconThemeData(color: const Color.fromARGB(255, 0, 0, 0)),
          surfaceTintColor: Colors.white,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Text("บทความ", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
        body: FutureBuilder<List<Posts>>(
          future: futurePosts,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final posts = snapshot.data![index];
                  final updatedDate = formatDate(posts.updatedAt);

                  return Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          posts.images,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(posts.title!),
                      subtitle: Row(
                        children: [
                          Text(posts.category!),
                          Spacer(),
                          const Icon(
                            Icons.access_time,
                            size: 15,
                            color: Colors.grey,
                          ),
                          Text(
                            updatedDate,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          FutureBuilder<bool>(
                            future: checkBookmarkExist(posts.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox
                                    .shrink(); // หรือวิธีการแสดงผลอื่น ๆ ที่คุณต้องการ
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final bool isBookmarked = snapshot.data!;
                                return IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        posts.isBookmarked = !isBookmarked;
                                      });
                                      await toggleBookmark(posts.id);
                                      print(posts.isBookmarked);
                                    },
                                    icon: isBookmarked
                                        ? Icon(Icons.bookmark)
                                        : Icon(Icons.bookmark_border));
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PostDetailsPage(post_id: posts.id!)));
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 2.0,
          surfaceTintColor: Color.fromARGB(255, 228, 228, 228),
          shadowColor: Color.fromARGB(255, 0, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  setState(() {
                    refreshPosts();
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.bookmark),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyBookListPage()));
                },
              ),
              IconButton(
                icon: Icon(Icons.create),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreatePostPage()));
                },
              ),
            ],
          ),
        ));
  }
}
