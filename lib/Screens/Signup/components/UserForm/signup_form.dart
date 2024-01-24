import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_auth/Screens/Signup/components/choose_tank_photo/sliderTank/models.dart';
import 'package:flutter_auth/network/local/cache_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/repo/user_repositry.dart';
import '../../../../components/already_have_an_account_acheck.dart';
import '../../../../constants.dart';
import '../../../Login/components/login_screen.dart';
import '../choose_tank_photo/sliderTank/screensSlider/TankSlideShow.dart';


class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  UserRepository userRepository = UserRepository();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  Position? _currentPosition;
  String? _selectedTank;
  bool _isPasswordVisible=false;

  TankModel tankModel=TankModel(tankName: CacheHelper.getTankModel(key: 'TankModel')?.tankName?? 'Rectangular Water Tank', height: CacheHelper.getTankModel(key: 'TankModel')?.height ?? '1.5', width: CacheHelper.getTankModel(key: 'TankModel')?.width ??'2',length: CacheHelper.getTankModel(key: 'TankModel')?.length ?? '1.5');

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
           Card(
             elevation: 15,
             child: Padding(
               padding: const EdgeInsets.all(16.0),
               child: Column(
                 children: [
                   Text('Tank data',
                     style: TextStyleNew(20)),
                   SizedBox(height: 10,),
                   Text('Tank Name: ${tankModel.tankName}',
                     style: TextStyleNew(16),),
                   SizedBox(height: 10,),
                   Text('Height: ${tankModel.height} m',style: TextStyleNew(16),),
                   SizedBox(height: 10,),
                   Text('Width: ${tankModel.width} m',style: TextStyleNew(16),),
                   SizedBox(height: 10,),
                   Text('length: ${tankModel.length} m',style: TextStyleNew(16),),
                   SizedBox(height: 10,),
                   GestureDetector(
                     child: ElevatedButton(
                       onPressed: () async {
                         // Open a dialog or navigate to the tank selection screen
                         _selectedTank = await showDialog<String>(
                           context: context,
                           builder: (BuildContext context) {
                             // Your tank selection widget or dialog
                             // Return the selected tank
                             return TankSlideShow();
                           },
                         );
                       },
                       style: ElevatedButton.styleFrom(
                         foregroundColor: Colors.blue,
                         elevation:10,
                         backgroundColor: Colors.grey[300],
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(8.0), // Slightly larger border radius
                         ), // Color when hovered A softer color, adjust as needed
                       ),
                       child: Text(
                         "Choose Tank",
                         style: TextStyle(
                           fontSize: 16, // Slightly smaller font size
                           color: Colors.black87, // A darker text color for better visibility
                         ),
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           ),


            const SizedBox(height: defaultPadding),
            Text('--------------------'),
            const SizedBox(height: defaultPadding),
            //name
            TextFormField(
              controller: _nameController,
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
              controller: _emailController,
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
              controller: _passwordController,
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
                    await userRepository.signUp(
                      context,
                      _nameController,
                      _emailController,
                      _passwordController,
                      tankModel,
                      _phoneController,
                      _currentPosition?.longitude ?? 0.1, // Use null-aware operator
                      _currentPosition?.latitude ?? 0.1,

                    );
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

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
