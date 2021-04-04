import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/Pages/login.dart';

class ForgotPassword extends StatefulWidget {
  static String id = 'forgot-password';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String _email;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter your Email',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Please provide the email';
                  }
                },
                onSaved: (input) => _email = input,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(
                    Icons.mail,
                    color: Colors.black,
                  ),
                  errorStyle: TextStyle(color: Colors.black),
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  primary: Colors.grey[900], // background
                  onPrimary: Colors.white, // foreground
                ),
                child: Text(
                  'Send Email',
                ),
                onPressed: () {
                  resetPassword();
                },
              ),
              TextButton(
                child: Text('Sign In',
                    style: TextStyle(fontSize: 12.0, color: Colors.black)),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(),
                          fullscreenDialog: true));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword() async {
    _formKey.currentState.save();
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
    _showMyDialog();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Your Password'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Reset Email sent to your registered Email Id'),
                Text('Would you like to go back to the signIn page?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('SignIn'),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(),
                        fullscreenDialog: true));
              },
            ),
          ],
        );
      },
    );
  }
}
