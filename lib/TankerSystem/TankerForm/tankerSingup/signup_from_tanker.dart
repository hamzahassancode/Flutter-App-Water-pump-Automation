import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/repo/user_repositry.dart';
import '../../../../../components/already_have_an_account_acheck.dart';
import '../../../../../constants.dart';
import '../../../../../repo/Tanker_repositry.dart';
import '../../../Screens/Login/components/login_screen.dart';



class SignUpFormTanker extends StatefulWidget {
  const SignUpFormTanker({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpFormTanker> {
  TankerRepository tankerRepository = TankerRepository();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameControllerTanker = TextEditingController();
  final TextEditingController _emailControllerTanker = TextEditingController();
  final TextEditingController _passwordControllerTanker = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isPasswordVisible = false;
  Position? _currentPosition;



  @override
  void initState() {
    super.initState();
    // Register UserRepository instance with GetX
    Get.put(UserRepository());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: defaultPadding),
            //name
            TextFormField(

              controller: _nameControllerTanker,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your name",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),


              ),

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: 10),

            //email
            TextFormField(
              controller: _emailControllerTanker,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.email),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!GetUtils.isEmail(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            //password
            TextFormField(
              controller: _passwordControllerTanker,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            //phone number
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your phone number",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.phone),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                } else if (!GetUtils.isPhoneNumber(value)) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            //location button
            ElevatedButton(
              style: ElevatedButton.styleFrom(

                backgroundColor: _currentPosition != null? Colors.grey:Colors.greenAccent,
              ),
              child: _currentPosition != null?Text("Your location are taken"):Text("press to Share your location with us"),
              onPressed: () async {
                _permission();
                _getCurrentLocation();
                setState(() {

                });
              },
            ),
            SizedBox(height: 10),



            //signup button
            GestureDetector(
              child: ElevatedButton(
                onPressed: () async {

                  if (_formKey.currentState!.validate()) {
                    if (_currentPosition==null) {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'you must share your location ',
                      ).show();

                    }else{
                      await tankerRepository.signUpTanker(
                      context,
                      _nameControllerTanker,
                      _emailControllerTanker,
                      _passwordControllerTanker,
                      _phoneController,
                      _currentPosition!.longitude,
                      _currentPosition!.latitude,
                    );
                    }

                  }
                },
                child: Text("Sign Up".toUpperCase()),
              ),
            ),

            const SizedBox(height: defaultPadding),
            SizedBox(height: 10),

            //AlreadyHaveAnAccountCheck
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 30,),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameControllerTanker.dispose();
    _emailControllerTanker.dispose();
    _passwordControllerTanker.dispose();

    // Dispose UserRepository instance when the widget is disposed
    Get.delete<UserRepository>();

    super.dispose();
  }
  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

    }).catchError((e) {
      print('error ${e}');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: '${e}',
      ).show();
    });
  }
  _permission() async {
    bool serviceEnabled;
    LocationPermission permission;

// Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    print('permission ${permission}');
    if(permission==LocationPermission.whileInUse){
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'success',
        desc: 'The location has been taken successfully',
      ).show();
    }
    if (permission == LocationPermission.denied) {
      print('permission == LocationPermission.denied');
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: 'Location Permission Denied',
        ).show();
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Location permissions are permanently denied, we cannot request permissions.',
      ).show();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }
}
