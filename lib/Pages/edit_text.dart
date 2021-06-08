import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_quill/models/rules/insert.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:flutter_quill/flutter_quill.dart';
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

class EditText extends StatefulWidget {
  final String text;
  EditText([this.text]);
  @override
  _EditTextState createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  @override
  QuillController controller = QuillController.basic();
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Mainmodel>(
        builder: (BuildContext context, Widget child, Mainmodel model) {
      return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              QuillToolbar.basic(controller: model.controller),
              Expanded(
                child: Container(
                  child: QuillEditor.basic(
                    controller: model.controller,
                    readOnly: false, // true for view only mode
                  ),
                ),
              )
              // QuillToolbar.basic(controller: controller),
              // Expanded(
              //   child: Container(
              //     child: QuillEditor.basic(
              //       controller: controller,
              //       readOnly: false, // true for view only mode
              //     ),
              //   ),
              // )
            ],
          ));
    }

        // Widget body(BuildContext context) {
        //   builder:
        //   (BuildContext context) {
        //     return Container(
        //       child: Column(
        //         children: [
        //           QuillToolbar.basic(controller: _controller),
        //           Expanded(
        //             child: Container(
        //               child: QuillEditor.basic(
        //                 controller: _controller,
        //                 readOnly: false, // true for view only mode
        //               ),
        //             ),
        //           )
        //         ],
        //       ),
        //     );
        //   };
        // }
        );
  }
}
