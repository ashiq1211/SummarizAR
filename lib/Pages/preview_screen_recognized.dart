import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:project/Pages/summary.dart';
import 'package:share/share.dart';

class PreviewScreen extends StatefulWidget {
  final File imgPath;
  final String fileName;
  PreviewScreen({this.imgPath, this.fileName});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  Size _imageSize;
  String recognizedText = "Loading ...";

  void _initializeVision() async {
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
          recognizedText += line.text;
          recognizedText += "+";
        });
        print(recognizedText);
      }
    }
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

  @override
  void initState() {
    _initializeVision();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Text(recognizedText),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    color: Color.fromRGBO(00, 00, 00, 0.7),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Entypo.download,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  this.context,
                                  MaterialPageRoute(
                                      builder: (context) => SummaryPage()));
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Entypo.text_document,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  this.context,
                                  MaterialPageRoute(
                                      builder: (context) => SummaryPage()));
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: () {
                              Share.share(recognizedText);
                            },
                          ),
                        ]),
                  ))
            ],
          ),
        ));
  }
}
