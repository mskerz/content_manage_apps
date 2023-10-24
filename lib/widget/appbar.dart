
import 'package:flutter/material.dart';

AppBar userAppbar(String? title){
  return AppBar(
    title: title!=null? Text(title):const Text(""),
    surfaceTintColor: Colors.white,
  );
}