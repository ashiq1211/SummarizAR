import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(fontSize: 18, color: Colors.grey[400]),
        ),
        elevation: 10,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(child: Text("No new Notification!")),
    );
  }
}
