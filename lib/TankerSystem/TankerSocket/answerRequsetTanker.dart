import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/TankerSystem/TankerSocket/TankerSystemPage2.dart';
import 'package:flutter_auth/repo/Tanker_repositry.dart';
import 'package:flutter_auth/repo/user_repositry.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../components/designUI.dart';
import '../../model/TankerModel.dart';
import '../../model/UserModel.dart';
import '../../soket/SocketConnection.dart';
import '../components/NavBarTanker.dart';

class AnswerRequestTank extends StatefulWidget {
  final String email;
  String distance;

  // Constructor to take email as a required parameter
  AnswerRequestTank({required this.email,required this.distance,});
  @override
  _AnswerRequestTankState createState() => _AnswerRequestTankState();
}

class _AnswerRequestTankState extends State<AnswerRequestTank> {
  bool _isMounted = false;
  String messageTankerResponseToYou='';
  @override

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    _isMounted = true;
    SocketConnection.saveSocketEmail('Tanker');

    SocketConnection.socket!.on('tankerResponseToYou', (data) {
      if (_isMounted) {
        print('tankerResponseToYou:$data');
        setState(() {
          messageTankerResponseToYou = '${data}';
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: TankerPageColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: TankerPageColor,
        elevation: 5,
        title: Text(
          'Request',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications button press
              Navigator.of(context).pushNamed('NotificationPageTanker');
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('SettingsPageTanker');
            },
          ),
        ],
      ),
      drawer: NavBarTanker(),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<Map<String, dynamic>>(
              future: UserRepository().getDataUserWithEmail(widget.email),
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
                  UserModel userModel= UserModel(
                    name: userData['name'],
                    email: userData['email'],
                    phoneNumber: userData['phoneNumber'],
                    latitude: userData['latitude'],
                    longitude: userData['longitude'],
                  );

                  return ListView(
                    children: [
                      Text('i am ${userModel.name}',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Divider(),
                      SizedBox(height: 16.0),
                      Text(
                        'email : ${userModel.email}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Phone Number : ${userModel.phoneNumber}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Distance: ${widget.distance} Km',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      SizedBox(height: 8.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TankerPageColorDark,
                        ),
                        child:Text("accept"),
                        onPressed: () async {
                          SocketConnection.tankerAnswer(widget.email,'accept');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TankerPage2(),
                            ),
                          );
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.rightSlide,
                            title: 'success',
                            desc: 'accept the request done successfully',
                          ).show();

                        },
                      ),
                      SizedBox(height: 8.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TankerPageColorDark,
                        ),
                        child:Text("reject"),
                        onPressed: () async {
                          print('pppp');
                          SocketConnection.tankerAnswer(widget.email,'reject');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TankerPage2(),
                            ),
                          );
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.rightSlide,
                            title: 'success',
                            desc: 'accept the request done successfully',
                          ).show();

                        },
                      ),
                      SizedBox(height: 8.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TankerPageColorDark,
                        ),
                        child:Text("cancel"),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _isMounted = false;

  }
}
