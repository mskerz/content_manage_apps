import 'dart:convert';

// import 'package:content_manage_apps/config.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:content_manage_apps/main.dart';
import 'package:content_manage_apps/main_filter.dart';
import 'package:content_manage_apps/model/category.dart';
import 'package:content_manage_apps/model/posts.dart';
import 'package:content_manage_apps/model/user.dart';
import 'package:content_manage_apps/page/my_bookmark.dart';
import 'package:content_manage_apps/page/post_create.dart';
import 'package:content_manage_apps/page/posts_detail.dart';
import 'package:content_manage_apps/page/user/user_profile.dart';
import 'package:content_manage_apps/services/bookmarkService.dart';
import 'package:content_manage_apps/services/categoriesService.dart';
import 'package:content_manage_apps/services/postsService.dart';
import 'package:content_manage_apps/services/userService.dart';
import 'package:content_manage_apps/widget/count_bookmark.dart';
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
  List<Posts> allPosts = [];
  List<Posts> fillterPosts = [];
  late Future<User> user;
  late Future<List<Posts>> bookmarks;

  List<Category> categories = [];
  bool isLoaded = true;
  // ignore: non_constant_identifier_names, unused_field
  int _currentIndex = 0;
  // ignore: non_constant_identifier_names
  TextEditingController textController = TextEditingController();

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
          'http://10.0.2.2:8000/api/posts/filter?category_id=$categoryId'),
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
  void search(String value) {
    setState(() {
      // ค้นหาจากรายการ allPosts และเก็บผลลัพธ์ใน futurePosts
      futurePosts = Future.value(allPosts
          .where((element) =>
              element.title.toLowerCase().contains(value.toLowerCase()))
          .toList());
    });
  }

  Future<void> retrevePosts() async {
    List<Posts> res = await loadPostsAll();
    setState(() {
      allPosts = res;
      isLoaded = isLoaded ? !isLoaded : isLoaded;
    });
  }

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
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 238, 238, 238),
        drawer: userDrawer(user),
        appBar: AppBar(
          iconTheme: IconThemeData(color: const Color.fromARGB(255, 0, 0, 0)),
          surfaceTintColor: Colors.white,
          actions: const [],
        ),
        body: SizedBox(
          // ignore: avoid_unnecessary_containers
          child: Container(
            constraints: BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: EdgeInsets.all(1),
              child: FutureBuilder<List<Posts>>(
                future: futurePosts,
                builder: (context, snapshot) {
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

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PostDetailsPage(post_id: posts.id!),
                              ),
                            );
                          },
                          child: Container(
                            height: 136,
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                border: Border.all(
                                    color: Color.fromARGB(255, 197, 197, 197)),
                                borderRadius: BorderRadius.circular(8.0)),
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      posts.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${posts.username} · $updatedDate",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.share),
                                          onPressed: () {},
                                        ),
                                        FutureBuilder<bool>(
                                          future: checkBookmarkExist(posts.id),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const SizedBox.shrink();
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else {
                                              final bool isBookmarked =
                                                  snapshot.data!;
                                              return IconButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    posts.isBookmarked =
                                                        !isBookmarked;
                                                  });
                                                  await toggleBookmark(
                                                      posts.id);
                                                  print(posts.isBookmarked);
                                                },
                                                icon: isBookmarked
                                                    ? Icon(Icons.bookmark)
                                                    : Icon(Icons
                                                        .bookmark_add_outlined),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                                Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(posts.images),
                                        ))),
                              ],
                            ),
                          ),
                        );
                        // Padding(
                        //   padding:
                        //       const EdgeInsets.only(left: 5, top: 10, right: 5),
                        //   child: Card(
                        //     shadowColor: Color.fromARGB(255, 0, 0, 0),
                        //     color: Colors.white,
                        //     surfaceTintColor: Color.fromARGB(255, 255, 255, 255),
                        //     child: ListTile(
                        //       contentPadding:
                        //           EdgeInsets.all(0), // ลบ Padding ของ ListTile
                        //       title: Column(
                        //         children: [
                        //           ClipRRect(
                        //             child: Image.network(
                        //               posts.images,
                        //               width: 230,
                        //               fit: BoxFit.cover,
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             child: Align(
                        //               alignment: Alignment.topLeft,
                        //               child: Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Text(
                        //                   posts.title!,
                        //                   style: TextStyle(fontSize: 20),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //           Row(
                        //             children: [
                        //               Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.spaceEvenly,
                        //                 children: [
                        //                   Icon(Icons.person_2),
                        //                   Padding(
                        //                     padding:
                        //                         const EdgeInsets.only(left: 8),
                        //                     child: Text(posts.username!),
                        //                   ),
                        //                 ],
                        //               ),
                        //               Spacer(),
                        //               const Icon(
                        //                 Icons.access_time,
                        //                 size: 15,
                        //                 color: Colors.grey,
                        //               ),
                        //               Text(
                        //                 updatedDate,
                        //                 style: TextStyle(
                        //                     color: Colors.grey, fontSize: 12),
                        //               ),
                        //               FutureBuilder<bool>(
                        //                 future: checkBookmarkExist(posts.id),
                        //                 builder: (context, snapshot) {
                        //                   if (snapshot.connectionState ==
                        //                       ConnectionState.waiting) {
                        //                     return const SizedBox.shrink();
                        //                   } else if (snapshot.hasError) {
                        //                     return Text(
                        //                         'Error: ${snapshot.error}');
                        //                   } else {
                        //                     final bool isBookmarked =
                        //                         snapshot.data!;
                        //                     return IconButton(
                        //                       onPressed: () async {
                        //                         setState(() {
                        //                           posts.isBookmarked =
                        //                               !isBookmarked;
                        //                         });
                        //                         await toggleBookmark(posts.id);
                        //                         print(posts.isBookmarked);
                        //                       },
                        //                       icon: isBookmarked
                        //                           ? Icon(Icons.bookmark)
                        //                           : Icon(Icons
                        //                               .bookmark_add_outlined),
                        //                     );
                        //                   }
                        //                 },
                        //               ),
                        //             ],
                        //           ),
                        //         ],
                        //       ),
                        //       onTap: () {
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) =>
                        //                 PostDetailsPage(post_id: posts.id!),
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //   ),
                        // );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 1.0,
          height: 60,
          surfaceTintColor: Color.fromARGB(255, 228, 228, 228),
          shadowColor: Color.fromARGB(255, 0, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => PostListPage()));
                },
              ),
              buildBookmarkIcon(context, false),
              IconButton(
                icon: Icon(Icons.create),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreatePostPage()));
                },
              ),
              IconButton(
                icon: Icon(Icons.person_2),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfilePage()));
                },
              ),
            ],
          ),
        ));
  }
}
