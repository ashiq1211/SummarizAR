import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/Pages/cam_screen.dart';
import 'package:project/Pages/sign_up.dart';
import 'package:project/Pages/forgot_password.dart';
import 'package:project/ScopedModel/main.dart';
import 'package:project/Widget/alert.dart';
import 'package:project/Widget/loading.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginPage extends StatefulWidget {
  Mainmodel _model;
  LoginPage([this._model]);
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _passwordcontroller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  TextEditingController _mailcontroller = TextEditingController();
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
    return ScopedModelDescendant<Mainmodel>(
        builder: (BuildContext context, Widget child, Mainmodel model) {
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
            buildSignUpInSignin(model)
          ]));
    });
  }

  Row buildSignUpInSignin(Mainmodel model) {
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
              if (model.load) {
                return null;
              } else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignUp(),
                        fullscreenDialog: true));
              }
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

  Widget signInForm() {
    return ScopedModelDescendant<Mainmodel>(
        builder: (BuildContext context, Widget child, Mainmodel model) {
      return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (input) {
                if (input.isEmpty ||
                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(input)) {
                  return 'Please provide the correct email';
                }
              },
              controller: _mailcontroller,
              decoration: InputDecoration(
                labelText: 'Email ',
                prefixIcon: Icon(Icons.email_rounded),
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
              controller: _passwordcontroller,
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
                    if (model.load) {
                      return null;
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword(),
                              fullscreenDialog: true));
                    }
                  },
                  child: Text("Forgot Password",
                      style: TextStyle(fontSize: 12.0, color: Colors.grey)),
                )),
            SizedBox(height: 60.0),
            Align(
              child: SizedBox(
                height: 50.0,
                width: 270,
                child: model.load
                    ? LoadingWidget()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          primary: Colors.grey[900], // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () => _submitform(model),
                        child: Text('Sign In')),
              ),
            )
          ],
        ),
      );
    });
  }

  void _submitform(Mainmodel model) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _focusNode.unfocus();
    model
        .signin(
      _mailcontroller.text,
      _passwordcontroller.text,
    )
        .then((response) {
      if (!response['error']) {
        Navigator.pushReplacementNamed(context, '/homePage');
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertWidget(response["message"]);
            });
      }
    });

    //  checkuser();
  }
  // Future<void> _showMyDialog(String t, String t1, String t2) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(t),
  //         content: SingleChildScrollView(
  //           child: Text(
  //             t1,
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text(
  //               t2,
  //             ),
  //             onPressed: () {
  //               Navigator.pushReplacement(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => SignUp(),
  //                       fullscreenDialog: true));
  //             },
  //           ),
  //           TextButton(
  //             child: Text("Try Again"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future<void> signIn() async {
  //   final formState = _formKey.currentState;
  //   if (formState.validate()) {
  //     formState.save();

  //     try {
  //       final UserCredential user = await FirebaseAuth.instance
  //           .signInWithEmailAndPassword(email: _email, password: _password);

  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => CameraScreen()));
  //     } catch (e) {
  //       String t, t1, t2;
  //       var connectivityResult = await (Connectivity().checkConnectivity());
  //       if (connectivityResult == ConnectivityResult.none) {
  //         t1 = "No Connection";
  //         t = "Check your Internet Connectivity";
  //         t2 = "";
  //         // _showMyDialog(t, t1, t2);

  //       } else {
  //         t1 = "Invalid Login Credentials!";
  //         t = "The email or password you entered is incorrect";
  //         t2 = "SignUp";
  //       }
  //       _showMyDialog(t, t1, t2);

  //       print(e.message);
  //     }
  //   }
  // }
}
