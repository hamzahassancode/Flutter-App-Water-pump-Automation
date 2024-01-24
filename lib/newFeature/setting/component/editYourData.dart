import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/repo/user_repositry.dart';
import 'package:geolocator/geolocator.dart';
import '../../../components/designUI.dart';
import '../../../model/UserModel.dart';
import '../../CurvedBottomNavBar.dart';

class EditYourDataPage extends StatefulWidget {
  @override
  _EditYourDataPageState createState() => _EditYourDataPageState();
}

class _EditYourDataPageState extends State<EditYourDataPage> {
  bool notificationEnabled = true;
  bool darkModeEnabled = false;
  double textSize = 16.0;
  String selectedLanguage = 'English';
  String selectedTheme = 'Light';
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  TextEditingController _tempPercentageAutoModeController = TextEditingController();
  TextEditingController _roofAutoModeController = TextEditingController();
  TextEditingController _groundAutoModeController = TextEditingController();

  UserRepository userRepository = UserRepository();
  Position? _currentPosition;
  String _selectedDay = 'Sunday';

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: perfictBlue,
      appBar: customAppBar(context, 'Edit Your Data'),
      body: FutureBuilder<Map<String, dynamic>>(
        future: UserRepository().getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error} ');
          } else {
            Map<String, dynamic> userData = snapshot.data!;
            print('tanker data $userData');
            UserModel userModel = UserModel.fromJson(userData);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // ... other ListTile widgets ...

                  Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Name'),
                      subtitle: Text(
                        userModel?.name ?? '',
                      ),
                      onTap: () {
                        _showEditDialog(
                          'Edit Name',
                          _usernameController,
                          userModel?.name ?? '',
                              (value) {
                            setState(() {
                              userModel.name = value;
                              userRepository.updateFirestoreData('name', value, 'Users', userModel!.email.toString());
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Phone'),
                      subtitle: Text(
                        userModel?.phoneNumber ?? '',
                      ),
                      onTap: () {
                        _showEditDialog(
                          'Edit Phone',
                          _phoneController,
                          userModel?.phoneNumber ?? '',
                              (value) {
                            setState(() {
                              userModel.phoneNumber = value;
                              userRepository.updateFirestoreData('phoneNumber', value, 'Users', userModel!.email.toString());
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Temp Percentage Auto Mode'),
                      subtitle: Text(
                        userModel?.tempPercentageAutoMode.toString() ?? '',
                      ),
                      onTap: () {
                        _showEditDialog(
                          'Edit Temp Percentage Auto Mode',
                          _tempPercentageAutoModeController,
                          userModel?.tempPercentageAutoMode.toString() ?? '',
                              (value) {
                            setState(() {
                              userModel.tempPercentageAutoMode = value;
                              userRepository.updateFirestoreData('tempPercentageAutoMode', userModel.tempPercentageAutoMode, 'Users', userModel.email.toString());
                            });
                          },
                        );
                      },
                    ),
                  ),


              Card(
                elevation: 2.0,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('Water Time Arrival'),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        value: _selectedDay,
                        onChanged: (value) {
                          setState(() {
                            _selectedDay = value!;
                            userRepository.updateFirestoreData(
                              'waterTimeArrival',
                              value,
                              'Users',
                              userModel!.email.toString(),
                            );
                          });
                        },
                        items: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
                            .map((day) {
                          return DropdownMenuItem<String>(
                            value: day,
                            child: Text(day),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          hintText: "Select the day",
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.timelapse_rounded),
                          ),
                        ),
                        isExpanded: true, // Adjusts the width to fill the available space
                      ),
                    ),
                  ],
                ),
              ),


              Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Roof Auto Mode'),
                      subtitle: Text(
                        userModel?.roofAutoMode.toString() ?? '',
                      ),
                      onTap: () {
                        _showEditDialog(
                          'Edit Roof Auto Mode',
                          _roofAutoModeController,
                          userModel?.roofAutoMode.toString() ?? '',
                              (value) {
                            setState(() {
                              userModel.roofAutoMode = value;
                              userRepository.updateFirestoreData('roofAutoMode', userModel.roofAutoMode, 'Users', userModel.email.toString());
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Ground Auto Mode'),
                      subtitle: Text(
                        userModel?.groundAutoMode.toString() ?? '',
                      ),
                      onTap: () {
                        _showEditDialog(
                          'Edit ground Auto Mode',
                          _groundAutoModeController,
                          userModel?.groundAutoMode.toString() ?? '',
                              (value) {
                            setState(() {
                              userModel.groundAutoMode = value;
                              userRepository.updateFirestoreData('groundAutoMode', userModel.groundAutoMode, 'Users', userModel.email.toString());
                            });
                          },
                        );
                      },
                    ),
                  ),

                  Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text("Your location"),
                      subtitle: Text("LAT: ${userModel.latitude}, LNG: ${userModel.longitude}" ?? ''),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Update Location"),
                              content: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _currentPosition != null ? Colors.grey : Colors.greenAccent,
                                ),
                                child: _currentPosition != null?Text("Your location are taken"):Text("Press to update your location"),
                                onPressed: () async {
                                  _permission();
                                  _getCurrentLocation();
                                  userRepository.updateFirestoreData('latitude', _currentPosition!.latitude, 'Users', userModel.email.toString());
                                  userRepository.updateFirestoreData('longitude', _currentPosition!.longitude, 'Users', userModel.email.toString());
                                  Navigator.pop(context); // Close the dialog after updating location
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: perfictBlueDark,
                    ),
                    child:Text("DONE"),
                    onPressed: () async {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CurvedNavPage(),
                        ),
                      );
                    },
                  ),



                ],
              ),
            );
          }
        },
      ),
    );

  }

  void _showEditDialog(
      String title,
      TextEditingController controller,
      String initialValue,
      Function(String) onValueChanged,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter $title',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onValueChanged(controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
    controller.text = initialValue;
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
