import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:floating_action_row/floating_action_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/Pages/cam_screen.dart';
import 'package:project/Pages/login.dart';
import 'package:project/Pages/preview_screen_recognized.dart';
import 'package:project/Pages/settings.dart';
import 'package:project/ScopedModel/appModel.dart';
import 'package:project/ScopedModel/main.dart';
import 'package:project/Widget/alert.dart';
import 'package:project/Widget/loading.dart';
import 'package:project/Widget/maindrawer.dart';
import 'package:project/Widget/tile.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
 
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final picker = ImagePicker();
  TabController _tabController;
  List<DocumentModel> itemList = [];
  File _image;
  @override
  void initState() {
//  SharedPreferences prefs;
//       SharedPreferences.getInstance().then((value) {
//         setState(() {
//            prefs = value;
//         });

//          if(prefs.getBool("isHeNew")==null){
//        loginBottomSheet(context);
//      }
//       });

   

    super.initState();
     Mainmodel model = ScopedModel.of(this.context);
    model.loading=true;

    model.getDoc().then((value) {
      if (value["error"]) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertWidget(value["message"]);
            });
      }
    });
    model.setRecoTxt = " ";
    model.setSumTxt = " ";
    model.isAppend = 0;
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
pickImage(Mainmodel model) async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    File img = File(pickedFile.path);
    // return Container(
    //   child: img == Null ? Text("No image selected yet") : Image.file(img),
    //   height: 300,
    // );
    print("image picked");
    _cropImage(pickedFile.path,model);
  }

  _cropImage(filePath,Mainmodel model) async {
    final name = DateTime.now();
    print("started");
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );
    print("suceess");
    if (croppedImage != null) {
      // File imageFile = croppedImage;
      setState(() {
        if (croppedImage != null) {
          _image = File(croppedImage.path);
          Navigator.pushAndRemoveUntil(
            this.context,
            MaterialPageRoute(
                builder: (context) => PreviewScreen(
                      model,
                      _image,
                      "$name.png",
                    )),
            (Route<dynamic> route) => false,
          );
        } else {
          print('No image selected.');
        }
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
  Widget tab1(Mainmodel model){
    print(model.load);
   if( model.load==true){

     return Center(child:CircularProgressIndicator(color: Colors.white,));
   }else if (model.doclist.length != 0){
     
     return ListView.separated(
                                separatorBuilder: (_, __) => Divider(
                                  height: 10.0,
                                  thickness: 0.7,
                                ),
                                padding: const EdgeInsets.all(16.0),
                                itemCount: model.doclist.length,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTileWidget(model.doclist[index]);
                                },
                              );}
                              else{
return Center(
                              child: Text(
                              "Nothing Found!!. \n Add some Docs.",
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )),
                            ));
                              }
                      
                            
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Mainmodel>(
        builder: (BuildContext context, Widget child, Mainmodel model) {
      return  DefaultTabController(
            length: 2,
            child: Scaffold(
              floatingActionButton:
              FloatingActionRow(
                
    color: Colors.white,
    children: <Widget>[
        
        
        FloatingActionRowButton(
           
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                ),
                onTap: () async {
                  model.setRecoTxt = " ";
                  model.setSumTxt = " ";
                  // final pickedFile = await picker.getImage(source: ImageSource.camera);
                  Navigator.of(context).popAndPushNamed("/cameraPage");
                },
        ),
        FloatingActionRowDivider(color: Colors.black,),
        FloatingActionRowButton(
            icon: Icon(Icons.image,color: Colors.black,),
            onTap: () {

              pickImage(model);
            }
        ),
    ],
),
              
               
              appBar: AppBar(
                bottom: TabBar(
                  indicatorColor: Colors.black,
                  labelPadding: EdgeInsets.symmetric(horizontal: 50),
                  labelColor: Colors.black,
                  isScrollable: true,
                  tabs: <Widget>[
                    Tab(
                      text: 'Actual Text',
                    ),
                    Tab(
                      text: 'Summary',
                    ),
                  ],
                ),
                title: Text(
                  "Home",
                  style: TextStyle(
                      fontSize: 18, color: Color.fromRGBO(64, 75, 96, .9)),
                ),
                elevation: 10,
                iconTheme: IconThemeData(color: Color.fromRGBO(64, 75, 96, .9)),
                backgroundColor: Colors.white30,
                actions: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.search,
                        color: Color.fromRGBO(64, 75, 96, .9)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        // print("object");
                        // model.getSummary("text");
                      },
                      icon: Icon(Icons.notifications),
                      color: Color.fromRGBO(64, 75, 96, .9),
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     _settingModalBottomSheet(context);
                  //   },
                  //   icon: new Icon(Icons.more_vert,
                  //       color: Color.fromRGBO(64, 75, 96, .9)),
                  // ),
                ],
              ),
              drawer: Drawer(
                child: MainDrawer(),
              ),
              body: TabBarView(
                children: [

                 
                           RefreshIndicator(
          color: Colors.black,
          onRefresh: model.refreshDoc,
          child:Scaffold(
                              backgroundColor: Colors.black,
                              body: tab1(model)
                       
                            )
                            
                            )
                          ,
                         
                          
                    model.load
                      ? Center(child:CircularProgressIndicator())
                      : model.getsumlist.length != 0
                          ? RefreshIndicator(
          color: Colors.black,
          onRefresh: model.refreshDoc,
          child:Scaffold(

                              backgroundColor: Colors.black,
                              body: ListView.separated(
                                separatorBuilder: (_, __) => Divider(
                                  height: 10.0,
                                  thickness: 0.7,
                                ),
                                padding: const EdgeInsets.all(16.0),
                                itemCount: model.getsumlist.length,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTileWidget(model.getsumlist[index]);
                                },
                              ),

                            )):Center(
                              child: Text(
                              "Nothing Found!!. \n Add some Docs.",
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              )),
                            ))
                          ,

                  // model.load
                  //     ? Center(child: LoadingWidget())
                  //     : model.doclist.length == 0
                  //         ? Center(
                  //             child: Text(
                  //             "Nothing Found!!. \n Add some Docs.",
                  //             style: GoogleFonts.lato(
                  //                 textStyle: TextStyle(
                  //               fontSize: 14.0,
                  //               fontWeight: FontWeight.w700,
                  //               color: Colors.black,
                  //             )),
                  //           ))
                  //         : Container(
                  //             color: Colors.black,
                  //             child: ListView.separated(
                  //               separatorBuilder: (_, __) => Divider(
                  //                 height: 10.0,
                  //                 thickness: 0.7,
                  //               ),
                  //               padding: const EdgeInsets.all(16.0),
                  //               itemCount: model.doclist.length,
                  //               physics: BouncingScrollPhysics(),
                  //               itemBuilder: (context, index) {
                  //                 return ListTileWidget(model.doclist[index]);
                  //               },
                  //             ),
                  //           ),
                ],
              ),
            ),
          );
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
                          'Import image',
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

  void loginBottomSheet(context) {
    showModalBottomSheet(
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.all(10),
            height: 280,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0))),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool("isHeNew", true);
                        Navigator.of(context).pop();
                      }),
                ),
                Center(
                  child: Text(
                    "Login for subscription !!",
                    style: GoogleFonts.ptSans(
                        textStyle: TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                    child: Text(
                  "Authenticate to subscribe premium.",
                  style: GoogleFonts.ptSans(
                      textStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                  )),
                )),
                Center(
                    child: Text(
                  "Otherwise you will be treated as-",
                  style: GoogleFonts.ptSans(
                      textStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                  )),
                )),
                Center(
                    child: Text(
                  "guest user including free trials.",
                  style: GoogleFonts.ptSans(
                      textStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                  )),
                )),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 48),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      primary: Colors.grey[900], // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool("isHeNew", true);
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, "/login");
                    },
                    child: Text('Login'))
              ],
            ),
          );
        });
  }
}
