import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project/Pages/preview_screen_recognized.dart';
import 'package:project/ScopedModel/main.dart';

class CameraScreen extends StatefulWidget {
  // const CameraScreen({Key key, this.user},this._model) : super(key: key);
  // final UserCredential user;
   final Mainmodel _model;
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

    return 
    Transform.scale(
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

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewScreen(
                    imgPath: _image,
                    fileName: "$name.png",
                  )));
    } catch (e) {
      showCameraException(e);
    }
  }

  void showCameraException(e) {}

  pickImage() async {
    final name = DateTime.now();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.push(
            this.context,
            MaterialPageRoute(
                builder: (context) => PreviewScreen(
                      imgPath: _image,
                      fileName: "$name.png",
                    )));
      } else {
        print('No image selected.');
      }
    });
  }
}
