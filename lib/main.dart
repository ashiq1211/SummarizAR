
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:project/Pages/cam_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
await FlutterDownloader.initialize(
  debug: true // optional: set false to disable printing logs to console
);
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

