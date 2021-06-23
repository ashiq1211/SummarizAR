import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:floating_action_row/floating_action_row.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/Pages/cam_screen.dart';
import 'package:project/Pages/home.dart';
import 'package:project/Pages/summary.dart';
import 'package:project/ScopedModel/appModel.dart';
import 'package:project/ScopedModel/main.dart';
import 'package:project/Widget/alert.dart';
import 'package:project/Widget/loading.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PreviewScreen extends StatefulWidget {
  final File imgPath;
  final String fileName;
  final Mainmodel model;

  PreviewScreen(this.model, [this.imgPath, this.fileName]);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  int flag = 0;
  var imagePath;
 PDFDocument document;
  File file;
  final pdf = pw.Document();
  DateTime date = DateTime.now();
  final picker = ImagePicker();
 File _image;
  Future createPdf(String recognizedText) async {
    date = DateTime.now();
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(recognizedText),
          );
        }));
    imagePath =
        join((await getApplicationDocumentsDirectory()).path, '${date}.pdf');

    file = File(imagePath);
    file.writeAsBytesSync(await pdf.save());
    print(file);
  }

  // Future<void> _getImageSize(File imageFile) async {
  //   final Completer<Size> completer = Completer<Size>();

  //   final Image image = Image.file(widget.imgPath);
  //   image.image.resolve(const ImageConfiguration()).addListener(
  //     ImageStreamListener((ImageInfo info, bool _) {
  //       completer.complete(Size(
  //         info.image.width.toDouble(),
  //         info.image.height.toDouble(),
  //       ));
  //     }),
  //   );

  //   final Size imageSize = await completer.future;
  //   setState(() {
  //     _imageSize = imageSize;
  //   });
  // }

  @override
  void initState() {
    super.initState();

    Mainmodel model = ScopedModel.of(this.context);

    model.recognizeText(widget.imgPath).then((value) {
    
    });
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: 'Document has been saved !.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.yellow);
  }
  void createSavepdf( String str)async{
    date = DateTime.now();
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(str),
          );
        }));
    var pdfPath =
        join((await getApplicationDocumentsDirectory()).path, '${date}.pdf');

    file = File(pdfPath);
    file.writeAsBytesSync(await pdf.save());
    showToast();
  }


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Mainmodel>(
        builder: (BuildContext context, Widget child, Mainmodel model) {
      return WillPopScope(
          child: Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

              // floatingActionButtonLocation:
              //     FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Padding(padding: EdgeInsets.symmetric(vertical: 35),
              child:                     FloatingActionRow(
                    
                
    color: Colors.white,
    children: <Widget>[
        
        
        FloatingActionRowButton(
           
               
                    icon: Icon(
                     Feather.file_plus,color: Colors.black
                    ),
                    
                    onTap: () async {
                      if(model.load){
                        return ;
                      }
                      model.isAppend = 1;
                      pickImage(model);
                     
                      
                      
           
                    },
        ),
        FloatingActionRowDivider(color: Colors.black,),
        FloatingActionRowButton(
           
                    onTap: () {
                      if (model.load) {
                        return;
                      }
                    model.getSummary(model.recognizedTxt);
                      Navigator.push(
                          this.context,
                          MaterialPageRoute(
                              builder: (context) => SummaryPage(imagePath)));
                    },
                    icon: Icon(Octicons.note,color: Colors.black,),
                    
        ),
    ],
),),
   
              
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    if (model.load) {
                      return;
                    }
                   
                    Navigator.pushAndRemoveUntil(
                      this.context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  icon: new Icon(Icons.arrow_back),
                ),
                title: Text(
                  date.toString(),
                  style: TextStyle(fontSize: 15),
                ),
                actions: [
                  IconButton(
                    onPressed: () async {
                      
                      if (model.load) {
                        return;
                      }
                      
                  createSavepdf(model.recognizedTxt);
                    },
                    icon: new Icon(Icons.picture_as_pdf),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (model.load) {
                        return;
                      }

                    
                    
                      Share.share(model.recognizedTxt,subject: "Actual Text");
                    },
                    icon: new Icon(Icons.share),
                  ),
                ],
              ),
              body:body(model, context)) ,
          onWillPop: () async {
           
            Navigator.pushAndRemoveUntil(
              this.context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false,
            );
          });
    });
  }

  Widget body(Mainmodel model, BuildContext context) {
    if (model.load) {
        return Center(child: LoadingWidget());
      // return showLoadingIndicator(context);
    } else {
      return 
      
      Container(
        child: Container(
          margin: const EdgeInsets.all(15.0),
          // adding padding

          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            // adding borders around the widget
            border: Border.all(
              color: Color.fromRGBO(64, 75, 96, .9),
              width: 2.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  scrollDirection: Axis.vertical,
                  child: Text(
                    model.recognizedTxt,
                    style: TextStyle(
                      color: Colors.black,
                      // fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      // letterSpacing: 3,
                      // wordSpacing: 2,
                    ),

                  ),
                ),
                
              ),

            ],
          ),

        ),
      );
    }
  }
// loadDocument(url) async {
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
         model.recognizeText(_image);
        } else {
          print('No image selected.');
        }
      });
    }
  }


//   }
  Widget showLoadingIndicator(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          backgroundColor: Colors.black,
          content: Container(
              padding: EdgeInsets.all(16),
              color: Colors.black,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _getLoadingIndicator(),
                    _getHeading(context),
                    _getText("Recognizing Text ...")
                  ])),
        ));
  }

  Padding _getLoadingIndicator() {
    return Padding(
        child: Container(
            child: CircularProgressIndicator(strokeWidth: 3),
            width: 32,
            height: 32),
        padding: EdgeInsets.only(bottom: 16));
  }

  Widget _getHeading(context) {
    return Padding(
        child: Text(
          'Please wait …',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        padding: EdgeInsets.only(bottom: 4));
  }

  Text _getText(String displayedText) {
    return Text(
      displayedText,
      style: TextStyle(color: Colors.white, fontSize: 14),
      textAlign: TextAlign.center,
    );
  }
}
