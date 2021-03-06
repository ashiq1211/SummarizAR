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

  Widget cameraControl(context) {
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
                onCapture(context);
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
        child: IconButton(
          onPressed: () {
            pickImage();
          },
          icon: Icon(
            Ionicons.md_image,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: cameraPreview(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 120,
                width: double.infinity,
                padding: EdgeInsets.all(15),
                color: Color.fromRGBO(00, 00, 00, 0.7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    pickFromGalley(),
                    cameraControl(context),
                    flashControl()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  onCapture(context) async {
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

      _cropImage(_image.path);
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
}
