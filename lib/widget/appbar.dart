import 'package:flutter/material.dart';

AppBar userAppbar(String? title) {
  return AppBar(
    title: title != null ? Text(title) : const Text(""),
    surfaceTintColor: Colors.white,
    actions: [
      title == "บุ๊กมาร์ก"
          ? Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(Icons.bookmark),
            )
          : Text(""),
    ],
  );
}
