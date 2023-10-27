import 'package:content_manage_apps/model/category.dart';
import 'package:content_manage_apps/services/categoriesService.dart';
import 'package:flutter/material.dart';

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
  int category_id = 0;
  List<Category> categories = [];
  String selectedCategory = ''; // หมวดหมู่ที่ถูกเลือก
  @override
  void initState() {
    super.initState();
     

     // เลือกหมวดหมู่แรก
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Create Post",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 157, 0),
      ),
      body: Column(
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
                      maxLines: 10,
                      decoration: const InputDecoration(
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
                    
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
