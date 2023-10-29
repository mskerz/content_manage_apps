import 'dart:convert';

import 'package:content_manage_apps/model/posts.dart';
import 'package:http/http.dart' as http;
import 'package:content_manage_apps/globals.dart' as globals;

bool isMarked = true;
Future<List<Posts>> getBookmarks() async {
  final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/bookmarks/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Authorization': 'Bearer ' + globals.jwtToken,
      });
  // print("response: ");
  if (response.statusCode == 200) {
    final data = json.decode(response.body) as List<dynamic>;
    return data.map((json) => Posts.fromJson(json)).toList();
  } else {
    return <Posts>[];
  }
}

Future<void> toggleBookmark(int post_id) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:8000/api/bookmarks-toggle/$post_id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'connection': 'keep-alive',
      'Authorization': 'Bearer ' + globals.jwtToken,
    },
  );

  if (response.statusCode == 200) {
    // สำเร็จ
    
    print('การบุ๊คมาร์กถูกอัปเดตเรียบร้อย');
  } else {
    // เกิดข้อผิดพลาด
    print('เกิดข้อผิดพลาดในการอัปเดตบุ๊คมาร์ก');
  }
}

 
 Future<bool> checkBookmarkExist(int post_id) async {
  final bookmarks = await getBookmarks(); // เรียกใช้งานฟังก์ชันเพื่อรับรายการ bookmarks
  return bookmarks.any((bookmark) => bookmark.id == post_id);
}

