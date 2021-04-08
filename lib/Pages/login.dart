import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/Pages/cam_screen.dart';
import 'package:project/Pages/sign_up.dart';
import 'package:project/Pages/forgot_password.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  bool _isObscured = true;
  Color _eyeButton = Colors.grey;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: 42.0,
        ),
      ),
    );
  }

  @override
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
          signInForm(),
          SizedBox(height: 70),
          buildSignUpInSignin()
        ]));
  }

  Row buildSignUpInSignin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          child: RichText(
              text: TextSpan(
                  text: "Do not have an Account?",
                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  children: <TextSpan>[])),
        ),
        TextButton(
            child: Text('SignUp',
                style: TextStyle(fontSize: 14.0, color: Colors.black)),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignUp(), fullscreenDialog: true));
            }),
      ],
    );
  }

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

  Form signInForm() {
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
              labelText: 'Email ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
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
          SizedBox(
            height: 5,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPassword(),
                          fullscreenDialog: true));
                },
                child: Text("Forgot Password",
                    style: TextStyle(fontSize: 12.0, color: Colors.grey)),
              )),
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
                  onPressed: signIn,
                  child: Text('Sign In')),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Incorrect Login Credentials'),
          content: SingleChildScrollView(
            child: Text(
              'Either the email or password you entered is incorrect',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Try Again"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'SignUp',
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignUp(),
                        fullscreenDialog: true));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();

      try {
        final UserCredential user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CameraScreen(user: user)));
      } catch (e) {
        _showMyDialog();
        print(e.message);
      }
    }
  }
}
