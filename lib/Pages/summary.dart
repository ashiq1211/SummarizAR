import 'package:flutter/material.dart';
import 'package:project/Pages/home.dart';
import 'package:project/ScopedModel/main.dart';
import 'package:scoped_model/scoped_model.dart';
class SummaryPage extends StatefulWidget {
  var path;
  SummaryPage(this.path);
  @override
  _SummaryPageState createState() => _SummaryPageState();
}


class _SummaryPageState extends State<SummaryPage> {
   Widget body(Mainmodel model, BuildContext context) {

       if (model.load) {

      return showLoadingIndicator(context);
    } else {
      return Container(
        child: Container(
          margin: const EdgeInsets.all(15.0),
          // adding padding

          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            // adding borders around the widget
            border: Border.all(
              color: Color.fromRGBO(64, 75, 96, .9),
              width: 5.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  scrollDirection: Axis.vertical,
                  child: Text(
                    model.sumTxt,
                    style: TextStyle(
                      color: Colors.black,
                      // fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      // letterSpacing: 3,
                      // wordSpacing: 2,
                    ),

                  ),
                ),
                
              ),

            ],
          ),

        ),
      );
    }
   }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Mainmodel>(
        builder: (BuildContext context, Widget child, Mainmodel model) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
                  onPressed: () {
                   
                   
                    Navigator.pushAndRemoveUntil(
                      this.context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  icon: new Icon(Icons.home),
                  
                ),title: Text(
                 "Summary",textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                actions: [
                  IconButton(
                    onPressed: () async {
                     
                    },
                    icon: new Icon(Icons.picture_as_pdf),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (model.load) {
                        return;
                      }

                    
                    },
                    icon: new Icon(Icons.share),
                  ),
                ]
      ),
      body: body(model, context)
    );
  });}
   Widget showLoadingIndicator(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          backgroundColor: Colors.black,
          content: Container(
              padding: EdgeInsets.all(16),
              color: Colors.black,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _getLoadingIndicator(),
                    _getHeading(context),
                    _getText("Summarizing Text ...")
                  ])),
        ));
  }

  Padding _getLoadingIndicator() {
    return Padding(
        child: Container(
            child: CircularProgressIndicator(strokeWidth: 3),
            width: 32,
            height: 32),
        padding: EdgeInsets.only(bottom: 16));
  }

  Widget _getHeading(context) {
    return Padding(
        child: Text(
          'Please wait …',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        padding: EdgeInsets.only(bottom: 4));
  }

  Text _getText(String displayedText) {
    return Text(
      displayedText,
      style: TextStyle(color: Colors.white, fontSize: 14),
      textAlign: TextAlign.center,
    );
  }
}