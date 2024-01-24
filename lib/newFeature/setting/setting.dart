import 'package:flutter/material.dart';
import 'package:flutter_auth/repo/user_repositry.dart';
import '../../components/designUI.dart';
import '../../model/UserModel.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationEnabled = true;
  bool darkModeEnabled = false;
  double textSize = 16.0;
  String selectedLanguage = 'English';
  String selectedTheme = 'Light';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: perfictBlue,
      appBar: customAppBar(context, 'Setting'),
      body: FutureBuilder<Map<String, dynamic>>(
        future: UserRepository().getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                child: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error} ');
          } else {
            Map<String, dynamic> UserData = snapshot.data!;
            print('tanker data ${UserData}');
            UserModel userModel = UserModel.fromJson(UserData);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Username'),
                      subtitle: Text(
                        userModel?.name ?? '',
                      ),
                      onTap: () {
                        // Open a dialog or navigate to a screen for editing the username
                      },
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Email'),
                      subtitle: Text(
                        userModel?.email ?? '',
                      ),
                      onTap: () {
                        // Open a dialog or navigate to a screen for editing the email
                      },
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Rest password'),
                      onTap: () {
                        Navigator.of(context).pushNamed('PasswordResetPage');
                      },
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Edit your data'),
                      onTap: () {
                        Navigator.of(context).pushNamed('EditYourDataPage');
                      },
                    ),
                  ),

                  Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Enable Notifications'),
                      trailing: Switch(
                        value: notificationEnabled,
                        onChanged: (value) {
                          setState(() {
                            notificationEnabled = value;
                          });
                        },
                      ),
                    ),
                  ),



                ],
              ),
            );
          }
        },
      ),
    );
  }
}
