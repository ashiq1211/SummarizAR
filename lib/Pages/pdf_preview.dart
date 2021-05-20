import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project/Model/doc.dart';
import 'package:project/Pages/settings.dart';
import 'package:share/share.dart';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPreview extends StatefulWidget {
  final Doc doc;
  PdfPreview([this.doc]);
  @override
  _PdfPreviewState createState() => _PdfPreviewState();
}

class _PdfPreviewState extends State<PdfPreview> {
  // void _select(
  //   choice,
  // ) async {
  //   print(choice);

  //   if (choice == "Logout") {
  //     print(choice);
  //     await FirebaseAuth.instance.signOut().then((value) {
  //       Navigator.pushReplacementNamed(context, "/login");
  //     });
  //   }
  // }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacementNamed(context, "/login");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: new Icon(Icons.arrow_back),
        ),
        title: Text(
          widget.doc.name,
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var imagePath = join(
                  (await getApplicationDocumentsDirectory()).path,
                  '${widget.doc.path}.pdf');
              print(imagePath);
              bool exist = await File(imagePath).exists();
              if (exist) {
                print("und");
                Share.shareFiles([imagePath], subject: "Document");
              } else {
                var data = await http.get(Uri.parse(widget.doc.link));
                var bytes = data.bodyBytes;
                var imagePath = join(
                    (await getApplicationDocumentsDirectory()).path,
                    '${widget.doc.path}.pdf');
                final file = File(imagePath);
                file.writeAsBytes(bytes);
                Share.shareFiles([imagePath], subject: "Document");
              }
            },
            icon: new Icon(Icons.share),
          ),
          IconButton(
            onPressed: () {
              _settingModalBottomSheet(context);
            },
            icon: new Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SfPdfViewer.network(widget.doc.link),
    );
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
                          'Import Image',
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
                      onTap: () => _signOut(context),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
