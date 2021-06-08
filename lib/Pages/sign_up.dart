import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_icons/flutter_icons.dart';

import 'package:project/Pages/login.dart';
import 'package:connectivity/connectivity.dart';
import 'package:project/Pages/subscription_page.dart';
import 'package:project/ScopedModel/main.dart';
import 'package:project/Widget/alert.dart';
import 'package:project/Widget/loading.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:project/Pages/login.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cam_screen.dart';

class SignUp extends StatefulWidget {
  Mainmodel _model;
  SignUp([this._model]);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  TextEditingController _passwordcontroller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  TextEditingController _mailcontroller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscured = true;
  Color _eyeButton = Colors.grey;
bool isHeNew=false;
  @override
  void initState() {
     SharedPreferences.getInstance().then((value) {
       setState(() {
          isHeNew=value.getBool("isHeNew");
       });
      
       print(isHeNew);
     });
   
    // TODO: implement initState
    super.initState();
  }
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

  Row buildSigninInSignup(Mainmodel model) {
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
            child: Text('Sign In',
                style: TextStyle(fontSize: 14.0, color: Colors.black)),
            onPressed: () {
              if (model.load) {
                return null;
              } else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(),
                        fullscreenDialog: true));
              }
            }),
      ],
    );
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<Mainmodel>(
        builder: (BuildContext context, Widget child, Mainmodel model) {
      return GestureDetector(onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
        child: 
      Scaffold(
          key: _scaffoldKey,
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
                  height: 30,
                ),
                buildSigninInSignup(model),
                isHeNew==null? TextButton(
            child: Text('Skip Now!',
                style: TextStyle(fontSize: 14.0, color: Colors.black)),
            onPressed: ()async {
              if (model.load) {
                return null;
              } else {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("isHeNew", true);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SubscriptionPage(),
                        fullscreenDialog: true));
              }
            }):Container()
                  
              ])));
    });
  }

  Widget signUpForm() {
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
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_rounded),
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
              height: 30.0,
            ),
            TextFormField(
              validator: (input) {
                if (_passwordcontroller.text != input) {
                  return 'password donot match';
                }
              },
              decoration: InputDecoration(
                labelText: 'Confirm Password',
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
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _submitform(model);
                          Navigator.of(context).pop();
                 Navigator.pushNamed(context, "/cameraPage");
                        } ,
                        child: Text('Sign Up'),
                      ),
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
        .signup(
      _mailcontroller.text,
      _passwordcontroller.text,
    )
        .then((response) {
      if (!response['error']) {
        Navigator.pushReplacementNamed(context, '/subscription');
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
  //         title: Text(t1),
  //         content: SingleChildScrollView(
  //           child: Text(
  //             t,
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text(
  //               t2,
  //             ),
  //             onPressed: () {
  //               if (t2 == "SignIn") {
  //                 Navigator.pushReplacement(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (context) => LoginPage(),
  //                         fullscreenDialog: true));
  //               } else {
  //                 Navigator.of(context).pop();
  //               }
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future<void> signUp() async {
  //   final formState = _formKey.currentState;
  //   if (formState.validate()) {
  //     formState.save();
  //     try {
  //       final UserCredential user = await FirebaseAuth.instance
  //           .createUserWithEmailAndPassword(email: _email, password: _password);
  //       user.user.sendEmailVerification();
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => LoginPage()));
  //       // Navigator.of(context).pop();
  //     } catch (e) {
  //       String t, t1, t2;
  //       var connectivityResult = await (Connectivity().checkConnectivity());
  //       if (connectivityResult == ConnectivityResult.none) {
  //         t1 = "No Connection";
  //         t = "Check your Internet Connectivity";
  //         t2 = "Try Again";
  //         // _showMyDialog(t, t1, t2);

  //       } else {
  //         t1 = "Account Already Exist";
  //         t = "The email Id is already registered";
  //         t2 = "SignIn";
  //       }
  //       _showMyDialog(t, t1, t2);

  //       print(e.message);
  //     }
  //   }
  // }
}
