import 'package:content_manage_apps/model/user.dart';
import 'package:content_manage_apps/services/userService.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Future<User> user;
  @override
  void initState() {
    super.initState();
    user = getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 222, 222),
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: FutureBuilder<User>(
          future: user,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // You can replace this with a loading indicator.
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final user = snapshot.data!;
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16, bottom: 16, left: 8, right: 8),
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          //https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png
                          backgroundImage: NetworkImage(
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'ชื่อ : ${user.name}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'อีเมลล์ : ${user.email}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}
