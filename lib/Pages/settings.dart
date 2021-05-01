import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/foundation.dart';

class settings extends StatelessWidget {
  @override
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String userEmail;
  void getCurrentUserEmail() async {
    final user = await _auth.currentUser;
    userEmail = user.email;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(fontSize: 18, color: Colors.grey[400]),
        ),
        elevation: 10,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SettingsList(
        backgroundColor: Colors.grey[900],
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile(
                
                switchActiveColor: Colors.grey,
                titleTextStyle: TextStyle(color: Colors.grey[400]),
                title: 'Swathy M',
                subtitleTextStyle: TextStyle(color: Colors.grey[600]),
                subtitle: 'Free User',
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://static.remove.bg/remove-bg-web/2a274ebbb5879d870a69caae33d94388a88e0e35/assets/start-0e837dcc57769db2306d8d659f53555feb500b3c5d456879b9c843d1872e7baa.jpg"),
                  radius: 40,
                  backgroundColor: Colors.transparent,
                ),
                trailing: Icon(Icons.edit, color: Colors.grey[400]),
                onPressed: (BuildContext context) {},
              ),
              // SettingsTile.switchTile(
              //   title: 'Use fingerprint',
              //   leading: Icon(Icons.fingerprint),
              //   // switchValue: value,
              //   onToggle: (bool value) {},
              // ),
            ],
          ),
          SettingsSection(
            titleTextStyle: TextStyle(color: Colors.grey[400]),
            title: 'Account',
            tiles: [
              SettingsTile(
                  titleTextStyle: TextStyle(color: Colors.grey[400]),
                  title: 'Phone number',
                  leading: Icon(Icons.phone, color: Colors.grey[400])),
              SettingsTile(
                  titleTextStyle: TextStyle(color: Colors.grey[400]),
                  title: "Email",
                  subtitleTextStyle: TextStyle(color: Colors.grey[600]),
                  subtitle: _auth.currentUser.email,
                  leading: Icon(Icons.email, color: Colors.grey[400])),
              SettingsTile(
                  titleTextStyle: TextStyle(color: Colors.grey[400]),
                  title: 'Sign out',
                  leading: Icon(Icons.exit_to_app, color: Colors.grey[400])),
            ],
          ),
          SettingsSection(
            titleTextStyle: TextStyle(color: Colors.grey[400]),
            title: 'Security',
            tiles: [
              SettingsTile(
                titleTextStyle: TextStyle(color: Colors.grey[400]),
                title: 'Lock app in background',
                leading: Icon(Icons.phonelink_lock, color: Colors.grey[400]),
                // switchValue: lockInBackground,
                // onToggle: (bool value) {
                //   setState(() {
                //     lockInBackground = value;
                //     notificationsEnabled = value;
                //   });
                // },
              ),
              SettingsTile(
                titleTextStyle: TextStyle(color: Colors.grey[400]),
                title: 'Use fingerprint',
                subtitleTextStyle: TextStyle(color: Colors.grey[600]),
                subtitle: 'Allow application to access stored fingerprint IDs.',
                leading: Icon(Icons.fingerprint, color: Colors.grey[400]),
                // onToggle: (bool value) {},
                // switchValue: false
              ),
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
