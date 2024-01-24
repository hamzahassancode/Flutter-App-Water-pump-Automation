import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/network/local/cache_helper.dart';

import '../../../TankerSystem/TankerSocket/TankerSystemPage2.dart';
import '../../../newFeature/CurvedBottomNavBar.dart';
import '../../../TankerSystem/TankerSystemPage.dart';
import '../../Welcome/welcome_screen.dart';

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context,snapshot){
          if (snapshot.hasData) {
            String email=CacheHelper.getData(key: 'Credential')??'SimpleUser';
            if (email=='SimpleUser') {
              return CurvedNavPage();
            }  else{
              return TankerPage2();
            }
          }  else{
            return WelcomeScreen();

          }
        }),
      )
    );
  }
}
