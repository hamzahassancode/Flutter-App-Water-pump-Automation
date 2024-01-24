import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth/soket/requsetTanker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/repo/user_repositry.dart';
import '../../../components/designUI.dart';
import '../../../model/UserModel.dart';
import '../model/TankerModel.dart';
import 'SocketConnection.dart';

class AskForTanker extends StatefulWidget {
  @override
  _AskForTankerState createState() => _AskForTankerState();
}

class _AskForTankerState extends State<AskForTanker> {
  bool _isMounted = false;
  UserRepository userRepository = UserRepository();

  String datare = "";
  String data2 = "";
  String userType = "Tanker";
  late UserModel userModel = UserModel();
  late TankerModel tanker = TankerModel();
  List<String> emails = [];
   String emailUser='';

  Future<void> initializeSocket() async {
    //socket = SocketConnection.socket;
   await SocketConnection.saveSocketEmail('Customer');
    SocketConnection.requestDisplayTankers();

  }
  @override
  void initState() {
    super.initState();
    initializeSocket();
    _isMounted = true;

    SocketConnection.socket!.on('displayTankers', (data) {
      if (_isMounted) {
        print('displayTankers: $data');
        print('usermodel email: ${FirebaseAuth.instance.currentUser!.email}');

        setState(() {
          datare = 'displayTankers$data';
          emails = data.keys.toList();
          print('Emails from displayTankers _isMounted: $emails');
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: perfictBlue,
      appBar: customAppBar(context, 'Ask For Tanker'),
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
             userModel = UserModel.fromJson(userData);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: emails.length==0
                  ?Center(child: Text('No tanker Available Now..',style: TextStyle(fontSize: 20),))
                  :
              ListView.builder(
                itemCount: emails.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Tanker ${index + 1}'),
                      subtitle: Text(emails[index]),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestTank(email: '${emails[index]}',name: userModel.name.toString(),phone: userModel.phoneNumber.toString(),longitude: userModel.longitude!.toDouble(),latitude: userModel.latitude!.toDouble(),), // Replace with the actual email
                          ),
                        );

                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _isMounted = false;
    emails=[];
  }


}
