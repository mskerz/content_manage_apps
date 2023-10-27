import 'package:content_manage_apps/model/posts.dart';
import 'package:content_manage_apps/page/my_bookmark.dart';
import 'package:content_manage_apps/services/bookmarkService.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

void refresh(BuildContext context) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => MyBookListPage()));
}

Widget buildBookmarkIcon(BuildContext context, bool? currentPage) {
  return IconButton(
    icon: badges.Badge(
      badgeContent: FutureBuilder<List<Posts>>(
        future: getBookmarks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            int numberOfBookmarks = snapshot.data!.length;
            return Text(
              numberOfBookmarks.toString(),
              style: TextStyle(color: Colors.white),
            );
          } else {
            return Container();
          }
        },
      ),
      child: Icon(Icons.bookmark),
    ),
    onPressed: () {
      if (currentPage == true) {
        refresh(context);
      }
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyBookListPage()));
    },
  );
}
