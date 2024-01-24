import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/repo/Tanker_repositry.dart';
import '../components/designUI.dart';
import '../location.dart';
import '../model/TankerModel.dart';
import 'SocketConnection.dart';

class RequestTank extends StatefulWidget {
  final String email;
  final String name;
  final String phone;
  final double longitude;
  final double latitude;

  RequestTank({required this.email, required this.name, required this.phone, required this.longitude, required this.latitude});

  @override
  _RequestTankState createState() => _RequestTankState();
}

class _RequestTankState extends State<RequestTank> {
  bool _isMounted = false;

  double distance = 0.0;
  String messageTankerResponseToYou = '';
  String responseM = '';
  @override
  void initState() {
    super.initState();
    _isMounted = true;

    SocketConnection.saveSocketEmail('Customer');

    SocketConnection.socket!.on('tankerResponseToYou', (data) {
      if (_isMounted) {
        print('tankerResponseToYou:$data');
        setState(() {
          handleReceivedData(data);

        });
      }
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      messageTankerResponseToYou=SocketConnection.messageTankerResponseToYou;
      // SocketConnection.socket!.on('tankerResponseToYou', (data) {
      //   if (_isMounted) {
      //
      //     setState(() {
      //       messageTankerResponseToYou = '${data}';
      //       print('_refreshData messageTankerResponseToYou data :$messageTankerResponseToYou');
      //       messageTankerResponseToYou=SocketConnection.messageTankerResponseToYou;
      //       print('_refreshData SocketConnection.messageTankerResponseToYou :$messageTankerResponseToYou');
      //
      //     });
      //   }
      // });

    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      messageTankerResponseToYou=SocketConnection.messageTankerResponseToYou;

    });
    return Scaffold(
      backgroundColor: perfictBlue,
      appBar: customAppBar(context, "Request tanker"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: RefreshIndicator(
              onRefresh: () => _refreshData(),
              child: FutureBuilder<Map<String, dynamic>>(
                future: TankerRepository().getDataTankerWithEmail(widget.email),
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

                    double customerLongitude = widget.longitude;
                    double customerLatitude = widget.latitude;
                    double tankerLongitude = tankerModel.longitude!.toDouble();
                    double tankerLatitude = tankerModel.latitude!.toDouble();

                    distance = calculateDistance(
                      customerLongitude,
                      customerLatitude,
                      tankerLongitude,
                      tankerLatitude,
                    );

                    return ListView(
                      children: [
                        Text(
                          'i am ${tankerModel.name}',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Divider(),
                        SizedBox(height: 16.0),
                        Text(
                          'my email is : ${tankerModel.email}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Phone Number : ${tankerModel.phoneNumber}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Price of a liter of water : ${tankerModel.pricePerL} JD',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Distance: ${distance.toStringAsFixed(2)} Km',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(messageTankerResponseToYou.length == 0 ? 'no response until now' : '${messageTankerResponseToYou}',
                          style: TextStyle(
                              color:messageTankerResponseToYou=='accept'?Colors.green:Colors.red,
                              fontSize: 20

                          ),),
                        //Text(responseM.length == 0 ? 'no response until now' : '${responseM}',),

                        SizedBox(height: 8.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: perfictBlue,
                          ),
                          child: Text("request Tanker"),
                          onPressed: () async {
                            SocketConnection.customerRequest(widget.email, widget.name, widget.phone, distance);
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.rightSlide,
                              title: 'success',
                              desc: 'request tank done successfully',
                            ).show();
                          },
                        ),
                        SizedBox(height: 8.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: perfictBlue,
                          ),
                          child: Text("cancel"),
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
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _isMounted = false;
  }
   void handleReceivedData(dynamic data) {
    if (data != null && data is Map<String, dynamic>) {
      String response = data['Response'];
      messageTankerResponseToYou = '$response';

    }
  }
}
