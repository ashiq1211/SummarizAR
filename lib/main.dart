
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/Pages/cam_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle());
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: CameraScreen(),
    );
  }
}

