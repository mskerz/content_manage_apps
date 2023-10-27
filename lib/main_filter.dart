import 'package:content_manage_apps/model/category.dart';
import 'package:content_manage_apps/services/categoriesService.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        colorScheme:
            ColorScheme.light(primary: Color.fromARGB(255, 255, 145, 0)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Fillter(),
    );
  }
}

class Fillter extends StatefulWidget {
  const Fillter({super.key});

  @override
  State<Fillter> createState() => _FillterState();
}

class _FillterState extends State<Fillter> {
  late Future<List<Category>> futureCategories;
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Category>>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final category = snapshot.data![index];

                  final isSelected = selectedIndex == index;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(children: [
                        Positioned(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/481px-Cat03.jpg',
                              width: 200,
                              height: 200,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0, // ตำแหน่งตามแกน y (bottom)
                          left: 50,
                          child: FilledButton(
                              onPressed: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                                print(selectedIndex);
                              },
                              style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 20, left: 30, right: 30),
                                  backgroundColor: isSelected == true
                                      ? Color.fromARGB(255, 133, 133, 133)
                                      : Colors.orange),
                              child: Text(category.title)),
                        ),
                      ]),
                    ],
                  );
                });
          }
        },
      ),
    );
  }
}
