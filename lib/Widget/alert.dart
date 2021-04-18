import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
class AlertWidget extends StatelessWidget {
  final String content;
  AlertWidget(this.content);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
             
              title: 
              Column(children: [ Text('Oops!',style: TextStyle(fontSize: 25), textAlign: TextAlign.center,),
                SizedBox(height: 10,),
                   Icon(AntDesign.exclamationcircleo,size: 40,)],),
             
              content:Text(content,textAlign: TextAlign.center),


              
                
               
               
              
              actions: <Widget>[
                TextButton(
               
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
  }
}