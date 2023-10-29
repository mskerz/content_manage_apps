import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:content_manage_apps/model/user.dart';
import 'package:content_manage_apps/page/posts_detail.dart';
import 'package:content_manage_apps/provider/categories_data.dart';
import 'package:content_manage_apps/provider/posts_data.dart';
import 'package:content_manage_apps/services/postsService.dart';
import 'package:content_manage_apps/services/userService.dart';
import 'package:content_manage_apps/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostList2Page extends StatefulWidget {
  const PostList2Page({super.key});

  @override
  State<PostList2Page> createState() => _PostList2PageState();
}

class _PostList2PageState extends State<PostList2Page> {
  int selectedIndex = 0;
  final _searchCtrl = TextEditingController();
  late Future<User> user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = getUser();
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.fetchCategories();
    postProvider.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: userDrawer(user),
      appBar: AppBar(
        title: Text("List Provider"),
        actions: [
          //  final postProvider =
          //         Provider.of<PostProvider>(context, listen: false);
          //     postProvider.search(value);
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Consumer<CategoryProvider>(
              builder: (context, categoryProvider, child) {
                if (categoryProvider.categories.isEmpty) {
                  return CircularProgressIndicator();
                } else {
                  return Container(
                    color: const Color.fromARGB(0, 255, 255, 255),
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryProvider.categories.length,
                      itemBuilder: (context, index) {
                        final category = categoryProvider.categories[index];
                        final isSelected = selectedIndex == index;
                        return Padding(
                          padding: EdgeInsets.all(8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected == true
                                  ? Color.fromARGB(255, 108, 108, 108)
                                  : Color.fromARGB(255, 118, 90, 255),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedIndex = index;
                              });
                              final postProvider = Provider.of<PostProvider>(
                                  context,
                                  listen: false);
                              postProvider.fetchPostsByCategory(category.id);

                              print(
                                  'Selected category index: $index ${isSelected.toString()}');
                            },
                            child: Text(
                              category.title,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            Consumer<PostProvider>(
              builder: (context, postProvider, child) {
                final posts = postProvider.filterposts.isNotEmpty
                    ? postProvider.filterposts
                    : postProvider.posts;
                if (posts.isEmpty) {
                  // ignore: avoid_unnecessary_containers
                  return Container(
                    child: const Center(
                      child: Text("ไม่พบบทความ"),
                    ),
                  );
                } else {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
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
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  border: Border.all(
                                      color:
                                          Color.fromARGB(255, 197, 197, 197)),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                icon: Icon(Icons.share),
                                                onPressed: () {},
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {});
                                                },
                                                icon: Icon(Icons.bookmark),
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                  );
                }
              },
            ),
          ],
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
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => PostListPage()));
              },
            ),
            IconButton(
              icon: Icon(Icons.create),
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => CreatePostPage()));
              },
            ),
            IconButton(
              icon: Icon(Icons.person_2),
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => UserProfilePage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
