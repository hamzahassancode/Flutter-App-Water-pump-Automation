
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/designUI.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../../model/UserModel.dart';
import '../../../network/local/cache_helper.dart';
import '../../Welcome/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../repo/user_repositry.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shadowColor:Color(0xFFFFFFFF),
      child: FutureBuilder<Map<String, dynamic>>(
        future: UserRepository().getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                width: 40, // Set the desired width
                height: 40, // Set the desired height
                child: CircularProgressIndicator(
                  // Set other properties as needed
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Map<String, dynamic> userData = snapshot.data!;
            UserModel userModel = UserModel.fromJson(userData);
            CacheHelper.saveUserData(key: 'user_data', userData: userModel);

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(userData['name'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 25),),
                  accountEmail: Text(userData['email'],style: TextStyle(color: Colors.black),),
                  currentAccountPicture: Hero(
                    tag: 'userImage',
                    child: CircleAvatar(
                      backgroundColor: Color(0xFFFFFFFF),
                      child: ClipOval(
                        child: Lottie.network(
                          "https://lottie.host/dab72ada-5a3c-4e75-bdce-54e9168de214/SS7K24yqSc.json",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFD9E4FA),
                    // image: DecorationImage(
                    //   fit: BoxFit.fill,
                    //   image: NetworkImage(
                    //     'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg',
                    //   ),
                    // ),
                  ),
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
                  leading: Hero(

                      tag: 'hero_noti',
                      child: Icon(Icons.notifications)),
                  title: Text('notifications'),
                  onTap: () {
                    Navigator.of(context).pushNamed('NotificationPage');
                  },
                  trailing: ClipOval(
                    child: Container(
                      color: Colors.red,
                      width: 20,
                      height: 20,
                      child: Center(
                        child: Text(
                          '${CacheHelper.getAllNotifications().length}',
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
                    Navigator.of(context).pushNamed('SettingsPage');

                  },
                ),


                ListTile(
                  leading: Icon(Icons.donut_large),
                  title: Text('Billing'),
                  onTap: () {
                    Navigator.of(context).pushNamed('Billing');                    // Add your logic for "How the System Works"
                  },
                ),

                ListTile(
                  leading: Icon(Icons.water_drop_rounded),
                  title: Text('Ask For Tanker'),
                  onTap: () {
                    Navigator.of(context).pushNamed('AskForTanker');
                    // Add your logic for "How the System Works"
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
                                CacheHelper.removeAllNotifications();
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