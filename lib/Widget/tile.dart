import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:project/Model/doc.dart';
import 'package:project/Pages/pdf_preview.dart';
class ListTileWidget extends StatelessWidget {
  final Doc doc;
  ListTileWidget(this.doc);
  @override
  Widget build(BuildContext context) {
    return ListTile(onTap: (){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PdfPreview(doc), fullscreenDialog: true));
    },
      leading: Icon(MaterialCommunityIcons.pdf_box,color: Colors.red,size: 45,),
      title: Text(doc.name,style: TextStyle(color: Colors.black,fontSize: 17)),
      subtitle: Text(doc.date,style: TextStyle(color: Colors.grey,fontSize: 13),),
      
    );
  }
}