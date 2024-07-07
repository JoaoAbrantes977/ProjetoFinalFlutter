import 'package:flutter/material.dart';
import 'user/login.dart';

void main() {
  runApp(MyApp());
}

// Main starts at LoginPage
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
