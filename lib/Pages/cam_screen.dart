import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project/Pages/preview_screen_recognized.dart';
import 'package:project/ScopedModel/appModel.dart';
import 'package:project/ScopedModel/main.dart';
import 'package:scoped_model/scoped_model.dart';

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
  int selectedCameraIndex;
  bool flash = true;
  double zoom = 0.0;
  File _image;
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

  Widget pickFromGalley() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }

    return Expanded(
      child: Align(
          alignment: Alignment.centerLeft,
          child: Column(children: [
            IconButton(
              onPressed: () {
                pickImage();
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

  Widget rectShapeContainer(String str) {
    return ScopedModelDescendant<Mainmodel>(
        builder: (BuildContext context, Widget child, Mainmodel model) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        padding: const EdgeInsets.all(15.0),
        decoration: new BoxDecoration(
          //you can get rid of below line also
          borderRadius: new BorderRadius.circular(10.0),
          //below line is for rectangular shape
          shape: BoxShape.rectangle,
          //you can change opacity with color here(I used black) for rect
          color: Colors.black.withOpacity(0.2),
          //I added some shadow, but you can remove boxShadow also.
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
            new Text(
              str,
              style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ],
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
      ),
    ));
  }

  Widget summaryButton(model) {
    return Column(
      children: [
        IconButton(
            icon: Icon(Octicons.note, color: Colors.white, size: 40),
            onPressed: () {
              model.getSummary(model.recognizedTxt);
            }),
        SizedBox(
          height: 10,
        ),
        Text(
          "Summarize",
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }
Widget saveButton(Mainmodel model){
   return Column(
      children: [
        IconButton(
            icon: Icon(Feather.save,
                color: Colors.white, size: 40),
            onPressed: () {
             saveBottomSheet(this.context);
             }
            ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Save",
          style: TextStyle(color: Colors.white),
        )
      ],
    );
}
Widget shareButton(Mainmodel model){
  return Column(
      children: [
        IconButton(
            icon: Icon(MaterialCommunityIcons.share,
                color: Colors.white, size: 40),
            onPressed: () {
              shareBottomSheet(this.context);
             
            }),
        SizedBox(
          height: 10,
        ),
        Text(
          "Share",
          style: TextStyle(color: Colors.white),
        )
      ],
    );
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
              model.recognizedTxt == " "
                  ? Container()
                  : model.sumTxt == " "
                      ? new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: SingleChildScrollView(
                              child: rectShapeContainer(model.recognizedTxt),
                            ))
                          ],
                        )
                      : new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            rectShapeContainer(model.sumTxt),
                          ],
                        ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 110,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 17),
                  color: Color.fromRGBO(00, 00, 00, 0.7),
                  child: model.loading
                      ? Center(
                          child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white)))
                      : model.recognizedTxt == " "
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                pickFromGalley(),
                                cameraControl(context, model),

                                libraryButton()
                                // flashControl()
                              ],
                            )
                          :model.sumTxt==" "? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                retakeButton(model),
                                summaryButton(model)
                              ],
                            ):Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                saveButton(model),
                                shareButton(model)
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

  pickImage() async {
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
    _cropImage(pickedFile.path);
  }

  _cropImage(filePath) async {
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
                      widget._model,
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
            padding: EdgeInsets.all(10),
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0))),
            child: Column(
              
              children: [
                ListTile(title: Text("Save as Text"),leading: Icon(MaterialCommunityIcons.format_text),),
                ListTile(title:  Text("Save as Pdf"),leading:Icon(MaterialCommunityIcons.file_pdf))
               
              
                  
              ],
            ),
          );
        });
  }
  void shareBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isDismissible: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.all(10),
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0))),
            child: Column(
              
              children: [
               ListTile(title: Text("Share as Text"),leading: Icon(MaterialCommunityIcons.format_text),),
                ListTile(title:  Text("Share as Pdf"),leading:Icon(MaterialCommunityIcons.file_pdf))
                  
              ],
            ),
          );
        });
  }
}
