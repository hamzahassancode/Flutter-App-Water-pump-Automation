import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/model/TankerModel.dart';
import 'package:flutter_auth/repo/Tanker_repositry.dart';
import 'package:flutter_auth/repo/user_repositry.dart';
import 'package:geolocator/geolocator.dart';
import '../../../components/designUI.dart';
import '../../../model/UserModel.dart';
import '../TankerSocket/TankerSystemPage2.dart';

class editTankerDataPage extends StatefulWidget {
  @override
  _editTankerDataPageState createState() => _editTankerDataPageState();
}

class _editTankerDataPageState extends State<editTankerDataPage> {
  bool notificationEnabled = true;
  bool darkModeEnabled = false;
  double textSize = 16.0;
  String selectedLanguage = 'English';
  String selectedTheme = 'Light';
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  TextEditingController _pricePerLController = TextEditingController();
  TextEditingController _waterTimeArrivalController = TextEditingController();
  TextEditingController _groundAutoModeController = TextEditingController();
  TextEditingController _roofAutoModeController = TextEditingController();
  UserRepository userRepository = UserRepository();
  Position? _currentPosition;
  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TankerPageColor,
      appBar: customAppBarTanker(context, 'Edit Your Data'),
      body: FutureBuilder<Map<String, dynamic>>(
        future: TankerRepository().getDataTanker(),
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
            TankerModel tankerModel = TankerModel.fromJson(userData);

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
                        tankerModel?.name ?? '',
                      ),
                      onTap: () {
                        _showEditDialog(
                          'Edit Name',
                          _usernameController,
                          tankerModel?.name ?? '',
                              (value) {
                            setState(() {
                              tankerModel.name = value;
                              userRepository.updateFirestoreData('name', value, 'Tankers', tankerModel!.email.toString());
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
                        tankerModel?.phoneNumber ?? '',
                      ),
                      onTap: () {
                        _showEditDialog(
                          'Edit Phone',
                          _phoneController,
                          tankerModel?.phoneNumber ?? '',
                              (value) {
                            setState(() {
                              tankerModel.phoneNumber = value;
                              userRepository.updateFirestoreData('phoneNumber', value, 'Tankers', tankerModel!.email.toString());
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('price per L'),
                      subtitle: Text(
                        '${tankerModel?.pricePerL}' ?? '',
                      ),
                      onTap: () {
                        _showEditDialog(
                          'Edit Price per L',
                          _pricePerLController,
                          '${tankerModel?.pricePerL}'  ?? '',
                              (value) {
                            setState(() {
                              tankerModel.pricePerL = value as double?;
                              userRepository.updateFirestoreData('pricePerL', value, 'Tankers', tankerModel!.email.toString());
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
                      subtitle: Text("LAT: ${tankerModel.latitude}, LNG: ${tankerModel.longitude}" ?? ''),
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
                                  userRepository.updateFirestoreData('latitude', _currentPosition!.latitude, 'Tankers', tankerModel.email.toString());
                                  userRepository.updateFirestoreData('longitude', _currentPosition!.longitude, 'Tankers', tankerModel.email.toString());
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
                      backgroundColor: TankerPageColorDark,
                    ),
                    child:Text("DONE"),
                    onPressed: () async {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TankerPage2(),
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
