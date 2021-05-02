import 'package:flutter/material.dart';
import 'package:project/Pages/login.dart';
import 'package:project/Pages/sign_up.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  
  @override
  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Welcome to SummarizAR',
        style: GoogleFonts.lato(
            textStyle: TextStyle(
          fontSize: 42.0,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        )),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color(0xff274046),
                  Color(0xffE6DADA),
                ])),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22.0, 150.0, 22.0, 22.0),
              children: [
                buildTitle(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 140,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        primary: Colors.grey[900], // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: navigateToSignIn,
                      child: Text('Sign In'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        primary: Colors.grey[900], // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: navigateToSignUp,
                      child: Text('Sign Up'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void navigateToSignIn() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(), fullscreenDialog: true));
  }

  void navigateToSignUp() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignUp(), fullscreenDialog: true));
  }
}
