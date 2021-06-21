import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "gist",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white70,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        // iconTheme: IconThemeData(color: Color.fromRGBO(64, 75, 96, .9)),
        backgroundColor: Colors.white30,
      ),
      body: Container(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.white54,
            width: 3,
          )),
          child: Text(
            "About gist",
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Georgia',
                letterSpacing: 1.0),
          ),
        ),
      ),
    );
  }
}
