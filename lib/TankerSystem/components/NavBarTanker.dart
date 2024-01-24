import 'package:flutter/material.dart';
import 'package:flutter_auth/components/designUI.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import '../../model/TankerModel.dart';
import '../../repo/Tanker_repositry.dart';
import '../../Screens/Welcome/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


class NavBarTanker extends StatelessWidget {
  const NavBarTanker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shadowColor:Color(0xFFFFFFFF),
      child: FutureBuilder<Map<String, dynamic>>(
        future: TankerRepository().getDataTanker(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error} hiiiiiii');
          } else {
            Map<String, dynamic> tankerData = snapshot.data!;
            print('tnaker data ${tankerData}');
            TankerModel tankerModel = TankerModel.fromJson(tankerData);


            return ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(tankerModel.name.toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 25),),
                  accountEmail: Text(tankerModel.email.toString(),style: TextStyle(color: Colors.black),),
                  currentAccountPicture: Hero(
                    tag: 'userImage',
                    child: CircleAvatar(
                      backgroundColor: TankerPageColorDark,
                      child: ClipOval(
                        child: Lottie.network(
                          "https://lottie.host/dab72ada-5a3c-4e75-bdce-54e9168de214/SS7K24yqSc.json",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: TankerPageColor,                  ),
                ),
                ListTile(
                  leading: Icon(LineAwesomeIcons.person_entering_booth),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.of(context).pushNamed('ProfileScreen');
                    // Add your logic for "How the System Works"
                  },
                ),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('notifications'),
                  onTap: () {
                    Navigator.of(context).pushNamed('NotificationPageTanker');
                  },
                  trailing: ClipOval(
                    child: Container(
                      color: Colors.red,
                      width: 20,
                      height: 20,
                      child: Center(
                        child: Text(
                          '8',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),


                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    Navigator.of(context).pushNamed('SettingsPageTanker');

                  },
                ),

                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('How the System Works'),
                  onTap: () {
                    Navigator.of(context).pushNamed('HowItWorksPage');
                    // Add your logic for "How the System Works"
                  },
                ),


                ListTile(
                  leading: Icon(Icons.people),
                  title: Text('About Us'),
                  onTap: () {
                    Navigator.of(context).pushNamed('AboutUsPage');
                    // Add your logic for "About Us"
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return customAlertDialog(
                          action1: 'Logout',
                          action2: 'Close',
                          onPressedAction1: () {
                            Navigator.of(context).pop();
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WelcomeScreen(),
                              ),
                            );
                          },
                          onPressedAction2: () {
                            Navigator.of(context).pop();
                          },
                          title: 'Logout',
                          content: 'Are you sure you want to logout?',
                          contentTextStyle: TextStyle(fontSize: 16.0),
                          backgroundColor: perfictBlue,
                        );
                      },
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}