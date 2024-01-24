import 'package:flutter/material.dart';
import 'package:flutter_auth/network/local/cache_helper.dart';
import 'package:lottie/lottie.dart';

import '../../../components/designUI.dart';
import '../../../repo/user_repositry.dart';

class TankPage extends StatefulWidget {
  const TankPage({Key? key}) : super(key: key);

  @override
  _TankPageState createState() => _TankPageState();
}

class _TankPageState extends State<TankPage> {
  late Future<Stream<Map<String, dynamic>>> futureDataStream;
  UserRepository userRepository = UserRepository();
  bool isTurnedOnTank = false;
  bool isAutomaticMode = false;
  late GlobalKey<_TankPageState> pageKeyTank;

  @override
  void initState() {
    super.initState();
    pageKeyTank = GlobalKey<_TankPageState>();
    isAutomaticMode = CacheHelper.getBoolean(key: 'isAutomaticMode') ?? false;
    isTurnedOnTank = CacheHelper.getBoolean(key: 'isTurnedOnTank') ?? false;
    futureDataStream = userRepository.getDataStream();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureDataStream,
      builder: (context, AsyncSnapshot<Stream<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          Stream<Map<String, dynamic>> dataStream = snapshot.data!;
          return StreamBuilder(
            stream: dataStream,
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                Map<String, dynamic> userData = snapshot.data!;
                bool userDataIsTurnedOnTank=userData['isTurnedOnTank'];
                return Container(
                  color: Color(0xFFBAD3FF),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.all(16.0),
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       setState(() {
                      //         isAutomaticMode = !isAutomaticMode;
                      //         // Save the updated value of isAutomaticMode
                      //         CacheHelper.saveBoolean(key: 'isAutomaticMode', value: isAutomaticMode);
                      //         userData['isAutomaticMode'] = isAutomaticMode;
                      //       });
                      //       userRepository.updateFirestoreData(
                      //           'isAutomaticMode',
                      //           isAutomaticMode,
                      //           'Users',
                      //           userData['email']);
                      //
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       elevation: 10,
                      //       backgroundColor: isAutomaticMode ? Colors.green : Colors.grey,
                      //       disabledBackgroundColor: Colors.grey,
                      //       textStyle: TextStyle(color: perfictBlue), // Text color
                      //       padding: EdgeInsets.all(16), // Button padding
                      //       shape: CircleBorder(),
                      //     ),
                      //     child: Icon(
                      //             isAutomaticMode ? Icons.power : Icons.power_settings_new,
                      //             size: 20, // Adjust the size of the icon as needed
                      //           ),
                      //     // Row(
                      //     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     //   children: [
                      //     //     Text(
                      //     //       isAutomaticMode ? 'Automatic Mode' : 'Automatic Mode is Off',
                      //     //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      //     //     ),
                      //     //     Icon(
                      //     //       isAutomaticMode ? Icons.power : Icons.power_settings_new,
                      //     //       size: 20, // Adjust the size of the icon as needed
                      //     //     ),
                      //     //   ],
                      //     // ),
                      //   ),
                      // ),
                      Text(
                        userData['isTurnedOnTank'] ? 'The pump is ON' : 'The pump is OFF',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('EditYourDataPage');
                        },
                        child: Text('ground Auto Mode :${userData['groundAutoMode']}, Roof Auto Mode :${userData['roofAutoMode']}'),
                      ),
                      Lottie.network(
                        'https://lottie.host/8cf67add-e2ae-46fd-8e70-1bd984c95b2a/Wga2XhFXsq.json',
                        animate: userData['isTurnedOnTank'],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isAutomaticMode = !isAutomaticMode;
                                    // Save the updated value of isAutomaticMode
                                    CacheHelper.saveBoolean(key: 'isAutomaticMode', value: isAutomaticMode);
                                    userData['isAutomaticMode'] = isAutomaticMode;
                                  });
                                  userRepository.updateFirestoreData(
                                      'isAutomaticMode',
                                      isAutomaticMode,
                                      'Users',
                                      userData['email']);
                                },
                                icon: Icon(
                                  isAutomaticMode ? Icons.power : Icons.power_settings_new,
                                ),
                                color: isAutomaticMode ? Colors.green : Colors.grey,
                                iconSize: 35,
                              ),
                              Text(isAutomaticMode ? 'Auto mode ON':'Auto mode OFF',
                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                            ],
                          ),
SizedBox(width: 20,),
                          Transform.scale(
                            scale: 1.5,
                            child: Switch(
                              value: userData['isTurnedOnTank'],
                              onChanged: isAutomaticMode
                                  ? (userDataIsTurnedOnTank){
                                setState(() {
                                  isTurnedOnTank = userDataIsTurnedOnTank;
                                  print(userDataIsTurnedOnTank.toString());
                                });
                              }
                                  : (value) {
                                setState(() {
                                  userData['isTurnedOnTank'] = value;
                                  print(userDataIsTurnedOnTank.toString());
                                });
                                userRepository.updateFirestoreData(
                                    'isTurnedOnTank',
                                    value,
                                    'Users',
                                    userData['email']);
                                CacheHelper.putBoolean(
                                    key: 'isTurnedOnTank',
                                    value: value);
                              },
                              inactiveThumbColor: Colors.black45,
                              activeColor: Colors.white,
                              activeTrackColor: Colors.green,
                            ),
                          ),
                        ],
                      ),

                      Text(
                        userData['isTurnedOnTank']
                            ? 'Will send you a notification when the tank is filled'
                            : '----',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                      Text(
                        isAutomaticMode
                            ? 'Automatic mode must be turned off to be able to control'
                            : '',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),

                    ],
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}
