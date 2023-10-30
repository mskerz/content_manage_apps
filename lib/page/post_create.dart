import 'dart:convert';

import 'package:content_manage_apps/model/category.dart';
import 'package:content_manage_apps/model/request_res.dart';
import 'package:content_manage_apps/page/post_list.dart';
import 'package:content_manage_apps/provider/categories_data.dart';
import 'package:content_manage_apps/services/categoriesService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:content_manage_apps/globals.dart' as globals;

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  // ignore: unused_field
  final _createPostForm = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  final title_controller = TextEditingController();
  // ignore: non_constant_identifier_names
  final details_controller = TextEditingController();
  final imageUrl_controller = TextEditingController();
  int selectedCategoryId = 0;
  List<Category> categories = [];
  String selectedCategory = ''; // หมวดหมู่ที่ถูกเลือก
  
 
 
  @override
  void initState() {
    super.initState();
    Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    // เลือกหมวดหมู่แรก
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    title_controller.dispose();
    details_controller.dispose();
    imageUrl_controller.dispose();
  }

  printPost() {
    print("title: ${title_controller.text}");
    print("description: ${details_controller.text}");
    print("category: ${selectedCategoryId}");
    print("url: ${imageUrl_controller.text}");
  }

  Future<RequestResponse> creatPost() async {
    final body = {
      'title': title_controller.text,
      'details': details_controller.text,
      'category_id': selectedCategoryId,
      'images': imageUrl_controller.text,
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/user/post'), //
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Authorization': 'Bearer ' + globals.jwtToken
      },
      body: jsonEncode(body),
    );

    return RequestResponse.fromJson(
        jsonDecode(response.body), response.statusCode);
  }

  void displayDialog(context, title, text, Icon icon) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), icon: icon, content: Text(text)),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
        title: const Text(
          "สร้างโพส",
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Form(
              key: _createPostForm,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                        width: 360,
                        child: TextFormField(
                          controller: title_controller,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'ระบุหัวข้อบทความ',
                            prefixIcon: Icon(Icons.article_sharp),
                          ),
                          onChanged: (String value) {},
                          validator: (value) {
                            return value!.isEmpty
                                ? 'กรุณาระบุหัวข้อของบทความ'
                                : null;
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      width: 360,
                      child: TextFormField(
                        controller: details_controller,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'เขียนบทความ...',
                        ),
                        onChanged: (String value) {},
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "หมวดหมู่",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, right: 15, left: 15),
                        child: SizedBox(
                          width: 100,
                          child: Consumer<CategoryProvider>(
                            builder: (context, categoryProvider, child) {
                              return DropdownButtonFormField<int>(
                                value: categoryProvider.selectedCategoryId,
                                items: categoryProvider.categories
                                    .map((Category category) {
                                  return DropdownMenuItem<int>(
                                    value: category.id,
                                    child: Text(category.title),
                                  );
                                }).toList(),
                                onChanged: (int? categoryId) {
                                  categoryProvider.selectedCategoryId =
                                      categoryId!;
                                  setState(() {
                                    selectedCategoryId = categoryId;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                        width: 360,
                        child: TextFormField(
                          keyboardType: TextInputType.url,
                          controller: imageUrl_controller,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'ใส่ลิงก์รูปภาพของคุณ',
                            prefixIcon: Icon(Icons.image),
                          ),
                          onChanged: (String value) {},
                        )),
                  ),
                  Center(
                    child: FilledButton(
                        onPressed: () async {
                          printPost();
                          if (_createPostForm.currentState!.validate()) {
                            // เรียกฟังก์ชัน register เมื่อข้อมูลถูกต้อง
                            if (selectedCategoryId != 0) {
                              final res = await creatPost();
                              print(res.status);
                              if (res.status == 200) {
                                // แสดง SnackBar ด้วย ScaffoldMessenger
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    showCloseIcon: true,
                                    content: Text('สร้างบทความสำเร็จ'),
                                    duration: Duration(seconds: 1),
                                    // กำหนดระยะเวลาที่ SnackBar จะแสดง
                                  ),
                                );

                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PostListPage()));
                                // หลังจากแสดง SnackBar ให้กลับไปหน้า login โดยใช้ Navigator
                              } else {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    showCloseIcon: true,
                                    content: Text('สร้างบทความล้มเหลว'),
                                    duration: Duration(seconds: 1),
                                    // กำหนดระยะเวลาที่ SnackBar จะแสดง
                                  ),
                                );
                              }
                            } else {}
                          } else {}
                        },
                        child: Text("โพสต์บทความ")),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
