import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/designUI.dart';
import 'package:flutter_auth/newFeature/profileUI/widgets/profile_list_item.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../Screens/Welcome/welcome_screen.dart';
import '../../model/UserModel.dart';
import '../../network/local/cache_helper.dart';


class ProfileScreen extends StatelessWidget {

  UserModel? cachedUserData = CacheHelper.getUserData(key: 'user_data');
  @override
  Widget build(BuildContext context) {

    var profileInfo = Expanded(
      child: Column(
        children: <Widget>[
          // AppBar(backgroundColor:Colors.blue),
          Container(
            height:  100,
            width:  100,
            margin: EdgeInsets.only(top: 30),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Color(0xFFFFFFFF),
                  radius: 50,
                  child: ClipOval(
                    child: Lottie.network(
                      "https://lottie.host/dab72ada-5a3c-4e75-bdce-54e9168de214/SS7K24yqSc.json",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      heightFactor: 15,
                      widthFactor: 15,
                      child: Icon(
                        LineAwesomeIcons.pen,
                        color: Colors.grey,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            cachedUserData?.name ?? '',
            style: TextStyle(
              fontSize:30,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          Text(
            cachedUserData?.email ?? '',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        profileInfo,
      ],
    );

    return Container(
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Color(0xFFBAD3FF),
            body: Column(
              children: <Widget>[
                header,
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      ProfileListItem(
                        icon: LineAwesomeIcons.user_shield,
                        text: 'Edit your data',
                        onTap: () {
                          // Handle the press event here
                          Navigator.of(context).pushNamed('EditYourDataPage');
                          print('Profile item pressed!');
                        },
                      ),
                      ProfileListItem(
                        icon: LineAwesomeIcons.question_circle,
                        text: 'About Us',
                        onTap: () {
                          Navigator.of(context).pushNamed('AboutUsPage');

                        },
                      ),
                      ProfileListItem(
                        icon: LineAwesomeIcons.cog,
                        text: 'Settings',
                        onTap: () {
                          Navigator.of(context).pushNamed('SettingsPage');
                        },
                      ),
                      ProfileListItem(
                        icon: LineAwesomeIcons.wired_network,
                        text: 'How the System work',
                        onTap: () {
                          Navigator.of(context).pushNamed('HowItWorksPage');


                        },
                      ),
                      ProfileListItem(
                        icon: LineAwesomeIcons.alternate_sign_out,
                        text: 'Logout',
                        hasNavigation: false,
                        onTap: () {
                          AwesomeDialog(

                            dialogType: DialogType.warning,
                            context: context,
                            btnCancelText: "Cancel", // Text for the cancel button
                            btnCancelOnPress: () {
                              Navigator.of(context).pop(); // Close the dialog without logging out
                            },
                            title: 'Logout',
                            btnCancelColor: Colors.grey,
                            btnOkColor: Colors.red,
                            dialogBackgroundColor: perfictBlue,
                            body: Text('Are you sure you want to logout ?'),
                            btnOkText: "Logout", // Text for the logout button
                            btnOkOnPress: () {
                              // Add your logout logic here

                              FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                  builder: (context) => WelcomeScreen()));                            },
                          ).show();

                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}