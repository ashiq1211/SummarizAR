import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/foundation.dart';

class Subscription extends StatelessWidget {
  @override
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String userName = "Please tell us your name";
  void getCurrentUserEmail() async {
    final user = await _auth.currentUser;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Subscriptions",
          style: TextStyle(fontSize: 18, color: Colors.grey[400]),
        ),
        elevation: 10,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SettingsList(
        backgroundColor: Colors.grey[900],
        sections: [
          SettingsSection(
            titleTextStyle: TextStyle(color: Colors.grey[400]),
            title: 'Free User Account',
            tiles: [
              SettingsTile(
                titleTextStyle: TextStyle(color: Colors.grey[400]),
                title: 'Subscriptions',
                leading: Icon(Icons.subscriptions, color: Colors.grey[400]),
              ),
            ],
          ),
          SettingsSection(
            titleTextStyle: TextStyle(color: Colors.grey[400]),
            title: 'Security',
            tiles: [
              SettingsTile(
                titleTextStyle: TextStyle(color: Colors.grey[400]),
                title: 'Change password',
                leading: Icon(Icons.lock, color: Colors.grey[400]),
                // switchValue: true,
                // onToggle: (bool value) {},
              ),
              SettingsTile(
                titleTextStyle: TextStyle(color: Colors.grey[400]),
                title: 'Enable Notifications',
                // enabled: notificationsEnabled,
                leading:
                    Icon(Icons.notifications_active, color: Colors.grey[400]),
                // switchValue: true,
                // onToggle: (value) {},
              ),
            ],
          ),
          SettingsSection(
            titleTextStyle: TextStyle(color: Colors.grey[400]),
            title: 'Misc',
            tiles: [
              SettingsTile(
                  titleTextStyle: TextStyle(color: Colors.grey[400]),
                  title: 'Terms of Service',
                  leading: Icon(Icons.description, color: Colors.grey[400])),
              SettingsTile(
                  titleTextStyle: TextStyle(color: Colors.grey[400]),
                  title: 'Open source licenses',
                  leading: Icon(Icons.collections_bookmark,
                      color: Colors.grey[400])),
            ],
          ),
        ],
      ),
    );
  }
}
