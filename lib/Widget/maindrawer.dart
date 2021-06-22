import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:path/path.dart';
import 'package:project/ScopedModel/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends StatefulWidget {
  // final String user;
  // MainDrawer(this.user);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  bool press = false;
  String user=" ";
@override
  void initState() {
    // TODO: implement initState
    super.initState();
SharedPreferences.getInstance().then((prefs) {
       user=prefs.getString("userId");
       print(user);
    });
  }
  @override
  Widget build(BuildContext context) {
    return   ScopedModelDescendant<Mainmodel>(
        builder: (BuildContext context, Widget child, Mainmodel model) {
          return
    
    Column(children: [
      Container(
        child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 85,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: new Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: new Center(
        child: user==""?Icon(Icons.person_add,size: 40,): Text(
          FirebaseAuth.instance.currentUser.email[0].toUpperCase(),style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
        ),
      ),
    ),
              SizedBox(
                height: 5.0,
              ),
              Text(
              user==""?"":  FirebaseAuth.instance.currentUser.email.toString(),
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            user==""?Container(): SizedBox(
                height: 20.0,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                        side: BorderSide(color: Colors.black)),
                    primary: Colors.white, // background
                    onPrimary: Colors.black, // foreground
                  ),
                  onPressed: () {
                setState(() {
                  user="";
                });
                     user==""?{Navigator.pushNamed(context, "/login"),}:{Navigator.of(context)
    .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false),model.signout()};
                  },
                  child: user==""?Text('Sign in'):Text('Sign out'),
                ),
              )
            ],
          ),
        ),
      ),
     SizedBox(
        height: 15.0,
      ),
      //Now let's Add the button for the Menu
      //and let's copy that and modify it
      ExpansionTile(
iconColor: Colors.black54,
        childrenPadding: EdgeInsets.fromLTRB(20, 2, 2, 2),
        leading: Icon(
          Icons.library_books,
          color: Colors.black,
        ),
        title: Text(
          "Your library",
          style: TextStyle(color: press ? Colors.grey : Colors.black),
        ),
        onExpansionChanged: (_) {
          setState(() {
            press = !press;
          });
        },
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed("/home");
            },
            leading: Icon(
              Octicons.note,
              color: Colors.black,
            ),
            title: Text("Summary"),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed("/home");
            },
            leading: Icon(
              Icons.pages_outlined,
              color: Colors.black,
            ),
            title: Text("Actual Text"),
          ),
        ],
      ),

      ListTile(
        onTap: () {
          Navigator.of(context).pushNamed("/sub");
        },
        leading: Icon(
          Icons.star,
          color: Colors.black,
        ),
        title: Text("Your plan"),
      ),

      ListTile(
        leading: Icon(
          Icons.notification_important,
          color: Colors.black,
        ),
        title: Text("Notifications"),
        onTap: () {
          Navigator.of(context).pushNamed("/notification");
        },
      ),

      ListTile(
        onTap: () {
          Navigator.of(context).pushNamed("/settings");
        },
        leading: Icon(
          Icons.settings,
          color: Colors.black,
        ),
        title: Text("Settings"),
      ),
      ListTile(
        onTap: () {},
        leading: Icon(
          Icons.help,
          color: Colors.black,
        ),
        title: Text("Help"),
      ),
    ]);
    });
  }
  
}
