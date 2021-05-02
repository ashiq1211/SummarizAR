import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:project/Pages/cam_screen.dart';
import 'package:project/Pages/home.dart';
import 'package:project/Pages/login.dart';
import 'package:project/Pages/preview_screen_recognized.dart';
import 'package:project/Pages/sign_up.dart';
import 'package:project/ScopedModel/appModel.dart';
import 'package:project/ScopedModel/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Pages/pdf_preview.dart';
import 'Pages/welcome_page.dart';

bool isAuth = false;
 
void main() async {

  //  await FirebaseAuth.instance.signOut();
  WidgetsFlutterBinding.ensureInitialized();
  
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  FirebaseAuth.instance.authStateChanges().listen((User user) {
    if (user == null) {
      isAuth = false;
      prefs.setString('userId', "noUser");
    } else {
      isAuth = true;
       prefs.setString('userId', user.uid);
    }
  });
    
runApp(MyApp());
  
}

class MyApp extends StatelessWidget {
 
 final Mainmodel model = Mainmodel();

  @override
  Widget build(BuildContext context) {
     
  

    return ScopedModel< Mainmodel>(
         
        model: model,
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.black,
          ),

          // home: CameraScreen(),
          // home: LoginPage(),
          home: isAuth ? HomePage(model) : WelcomePage(),
          routes: {
            "/signup": (BuildContext context) => SignUp(model),
            "/login": (BuildContext context) => LoginPage(model),
            "/cameraPage": (BuildContext context) => CameraScreen(model),
            "/homePage": (BuildContext context) => HomePage(model),
             "/preview": (BuildContext context) => PreviewScreen(model),
             "/previewPdf": (BuildContext context) => PdfPreview(),
          },
        ));
  }
}
