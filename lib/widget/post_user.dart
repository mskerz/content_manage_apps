import 'package:content_manage_apps/page/posts_detail.dart';
import 'package:content_manage_apps/provider/posts_data.dart';
import 'package:content_manage_apps/services/postsService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
