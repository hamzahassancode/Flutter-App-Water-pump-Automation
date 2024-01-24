import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Signup/components/UserForm/signup_screen_UserPage.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/firebase_options.dart';
import 'package:flutter_auth/soket/AskForTanker.dart';
import 'package:flutter_auth/soket/SocketConnection.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'Screens/Login/components/login_screen.dart';
import 'Screens/Signup/components/UserORTanker.dart';
import 'Screens/Signup/components/choose_tank_photo/sliderTank/screensSlider/TankSlideShow.dart';
import 'Screens/Signup/components/choose_tank_photo/sliderTank/screensSlider/OtherTankSize.dart';
import 'Screens/Signup/firebase/auth.dart';
import 'Screens/System/system_screen.dart';
import 'TankerSystem/TankerForm/tankerSingup/TankerSignUpPage.dart';
import 'TankerSystem/TankerSocket/TankerSystemPage2.dart';
import 'TankerSystem/TankerSystemPage.dart';
import 'TankerSystem/setting/editTankerData.dart';
import 'TankerSystem/setting/settingTanker.dart';
import 'controller/dependency_injection.dart';
import 'network/local/cache_helper.dart';
import 'newFeature/CurvedBottomNavBar.dart';
import 'newFeature/Simple_Onboarding_Page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'newFeature/aboutUs.dart';
import 'newFeature/bills.dart';
import 'newFeature/howTheSystemWork.dart';
import 'newFeature/notification.dart';
import 'newFeature/profileUI/ProfileScreen.dart';
import 'newFeature/setting/component/editYourData.dart';
import 'newFeature/setting/component/reser_password.dart';
import 'newFeature/setting/setting.dart';
import 'TankerSystem/components/notificationTanker.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  await CacheHelper.init();
  await SocketConnection.initializeAppSocket();
  SocketConnection.tankerResponseToYou();
  OneSignal.initialize("9825dcdb-7434-420a-894a-1801f017386c");
  OneSignal.InAppMessages.addWillDisplayListener((event) {
    print("addWillDisplayListener main: ${event.message}");
  });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      CacheHelper.saveNotification(
        key: 'notification_${event.notification.notificationId}',
        notificationMessage: '${event.notification.body}',
      );
      OneSignal.Notifications.displayNotification(event.notification.notificationId);

      print("body is indedededed main: ${event.notification.body}");
    });

  DependencyInjection.init();
   runApp(ProviderScope(child: MyApp()));

}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context,WidgetRef ref) {

    print('MyApp extends ConsumerWidget ${OneSignal.User.pushSubscription.id}');
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth',
        theme: ThemeData(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: Colors.white,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0
                , backgroundColor: kPrimaryColor,
                shape: const StadiumBorder(),
                maximumSize: const Size(double.infinity, 56),
                minimumSize: const Size(double.infinity, 56),
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: kPrimaryLightColor,
              iconColor: kPrimaryColor,
              prefixIconColor: kPrimaryColor,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide.none,
              ),
            )),
        //home: const Auth(),
        routes: {
           '/':(context) => const Auth(),
          //'/':(context) => const WelcomeScreen(),
          'welcomeScreen':(context) => const WelcomeScreen(),
          'loginScreen':(context) => const LoginScreen(),
          'signupScreen':(context) => const SignUpScreen(),
          'system':(context) => const SystemScreen(),
          'Onboarding':(context) => const OnboardingPage1(),
          'ProfileScreen':(context) => ProfileScreen(),
          'AboutUsPage':(context) => AboutUsPage(),
          'HowItWorksPage':(context) => HowItWorksPage(),
          'NotificationPage':(context) => NotificationPage(notifications: [],),
          'CurvedNavPage':(context) => CurvedNavPage(),
          'SettingsPage':(context) => SettingsPage(),
          'PasswordResetPage':(context) => PasswordResetPage(),
          'TankSlideShow':(context)=>const TankSlideShow(),
          'OtherTankSize':(context)=>OtherTankSize(),
          'UserOrTanker':(context)=>UserOrTanker(),
          'TankerSignUpPage':(context)=>TankerSignUpPage(),
          'TankerSystemPage':(context)=>TankerSystemPage(),
          'SettingsPageTanker':(context)=>SettingsPageTanker(),
          'NotificationPageTanker':(context)=>NotificationPageTanker(notifications: [],),
          'EditYourDataPage':(context)=>EditYourDataPage(),
          'AskForTanker':(context)=>AskForTanker(),
          'TankerPage2':(context)=>TankerPage2(),
          'editTankerDataPage':(context)=>editTankerDataPage(),
          'Billing':(context)=>Billing(),


        }
    );
  }
}
