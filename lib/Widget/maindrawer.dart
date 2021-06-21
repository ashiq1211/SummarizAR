import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:path/path.dart';

class MainDrawer extends StatefulWidget {
  MainDrawer({Key key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  bool press = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[700],
                radius: 40.0,
                child: Icon(
                  Icons.person,
                  size: 37,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "Lee Wang",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
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
                    Navigator.of(context).pop();

                    Navigator.pushNamed(context, "/cameraPage");
                  },
                  child: Text('Sign out'),
                ),
              )
            ],
          ),
        ),
      ),
      SizedBox(
        height: 20.0,
      ),
      //Now let's Add the button for the Menu
      //and let's copy that and modify it
      ExpansionTile(
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
        onTap: () {},
        leading: Icon(
          Icons.notification_important,
          color: Colors.black,
        ),
        title: Text("Notifications"),
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
  }
}
