import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/Pages/cam_screen.dart';
import 'package:project/Pages/login.dart';
import 'package:project/Pages/settings.dart';
import 'package:project/ScopedModel/appModel.dart';
import 'package:project/ScopedModel/main.dart';
import 'package:project/Widget/alert.dart';
import 'package:project/Widget/loading.dart';
import 'package:project/Widget/tile.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  Mainmodel model;
  HomePage([this.model]);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   final picker = ImagePicker();

  List<DocumentModel> itemList = [];

 @override
  void initState() {

  Mainmodel model = ScopedModel.of(this.context);
   model.getDoc().then((value) {
     if(value["error"]){ showDialog(context: context, builder:(BuildContext context){
       return AlertWidget(value["message"]);
     } );}
    
   });

    super.initState();
  }
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
      Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => LoginPage()),
  (Route<dynamic> route) => false,
);
    });
  }

  

  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Mainmodel>(
        builder: (BuildContext context, Widget child, Mainmodel model) {
      return RefreshIndicator(
        color: Colors.black,
        onRefresh: model.refreshDoc,
        child: 
      Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.camera_alt),
          onPressed: () async{
            // final pickedFile = await picker.getImage(source: ImageSource.camera);
Navigator.of(context).pushNamed("/cameraPage");
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
           
          ],
        ),
        drawer: Drawer(),

        body: model.load?Center(child:LoadingWidget()):model.doclist.length == 0

            ? Center(
                child: Text(
                "Nothing Found!!. \n Add some Docs.",
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                )),
              ))
            : ListView.separated(
              separatorBuilder: (_, __) => Divider(height: 1.5,thickness: 0.7,),
                itemCount: model.doclist.length,
                itemBuilder: (context, index) {
                  return ListTileWidget(model.doclist[index]);
                },
              ),
      ));
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
                              builder: (context) => Settings(),
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

