import 'package:content_manage_apps/model/posts.dart';
import 'package:content_manage_apps/model/user.dart';
import 'package:content_manage_apps/page/posts_detail.dart';
import 'package:content_manage_apps/services/bookmarkService.dart';
import 'package:content_manage_apps/services/postsService.dart';
import 'package:content_manage_apps/services/userService.dart';
import 'package:content_manage_apps/widget/drawer.dart';
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
      body: FutureBuilder<List<Posts>>(
        future: futureUserPosts,
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
                        const Spacer(),
                        const Icon(
                          Icons.access_time,
                          color: Colors.grey,
                        ),
                        Text(
                          updatedDate,
                          style: TextStyle(color: Colors.grey),
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
    );
  }
}
