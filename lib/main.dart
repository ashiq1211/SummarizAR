import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/Pages/cam_screen.dart';
import 'package:project/Pages/login.dart';

import 'Pages/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      // home: CameraScreen(),
      // home: LoginPage(),
      home: WelcomePage(),
    );
  }
}
