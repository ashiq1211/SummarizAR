import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/foundation.dart';

class Subscription extends StatelessWidget {
  @override
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
            titlePadding: EdgeInsets.fromLTRB(12, 8, 5, 4),
            titleTextStyle:
                TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold),
            title: 'Current Plan',
            tiles: [
              SettingsTile(
                subtitleTextStyle: TextStyle(color: Colors.grey[400]),
                titleTextStyle: TextStyle(color: Colors.grey[100]),
                title: 'Base Plan',
                leading: Icon(Icons.subscriptions, color: Colors.grey[100]),
                subtitle: "7 days Free Trial",
                trailing: Text(
                  "6 days left",
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ],
          ),
          SettingsSection(
            titlePadding: EdgeInsets.fromLTRB(12, 8, 5, 4),
            titleTextStyle:
                TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold),
            title: 'Go Premium',
            subtitle: Text(
              "Unlock benefits",
              style: TextStyle(color: Colors.grey[400]),
            ),
            tiles: [
              SettingsTile(
                  titleTextStyle: TextStyle(color: Colors.grey[400]),
                  title: 'INR 80',
                  leading: Icon(Icons.lock, color: Colors.grey[400]),
                  subtitle: "Enjoy Premium for 30 days",
                  subtitleTextStyle: TextStyle(color: Colors.grey[400]),
                  trailing: TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {},
                    child: Text('Unlock'),
                  )
                  // switchValue: true,
                  // onToggle: (bool value) {},
                  ),
              SettingsTile(
                  titleTextStyle: TextStyle(color: Colors.grey[400]),
                  title: 'INR 200',
                  // enabled: notificationsEnabled,
                  leading: Icon(Icons.lock, color: Colors.grey[400]),
                  subtitle: "Enjoy Premium for 90 days ",
                  subtitleTextStyle: TextStyle(color: Colors.grey[400]),
                  trailing: TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {},
                    child: Text('Unlock'),
                  )
                  // switchValue: true,
                  // onToggle: (value) {},
                  ),
              SettingsTile(
                  titleTextStyle: TextStyle(color: Colors.grey[400]),
                  title: 'INR 450',
                  subtitle: "Enjoy Premium for 6 months",
                  subtitleTextStyle: TextStyle(color: Colors.grey[400]),
                  // enabled: notificationsEnabled,
                  leading: Icon(Icons.lock, color: Colors.grey[400]),
                  trailing: TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {},
                    child: Text('Unlock'),
                  )
                  // switchValue: true,
                  // onToggle: (value) {},
                  ),
            ],
          ),
          SettingsSection(
            title: 'Misc',
            titlePadding: EdgeInsets.fromLTRB(12, 8, 5, 4),
            titleTextStyle:
                TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold),
            tiles: [
              SettingsTile(
                  titleTextStyle: TextStyle(color: Colors.grey[400]),
                  title: 'Terms and Conditions',
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
