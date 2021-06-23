import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:project/Model/doc.dart';
import 'package:project/Pages/pdf_preview.dart';
class ListTileSummary extends StatefulWidget {
 final Doc doc;
  ListTileSummary(this.doc);

  @override
  _ListTileSummaryState createState() => _ListTileSummaryState();
}

class _ListTileSummaryState extends State<ListTileSummary> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PdfPreview(widget.doc),
                  fullscreenDialog: true));
        },
        minLeadingWidth: 16.0,
        tileColor: Color.fromRGBO(64, 75, 96, .9),
        leading: Icon(
          MaterialCommunityIcons.pdf_box,
          color: Colors.white,
          size: 45,
        ),
        title:
            Text(widget.doc.name, style: TextStyle(color: Colors.white, fontSize: 15)),
        subtitle: Text(
          widget.doc.date,
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));
  }
}