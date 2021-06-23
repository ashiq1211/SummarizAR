import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project/Pages/edit_text.dart';
import 'package:project/Pages/preview_screen_recognized.dart';
import 'package:project/ScopedModel/appModel.dart';
import 'package:project/ScopedModel/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';

class CameraScreen extends StatefulWidget {
  // const CameraScreen({Key key, this.user},this._model) : super(key: key);
  // final UserCredential user;
  final AppModel _model;
  CameraScreen([this._model]);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController cameraController;
  List cameras;
  int flag = 0;
  var pdfPathActual;
  var pdfPathSummary;
bool recognizeloading=false;
  File fileActual;
   File fileSummary;
   File file;
   final pdf = pw.Document();
  final pdfActual = pw.Document();
  final pdfSummary = pw.Document();
  DateTime date = DateTime.now();
  int selectedCameraIndex;
  bool flash = true;
  double zoom = 0.0;
  File _image;
  bool retake = false;
  bool summaryloading=false;
  final picker = ImagePicker();
  Future initCamera(CameraDescription cameraDescription) async {
    if (cameraController != null) {
      await cameraController.dispose();
    }

    cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);

    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    if (cameraController.value.hasError) {
      print('Camera Error ${cameraController.value.errorDescription}');
    }

    try {
      await cameraController.initialize();
    } catch (e) {
      String errorText = 'Error ${e.code} \nError message: ${e.description}';
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget cameraPreview() {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return Text(
        'Loading',
        style: TextStyle(
            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
      );
    }

    var camera = cameraController.value;

    final size = MediaQuery.of(this.context).size;

    var scale = size.aspectRatio * camera.aspectRatio;

    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(cameraController),
      ),
    );
  }

  Widget cameraControl(context, model) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(
                Icons.camera,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                onCapture(context, model);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget pickFromGalley(model) {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }

    return Expanded(
      child: Align(
          alignment: Alignment.centerLeft,
          child: Column(children: [
            IconButton(
              onPressed: () {
                pickImage(model);
              },
              icon: Icon(
                Ionicons.md_image,
                color: Colors.white,
                size: 40,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Import",
              style: TextStyle(color: Colors.white),
            )
          ])),
    );
  }

  Widget flashControl() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }

    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          icon: Icon(
            flash ? Icons.flash_on : Icons.flash_off,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {
            setState(() {
              flash = !flash;
            });
            print(flash);
            flash
                ? cameraController.setFlashMode(FlashMode.always)
                : cameraController.setFlashMode(FlashMode.off);
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    availableCameras().then((value) {
      cameras = value;
      if (cameras.length > 0) {
        setState(() {
          selectedCameraIndex = 0;
        });
        initCamera(cameras[selectedCameraIndex]).then((value) {});
      } else {
        print('No camera available');
      }
    }).catchError((e) {
      print('Error : ${e.code}');
    });
  }

  Widget rectShapeARContainer(String str,String sub) {
    return ScopedModelDescendant<Mainmodel>(
        builder: (BuildContext context, Widget child, Mainmodel model) {
      return  Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            padding: const EdgeInsets.only(left: 15.0, bottom: 15),
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(10.0),
              //below line is for rectangular shape
              shape: BoxShape.rectangle,
              color: Colors.black.withOpacity(0.2),
              //added some shadow
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5.0,
                  offset: new Offset(5.0, 5.0),
                ),
              ],
            ),
            child: new Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: OutlinedButton(
                        child: Icon(
                          AntDesign.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditText(str),
                              ));
                          
                        })),SizedBox(width: 10,),
                        Align(
                    alignment: Alignment.topRight,
                    child: OutlinedButton(
                        child: Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        onPressed: () {
                           createSavepdf(str);
                          
                        })),SizedBox(width: 10,),
                        
                        Align(
                    alignment: Alignment.topRight,
                    child: OutlinedButton(
                        child: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        onPressed: () {
                            Share.share(str,subject: sub);
                          
                        })),],),
                
                new GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditText(str),
                ));
          },
          child:Text(
                  str,
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                 ) ]
            ),
          );
    });
  }

  Widget libraryButton() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }

    return Expanded(
        child: Align(
      alignment: Alignment.centerRight,
      child: Column(
        children: [
          IconButton(
              icon: Icon(Icons.folder_open, color: Colors.white, size: 40),
              onPressed: () {
                Navigator.pop(this.context);
              }),
          SizedBox(
            height: 10,
          ),
          Text(
            "  Library",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    ));
  }

  Widget summaryButton(Mainmodel model) {
    return Column(
      children: [
        IconButton(
            icon: Icon(Octicons.note, color: Colors.white, size: 40),
            onPressed: () {
            
              model.getSummary(model.recognizedTxt).then((value) {
                  createAndCloudPdf(model.recognizedTxt,model.sumTxt, model).then((value) {
              print("done");
                
              });
              });
              
           
            }),
        SizedBox(
          height: 10,
        ),
        Text(
          "  Summarize",
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  Widget saveButton(Mainmodel model) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            icon: Icon(Feather.save, color: Colors.white, size: 40),
            onPressed: () {
              saveBottomSheet(this.context);
            }),
        SizedBox(
          height: 10,
        ),
        Text(
          "  Save",
          style: TextStyle(color: Colors.white),
        )
      ],
    ));
  }

  Widget shareButton(Mainmodel model) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            icon: Icon(MaterialCommunityIcons.share,
                color: Colors.white, size: 40),
            onPressed: () {
              shareBottomSheet(this.context,model.recognizedTxt);
            }),
        SizedBox(
          height: 10,
        ),
        Text(
          "Share",
          style: TextStyle(color: Colors.white),
        )
      ],
    ));
  }

  Widget libButton(Mainmodel model) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            icon: Icon(Icons.folder_open, color: Colors.white, size: 40),
            onPressed: () {
              Navigator.popAndPushNamed(this.context, "/homePage");
            }),
        SizedBox(
          height: 10,
        ),
        Text(
          "  Library",
          style: TextStyle(color: Colors.white),
        )
      ],
    ));
  }

  Widget retakeButton(Mainmodel model) {
    return Column(
      children: [
        IconButton(
            icon: Icon(MaterialCommunityIcons.camera_retake,
                color: Colors.white, size: 40),
            onPressed: () {
              model.setRecoTxt = " ";
            }),
        SizedBox(
          height: 10,
        ),
        Text(
          "Retake",
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  Widget addText(Mainmodel model) {
    return Column(
      children: [
        IconButton(
            icon: Icon(AntDesign.addfile, color: Colors.white, size: 35),
            onPressed: () {
              setState(() {
                model.isAppend = 1;
                retake = true;
              });
            }),
        SizedBox(
          height: 10,
        ),
        Text(
          "  Add Text",
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  void createText() {}
  Future createAndCloudPdf(String recognizedText,String summary,Mainmodel model) async {
    date = DateTime.now();
   
      pdfActual.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(recognizedText),
          );
        }));
        pdfSummary.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(summary),
          );
        }));
   pdfPathActual= join((await getExternalStorageDirectory()).path, 'ActualText ${date}.pdf');
   pdfPathSummary= join((await getExternalStorageDirectory()).path, 'Summary ${date}.pdf');
     fileActual=File(pdfPathActual);
     fileSummary=File(pdfPathSummary);

    fileActual.writeAsBytesSync(await pdfActual.save());
  
    fileSummary.writeAsBytesSync(await pdfSummary.save());

   model.putDoc(fileActual.readAsBytesSync(), fileSummary.readAsBytesSync(), date);
 
    fileActual.delete();
                fileSummary.delete();
 

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

  void sharePdf() {}
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Mainmodel>(
        builder: (BuildContext context, Widget child, Mainmodel model) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: cameraPreview(),
              ),
              (model.recognizedTxt == " " ||
                      (model.recognizedTxt != " " && retake))
                  ? Container()
                  : model.sumTxt == " "
                      ? new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: SingleChildScrollView(
                              child: rectShapeARContainer(model.recognizedTxt,"Actual Text"),
                            ))
                          ],
                        )
                      : new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            rectShapeARContainer(model.sumTxt,"Summary"),
                          ],
                        ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 110,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 17),
                  color: Color.fromRGBO(00, 00, 00, 0.7),
                  child: model.load
                      ? Center(
                          child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white)))
                      : (model.recognizedTxt == " " ||
                              (model.recognizedTxt != " " && retake))
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                pickFromGalley(model),
                                cameraControl(context, model),

                                libraryButton()
                                // flashControl()
                              ],
                            )
                          : model.sumTxt == " "
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    retakeButton(model),
                                    summaryButton(model),
                                    addText(model)
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    // Icon(Icons.book),
                                    //    Icon(Icons.book),
                                    //       Icon(Icons.book)
                                    libButton(model),
                                    addNew(model)
                                  ],
                                ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
