import 'package:flutter/material.dart';
import 'package:trip_app/HomePage.dart';
import 'package:trip_app/LoginPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'وسيط للرحلات البرية',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
      ),
      home: LoginPage(),
    );
  }
}
