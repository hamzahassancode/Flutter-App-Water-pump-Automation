import 'package:flutter/material.dart';
import '../../components/designUI.dart';
import '../../model/UserModel.dart';
import '../../repo/Tanker_repositry.dart';

class SettingsPageTanker extends StatefulWidget {
  @override
  _SettingsPageTankerState createState() => _SettingsPageTankerState();
}

class _SettingsPageTankerState extends State<SettingsPageTanker> {
  bool notificationEnabled = true;
  bool darkModeEnabled = false;
  double textSize = 16.0;
  String selectedLanguage = 'English';
  String selectedTheme = 'Light';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: TankerPageColor,
      appBar: customAppBarTanker(context, 'Setting'),
      body: FutureBuilder<Map<String, dynamic>>(
        future: TankerRepository().getDataTanker(),
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
                      title: Text('Edit your Data'),
                      onTap: () {
                        Navigator.of(context).pushNamed('editTankerDataPage');
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
