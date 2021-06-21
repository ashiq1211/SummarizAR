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
    TextEditingController _searchController = TextEditingController();

   static final GlobalKey<ScaffoldState> scaffoldKey =
  new GlobalKey<ScaffoldState>();
int currIndex=0;
  TextEditingController _searchQuery;
  bool _isSearching = false;
  String searchQuery = "Search query";
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
    _searchController.text==" ";
    Mainmodel model = ScopedModel.of(this.context);
  
    model.loading = true;

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
    _cropImage(pickedFile.path, model);
  }

  _cropImage(filePath, Mainmodel model) async {
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
          toolbarColor: Colors.white30,
          backgroundColor: Colors.black,
          toolbarWidgetColor: Colors.black,
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



  Widget tab1(Mainmodel model) {
    print(model.load);
    if (model.load == true) {
      return Center(
          child: CircularProgressIndicator(
        backgroundColor: Colors.white,
      ));
    } else if (model.doclist.length != 0) {
      print(_searchController.text);
      return ListView.separated(
        separatorBuilder: (_, __) => Divider(
          height: 10.0,
          thickness: 0.7,
        ),
        padding: const EdgeInsets.all(16.0),
        itemCount:(_isSearching==true && _searchController.text!="")?model.searchList.length: model.doclist.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return ListTileWidget((_isSearching==true && _searchController.text!="")?model.searchList[index]:model.doclist[index]);
        },
      );
    } else {
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

  Widget tab2(Mainmodel model) {
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
                                itemCount:(_isSearching==true && _searchController.text!="")?model.searchList.length: model.getsumlist.length,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTileWidget((_isSearching==true && _searchController.text!="")?model.searchList[index]: model.getsumlist[index]);
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
  void updateSearchQuery(String newQuery) {
if(newQuery!=" "){setState(() {
       searchQuery = newQuery;
       filter(newQuery);
    });
    print("search query " + newQuery);}
    
   
    // _userDetails.forEach((userDetail) {
    //   if (userDetail.firstName.contains(text) || userDetail.lastName.contains(text))
    //     _searchResult.add(userDetail);
    // });

}
void filter(String query){
   Mainmodel model = ScopedModel.of(this.context);
   model.searchList=[];
  
   if(currIndex==0){
     model.itemList.forEach((element) {
       if (element.name.contains(query)){
      setState(() {
        model.searchList.add(element);
      });
         
       }
     });
    }else{
      model.itemList.forEach((element) {
       if (element.name.contains(query)){
         setState(() {
        model.searchList.add(element);
      });
       }
     });

    }
}
// List<Widget> _buildActions() {

//     if (_isSearching) {
//       return <Widget>[
//         new 
//       ];
//     }

    
//   }
  void _clearSearchQuery() {
    print("close search box");
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("Search query");
    });
  }
Widget _buildSearchField() {
    return new TextField(
      cursorColor: Colors.black,
      controller: _searchController,
      autofocus: true,
      decoration: const InputDecoration(
        
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }
  @override
  Widget build(BuildContext context) {
      
    return ScopedModelDescendant<Mainmodel>(
        builder: (BuildContext context, Widget child, Mainmodel model) {
      return DefaultTabController(
        
        length: 2,
        child: Scaffold(
          floatingActionButton: FloatingActionRow(
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
              FloatingActionRowDivider(
                color: Colors.black,
              ),
              FloatingActionRowButton(
                  icon: Icon(
                    Icons.image,
                    color: Colors.black,
                  ),
                  onTap: () {
                    pickImage(model);
                  }),
            ],
          ),
          appBar: AppBar(
            bottom: TabBar(

              onTap: (index) {
        print(index);
        setState(() {
          model.searchList=[];
         _searchController.clear;
         _isSearching=false;
          currIndex=index;
        });
    },
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
               ] ),
                elevation: 10,
                title:_isSearching?_buildSearchField(): Text(
                  "Home",
                  style: TextStyle(
                      fontSize: 18, color: Color.fromRGBO(64, 75, 96, .9)),
                ),
                iconTheme: IconThemeData(color: Color.fromRGBO(64, 75, 96, .9)),
                backgroundColor: Colors.white30,
                actions:_isSearching?[IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
           setState(() {
                _searchController.clear();
           });
      
          },
        )]: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: IconButton(icon:Icon(Icons.search),onPressed: (){
                      setState(() {
                        _searchController.text==" ";
                        _isSearching=!_isSearching;
                        
                        
                      });
                    },
                        color: Color.fromRGBO(64, 75, 96, .9)),

                  ),
                 Padding(
                    padding: EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/notification");
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
leading:_isSearching ?  BackButton(onPressed:(){
  setState(() {
    _isSearching=!_isSearching;
    _searchController.clear();
    model.searchList=[];
  });
},) : null,
              ),
              
          drawer:_isSearching?null: Drawer(

            child: MainDrawer(),
          ),
          body: TabBarView(
            children: [
              RefreshIndicator(
                  color: Colors.black,
                  onRefresh: model.refreshDoc,
                  child: Scaffold(
                      backgroundColor: Colors.black, body: tab1(model))),
              RefreshIndicator(
                  color: Colors.black,
                  onRefresh: model.refreshDoc,
                  child: Scaffold(
                      backgroundColor: Colors.black, body: tab2(model)))

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
