import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/Pages/cam_screen.dart';
import 'package:project/Pages/settings.dart';
import 'package:project/ScopedModel/main.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  Mainmodel _model;
  HomePage([this._model]);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FocusNode _focusNode = FocusNode();
  void _select(
    choice,
  ) async {
    print(choice);

    if (choice == "Logout") {
      print(choice);
      await FirebaseAuth.instance.signOut().then((value) {
        Navigator.pushReplacementNamed(context, "/login");
      });
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacementNamed(context, "/login");
    });
  }

  List<CustomPopupMenu> choices = <CustomPopupMenu>[
    CustomPopupMenu(
      title: 'Import from Gallery',
      icon: Icons.photo_album,
    ),
    CustomPopupMenu(
      title: 'Premium',
      icon: Icons.star_rate,
    ),
    CustomPopupMenu(
      title: 'Settings',
      icon: Icons.settings,
    ),
    CustomPopupMenu(
      title: 'Logout',
      icon: Icons.logout,
    ),
  ];

  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Mainmodel>(
        builder: (BuildContext context, Widget child, Mainmodel model) {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.camera_alt),
            onPressed: () {
              Navigator.pushNamed(context, "/cameraPage");
            },
          ),
          appBar: AppBar(
            title: Text(
              "Home",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            elevation: 10,
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.search),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.notifications),
              ),
              IconButton(
                onPressed: () {
                  _settingModalBottomSheet(context);
                },
                icon: new Icon(Icons.more_vert),
              ),
              PopupMenuButton(
                elevation: 3.2,
                onCanceled: () {
                  print('You have not chossed anything');
                },
                tooltip: 'This is tooltip',
                onSelected: _select,
                itemBuilder: (BuildContext context) {
                  return choices.map((CustomPopupMenu choice) {
                    return PopupMenuItem(
                      value: choice.title,
                      child: ListTile(
                        leading: Icon(choice.icon),
                        title: Text(choice.title),
                      ),
                    );
                  }).toList();
                },
              )
            ],
          ),
          drawer: Drawer(),
          body: Center(
              child: Text(
            "Nothing Found!!. \n Add some Docs.",
            style: GoogleFonts.lato(
                textStyle: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            )),
          )));
    });
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 280,
            decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0))),
            child: Column(
              children: [
                Icon(
                  Icons.horizontal_rule,
                  color: Colors.white,
                  size: 50,
                ),
                new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.image, color: Colors.white),
                        title: new Text(
                          'Import Image',
                          style: TextStyle(
                              color: Colors.white, letterSpacing: 0.8),
                        ),
                        onTap: () => {}),
                    new ListTile(
                      leading: new Icon(Icons.star, color: Colors.white),
                      title: new Text(
                        'Premium',
                        style:
                            TextStyle(color: Colors.white, letterSpacing: 0.8),
                      ),
                      onTap: () => {},
                    ),
                    new ListTile(
                      leading: new Icon(Icons.settings, color: Colors.white),
                      title: new Text(
                        'Settings',
                        style:
                            TextStyle(color: Colors.white, letterSpacing: 0.8),
                      ),
                      onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => settings(),
                              fullscreenDialog: true)),
                    ),
                    new ListTile(
                      leading: new Icon(Icons.logout, color: Colors.white),
                      title: new Text(
                        'Logout',
                        style:
                            TextStyle(color: Colors.white, letterSpacing: 0.8),
                      ),
                      onTap: () => _signOut(),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class CustomPopupMenu {
  CustomPopupMenu({
    this.title,
    this.icon,
  });
  String title;
  IconData icon;
}
