import 'package:animations/animations.dart';
import 'package:content_manage_apps/model/posts.dart';
import 'package:content_manage_apps/model/user.dart';
import 'package:content_manage_apps/page/post_create.dart';
import 'package:content_manage_apps/page/post_list.dart';
import 'package:content_manage_apps/page/posts_detail.dart';
import 'package:content_manage_apps/services/bookmarkService.dart';
import 'package:content_manage_apps/services/postsService.dart';
import 'package:content_manage_apps/services/userService.dart';
import 'package:content_manage_apps/widget/appbar.dart';
import 'package:content_manage_apps/widget/count_bookmark.dart';
import 'package:content_manage_apps/widget/drawer.dart';
import 'package:flutter/material.dart';

class MyBookListPage extends StatefulWidget {
  const MyBookListPage({super.key});

  @override
  State<MyBookListPage> createState() => _MyBookListPageState();
}

class _MyBookListPageState extends State<MyBookListPage> {
  late Future<User> user;
  late Future<List<Posts>> futureBookmarkPosts;

  @override
  void initState() {
    user = getUser();
    futureBookmarkPosts = getBookmarks();
    
    super.initState();
  }

  Future<void> refreshPosts() async {
    setState(() {
      futureBookmarkPosts =
          getBookmarks(); // Call your method to fetch posts here.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: userDrawer(user),
        appBar: userAppbar("บุ๊กมาร์ก"),
        body: FutureBuilder<List<Posts>>(
          future: futureBookmarkPosts,
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
                    padding: const EdgeInsets.all(8.0),
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
                          const Spacer(),
                          const Icon(
                            Icons.access_time,
                            color: Colors.grey,
                          ),
                          Text(
                            updatedDate,
                            style: TextStyle(color: Colors.grey),
                          )
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
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          // สร้างหน้าที่คุณต้องการแสดง
                          return PostListPage();
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
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
              buildBookmarkIcon(context,true),
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
