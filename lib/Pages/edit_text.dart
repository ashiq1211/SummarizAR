import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:project/ScopedModel/main.dart';
import 'package:scoped_model/scoped_model.dart';

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
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(64, 75, 96, .9),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
                onPressed: () {
                  // do something
                  model.recognizedText =
                      model.controller.document.toPlainText();
                  Navigator.of(context).pushNamed("/cameraPage");
                },
              )
            ],
          ),
          body: Container(
            padding: EdgeInsets.only(
              top: 14.0,
              bottom: 14.0,
              left: 14.0,
              right: 14.0,
            ),
            child: Column(
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
            ),
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
