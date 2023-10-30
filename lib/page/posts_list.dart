import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:content_manage_apps/model/posts.dart';
import 'package:content_manage_apps/model/user.dart';
import 'package:content_manage_apps/page/post_create.dart';
import 'package:content_manage_apps/page/post_list.dart';
import 'package:content_manage_apps/page/posts_detail.dart';
import 'package:content_manage_apps/page/user/user_profile.dart';
import 'package:content_manage_apps/provider/categories_data.dart';
import 'package:content_manage_apps/provider/posts_data.dart';
import 'package:content_manage_apps/services/bookmarkService.dart';
import 'package:content_manage_apps/services/postsService.dart';
import 'package:content_manage_apps/services/userService.dart';
import 'package:content_manage_apps/widget/count_bookmark.dart';
import 'package:content_manage_apps/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PostList2Page extends StatefulWidget {
  const PostList2Page({super.key});

  @override
  State<PostList2Page> createState() => _PostList2PageState();
}

class _PostList2PageState extends State<PostList2Page> {
  int selectedIndex = 0;
  String searchQuery = "";
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
        resizeToAvoidBottomInset: false,
        drawer: userDrawer(user),
        appBar: AppBar(
          title: Text("List Provider"),
          surfaceTintColor: Colors.white,
          actions: [
            //  final postProvider =
            //         Provider.of<PostProvider>(context, listen: false);
            //     postProvider.search(value);

            Container(
              width: 100,
              child: Stack(
                children: [
                  Positioned(
                    left: 19,
                    top: 15,
                    right: 5,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..translate(0.0, 0.0)
                        ..rotateZ(0.01),
                      child: Text(
                        'GU  RU',
                        style: GoogleFonts.prompt(
                            color: Colors.black, fontSize: 21, height: 0),
                        // style: TextStyle(
                        //   color: Colors.black,
                        //   fontSize: 96,
                        //   fontFamily: 'Inter',
                        //   fontWeight: FontWeight.w400,
                        //   height: 0,
                        // ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 46,
                    top: 42,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..translate(0.0, 0.0)
                        ..rotateZ(-1.56),
                      child: Text(
                        ' ไม่',
                        style: GoogleFonts.prompt(
                            color: Color.fromARGB(255, 138, 32, 168),
                            fontSize: 14,
                            height: 0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              AnimSearchBar(
                width: MediaQuery.of(context)
                    .size
                    .width, // ปรับขนาดตามที่คุณต้องการ
                textController: _searchCtrl,
                suffixIcon: Icon(FontAwesomeIcons.searchengin),
                onSuffixTap: () {
                  setState(() {
                    searchQuery = _searchCtrl.text;
                    // เรียกฟังก์ชันค้นหาโพสต์โดยใช้ค่าใน searchQuery
                    final postProvider =
                        Provider.of<PostProvider>(context, listen: false);
                    postProvider.search(searchQuery);
                  });
                },
                onSubmitted: (String) {},
              ),
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
                  List<Posts> posts = postProvider.filterposts.isNotEmpty
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
                    return Expanded(
                      child: SizedBox(
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
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 197, 197, 197)),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                  FutureBuilder<bool>(
                                                    future: checkBookmarkExist(
                                                        post.id),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const SizedBox
                                                            .shrink();
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Text(
                                                            'Error: ${snapshot.error}');
                                                      } else {
                                                        final bool
                                                            isBookmarked =
                                                            snapshot.data!;
                                                        return IconButton(
                                                          onPressed: () async {
                                                            setState(() {
                                                              post.isBookmarked =
                                                                  !isBookmarked;
                                                            });
                                                            await toggleBookmark(
                                                                post.id);
                                                            print(post
                                                                .isBookmarked);
                                                          },
                                                          icon: isBookmarked
                                                              ? Icon(Icons
                                                                  .bookmark)
                                                              : Icon(Icons
                                                                  .bookmark_add_outlined),
                                                        );
                                                      }
                                                    },
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => PostList2Page()));
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