Widget addNew(Mainmodel model){
  return Column(

    children: [

    IconButton(onPressed: (){
      model.setRecoTxt = " ";
      model.setSumTxt=" ";

    }, icon: Icon(Feather.camera,color: Colors.white, size: 40)),
    SizedBox(
          height: 10,
        ),
        Text(
          "Take New",
          style: TextStyle(color: Colors.white),
        )
  ],);
} 
  onCapture(context, Mainmodel model) async {
   
    try {
      final name = DateTime.now();
      var imagePath = join((await getApplicationDocumentsDirectory()).path,
          '${DateTime.now()}.png');

      await cameraController.takePicture().then((XFile file) {
        setState(() {
          _image = File(file.path);

          print(imagePath);
        });
      });
      model.recognizeText(_image);
      setState(() {
        retake = false;
        file.delete();
      });
      // _cropImage(_image.path);

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => PreviewScreen(
      //               widget._model,
      //               _image,
      //               "$name.png",
      //             )));

    } catch (e) {
      showCameraException(e);
    }
     
  }

  void showCameraException(e) {}

  pickImage(model) async {
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
void showToast() {
    Fluttertoast.showToast(
        msg: 'Document has been saved !.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.yellow);
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


  void saveBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isDismissible: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            height: 140,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0))),
            child: Column(
              children: [
                ListTile(
                  title: Text("Save as Text"),
                  leading: Icon(MaterialCommunityIcons.format_text),
                ),
                ListTile(
                    title: Text("Save as Pdf"),
                    leading: Icon(MaterialCommunityIcons.file_pdf))
              ],
            ),
          );
        });
  }

  void shareBottomSheet(BuildContext context,text) {
    showModalBottomSheet(
        isDismissible: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            height: 140,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0))),
            child: Column(
              children: [
                ListTile(
                  title: Text("Share as Text"),
                  onTap: (){
                  
                  },
                  leading: Icon(MaterialCommunityIcons.format_text),
                ),
                ListTile(
                    title: Text("Share as Pdf"),
                    leading: Icon(MaterialCommunityIcons.file_pdf))
              ],
            ),
          );
        });
  }
}
