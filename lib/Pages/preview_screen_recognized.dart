import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:project/Pages/summary.dart';
import 'package:project/ScopedModel/main.dart';
import 'package:share/share.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PreviewScreen extends StatefulWidget {
  final File imgPath;
  final String fileName;
  final Mainmodel model;
  PreviewScreen(this.model,[this.imgPath, this.fileName]);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  Size _imageSize;
  var imagePath;
  String recognizedText = "Loading ...";
  int flag = 0;
  DateTime date=DateTime.now();
  double cur = 0.0;
  Future _initializeVision() async {
    // TODO: Initialize the text recognizer here
    if (widget.imgPath != null) {
      await _getImageSize(widget.imgPath);
    }
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(widget.imgPath);

    

    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    final VisionText visionText =
        await textRecognizer.processImage(visionImage);
    if (visionText.blocks.isNotEmpty) {
      recognizedText = " ";
    } else if (visionText.blocks.isEmpty) {
      recognizedText = "Something went wrong...";
    }
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        setState(() {
          print(line.boundingBox);
          print(line.text);
          if (flag == 1) {
            if (line.boundingBox.top > cur + 50.0) {
              print("hello");
              recognizedText += "\n";
            }
          }
          cur = line.boundingBox.bottom;
          recognizedText += line.text;
          recognizedText += " ";
          flag = 1;
        });
      }
    }

   

   
    final pdf = pw.Document();
      date=DateTime.now();
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(recognizedText),
          );
        }));
    imagePath = join((await getApplicationDocumentsDirectory()).path,
        '${date}.pdf');
    final File file = File(imagePath);
    file.writeAsBytesSync(await pdf.save());
    widget.model.putDoc(file.readAsBytesSync(),date);

  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(widget.imgPath);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }
FToast fToast;
  @override
  void initState() {
    _initializeVision().then((value) => showToast());

    
    super.initState();
  }
  void showToast() {  
    Fluttertoast.showToast(  
        msg: 'Document has been saved !.',  
        toastLength: Toast.LENGTH_SHORT,  
        gravity: ToastGravity.CENTER,  
       
        backgroundColor: Colors.red,  
        textColor: Colors.yellow  
    );  
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, 
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
           Navigator.push(
                                  this.context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SummaryPage(imagePath)));
        },
        icon: Icon(Octicons.note),
        label: Text("Summary"),
        backgroundColor: Theme.of(context).primaryColor,
        
      ),
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: 
        
        IconButton(
              onPressed: () {
             Navigator.of(context).pop();
              },
              icon: new Icon(Icons.arrow_back),
            ), 
        title:Text(date.toString(), style: TextStyle(fontSize: 15),) ,
        actions: [
           IconButton(
              onPressed: () async{
                 
        print(imagePath);
                Share.shareFiles ([imagePath],
                                  subject: "Document");
              },
              icon: new Icon(Icons.share),
            ), 
          
        ],
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 3,
                      color: Colors.black,
                    ),
                  ),
                  child:recognizedText=="Loading ..."? Center(child:Text(
                    recognizedText,
                    style: GoogleFonts.openSans(),
                  ),) :Text(
                    recognizedText,
                    style: GoogleFonts.openSans(),
                  ),
                ),
              ),
              // Align(
              //     alignment: Alignment.bottomCenter,
              //     child: Container(
              //       height: 100,
              //       width: double.infinity,
              //       padding: EdgeInsets.all(15),
              //       color: Color.fromRGBO(00, 00, 00, 0.7),
              //       child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           children: <Widget>[
              //             // IconButton(
              //             //     icon: Icon(
              //             //       Entypo.download,
              //             //       color: Colors.white,
              //             //       size: 40,
              //             //     ),
              //             //     onPressed: () async {
              //             //       final pdf = pw.Document();

              //             //       pdf.addPage(pw.Page(
              //             //           pageFormat: PdfPageFormat.a4,
              //             //           build: (pw.Context context) {
              //             //             return pw.Center(
              //             //               child: pw.Text(recognizedText),
              //             //             );
              //             //           }));

              //             //       imagePath = join(
              //             //           (await getApplicationDocumentsDirectory())
              //             //               .path,
              //             //           '${DateTime.now()}.pdf');
              //             //       final File file = File(imagePath);
              //             //       file.writeAsBytesSync(await pdf.save());
              //             //       print(imagePath);

              //             //       //To do firebase for storing pdf

              //             //       final status =
              //             //           await Permission.storage.request();

              //             //       if (status.isGranted) {
              //             //         final externalDir =
              //             //             await getExternalStorageDirectory();

              //             //         await FlutterDownloader.enqueue(
              //             //           url:
              //             //               "https://www.google.com/search?q=https://www.itl.cat/pngfile/big/10-100326_desktop-wallpaper-hd-full-screen-free-download-full.jpg;&sxsrf=ALeKk02uON2w1O-dqucDveUgu6WwiaVUzA:1617007949418&tbm=isch&source=iu&ictx=1&fir=j5LgEHLXLRAxRM%252CzfdbFylDAAK-oM%252C_&vet=1&usg=AI4_-kSECfbFgtJAqHs_t7OO8tbSrdIR7w&sa=X&ved=2ahUKEwj03rGDkNXvAhXBQ3wKHYM5CtAQ9QF6BAgPEAE#imgrc=j5LgEHLXLRAxRM",
              //             //           savedDir: externalDir.path,
              //             //           fileName: "download",
              //             //           showNotification: true,
              //             //           openFileFromNotification: true,
              //             //         );
              //             //       } else {
              //             //         print("Permission deined");
              //             //       }
              //             //     }),
              //             IconButton(
              //               icon: Icon(
              //                 Entypo.text_document,
              //                 color: Colors.white,
              //                 size: 40,
              //               ),
              //               onPressed: () {
              //                 Navigator.push(
              //                     this.context,
              //                     MaterialPageRoute(
              //                         builder: (context) =>
              //                             SummaryPage(imagePath)));
              //               },
              //             ),
              //             // IconButton(
              //             //   icon: Icon(
              //             //     Icons.share,
              //             //     color: Colors.white,
              //             //     size: 40,
              //             //   ),
              //             //   onPressed: () {
              //             //     Share.shareFiles([imagePath],
              //             //         subject: "Document");
              //             //   },
              //             // ),
              //           ]),
              //     ))
            ],
          ),
        ));
  }
}
