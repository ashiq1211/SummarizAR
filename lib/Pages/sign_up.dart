import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:project/Pages/login.dart';
import 'package:connectivity/connectivity.dart';

import 'cam_screen.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscured = true;
  Color _eyeButton = Colors.grey;
  @override
  Padding buildTitleLine() {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 12.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 38.0,
          height: 1.5,
          color: Colors.black,
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'SignUp',
        style: TextStyle(
          fontSize: 42.0,
        ),
      ),
    );
  }

  Row buildSigninInSignup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          child: RichText(
              text: TextSpan(
                  text: "Already have an Account?",
                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  children: <TextSpan>[])),
        ),
        TextButton(
            child: Text('SignIn',
                style: TextStyle(fontSize: 14.0, color: Colors.black)),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage(),
                      fullscreenDialog: true));
            }),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
            padding: const EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 22.0),
            children: <Widget>[
          SizedBox(
            height: kToolbarHeight,
          ),
          buildTitle(),
          buildTitleLine(),
          SizedBox(height: 70),
          signUpForm(),
          SizedBox(
            height: 70,
          ),
          buildSigninInSignup()
        ]));
  }

  Form signUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            validator: (input) {
              if (input.isEmpty) {
                return 'Please provide the email';
              }
            },
            onSaved: (input) => _email = input,
            decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                )),
          ),
          SizedBox(
            height: 30.0,
          ),
          TextFormField(
            validator: (input) {
              if (input.length < 6) {
                return 'Password should be minimum of 6 characters';
              }
            },
            onSaved: (input) => _password = input,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: _eyeButton,
                  ),
                  onPressed: () {
                    if (_isObscured) {
                      setState(() {
                        _isObscured = false;
                        _eyeButton = Theme.of(context).primaryColor;
                      });
                    } else {
                      setState(() {
                        _isObscured = true;
                        _eyeButton = Colors.grey;
                      });
                    }
                  }),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            obscureText: _isObscured,
          ),
          SizedBox(height: 60.0),
          Align(
            child: SizedBox(
              height: 50.0,
              width: 270,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  primary: Colors.grey[900], // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: signUp,
                child: Text('Sign Up'),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showMyDialog(String t, String t1, String t2) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t1),
          content: SingleChildScrollView(
            child: Text(
              t,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                t2,
              ),
              onPressed: () {
                if (t2 == "SignIn") {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(),
                          fullscreenDialog: true));
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> signUp() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        final UserCredential user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        user.user.sendEmailVerification();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
        // Navigator.of(context).pop();
      } catch (e) {
        String t, t1, t2;
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          t1 = "No Connection";
          t = "Check your Internet Connectivity";
          t2 = "Try Again";
          // _showMyDialog(t, t1, t2);

        } else {
          t1 = "Account Already Exist";
          t = "The email Id is already registered";
          t2 = "SignIn";
        }
        _showMyDialog(t, t1, t2);

        print(e.message);
      }
    }
  }
}
