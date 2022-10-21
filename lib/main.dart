import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:preloadvideo/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Preload Video",
      home: HomePage(),
    ),
  );
}
