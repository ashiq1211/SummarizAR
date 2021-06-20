import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:project/Pages/home.dart';
import 'package:project/Pages/sign_up.dart';
import 'package:project/main.dart';
class WelcomeSplash extends StatefulWidget {
    final bool isAuth;
WelcomeSplash(this.isAuth);

  @override
  _WelcomeSplashState createState() => _WelcomeSplashState();
}

class _WelcomeSplashState extends State<WelcomeSplash> {
  @override
  Widget build(BuildContext context) {
     String asset="assets/images/splash.gif";
    var size=MediaQuery.of(context).size;
    return AnimatedSplashScreen(
      splash:asset,
      splashIconSize: MediaQuery.of(context).size.height,
      duration: 3000,
      backgroundColor: Colors.white,
      nextScreen: widget.isAuth==null? SignUp(): HomePage(),
      splashTransition: SplashTransition.fadeTransition,
 
    );
    
    
  }
}


