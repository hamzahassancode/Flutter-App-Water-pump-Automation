import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth/repo/Tanker_repositry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/repo/user_repositry.dart';
import '../../../components/designUI.dart';
import '../../../model/UserModel.dart';
import '../../model/TankerModel.dart';
import '../../soket/SocketConnection.dart';
import '../components/NavBarTanker.dart';
import 'answerRequsetTanker.dart';

class TankerPage2 extends StatefulWidget {
  @override
  _TankerPage2State createState() => _TankerPage2State();
}

class _TankerPage2State extends State<TankerPage2> {
  bool _isMounted = false;
  UserRepository userRepository = UserRepository();

  String tankerEmailM = "";
  String customerEmailM = "";
  String customerNameM = "";
  String customerPhoneM = "";
  String distanceM = "";
  String requestMessageM = "";
  String userType = "Tanker";
  late UserModel userModel = UserModel();
  late TankerModel tanker = TankerModel();
  List<String> emails = [];
  String emailUser = '';

  Future<void> initializeSocket() async {
    await SocketConnection.saveSocketEmail('Tanker');
  }

  @override
  void initState() {
    super.initState();
    initializeSocket();
    _isMounted = true;

    SocketConnection.socket!.on('customerRequestedYou', (data) {
      if (_isMounted) {
        print('displayTankers: $data');
        print('usermodel email: ${FirebaseAuth.instance.currentUser!.email}');

        setState(() {
          emails.add('new request');
          print('Emails from customerRequestedYou _isMounted: $emails');
          handleReceivedData(data);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TankerPageColor,
      appBar: customAppBarTanker(context, 'TANKER'),
      drawer: NavBarTanker(),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(),
        child: FutureBuilder<Map<String, dynamic>>(
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
              userModel = UserModel.fromJson(userData);

              return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Icon(
                        Icons.propane_tank,
                        size: 50.0,
                        color: TankerPageColorDark,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Center(
                      child: Text(
                        'tanker request',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: TankerPageColorDark,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: emails.length == 0
                            ? Center(
                          child: Text(
                            'No request ..',
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                            : ListView.builder(
                          itemCount: emails.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 2.0,
                              child: ListTile(
                                title: Text('$customerNameM ${index + 1}'),
                                subtitle: Text(emails[index]),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AnswerRequestTank(email: customerEmailM, distance: distanceM),
                                    ),
                                  );

                                  setState(() {
                                    emails.removeAt(index);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    Map<String, dynamic> updatedData = await TankerRepository().getDataTanker();
    setState(() {
      userModel = UserModel(
        name: updatedData['name'],
        email: updatedData['email'],
      );
      // You may need to clear and re-populate the 'emails' list as well
      // Handle other updates based on your application logic
    });
  }

  @override
  void dispose() {
    super.dispose();
    _isMounted = false;
  }

  void handleReceivedData(dynamic data) {
    if (data != null && data is Map<String, dynamic>) {
      String tankerEmail = data['tankerEmail'];
      String customerEmail = data['customerEmail'];
      String customerName = data['customerName'];
      String customerPhone = data['customerPhone'];
      String distance = data['distance'];
      String requestMessage = data['requestMessage'];

      print('Tanker Email: $tankerEmail');
      print('Customer Email: $customerEmail');
      print('Request Message: $requestMessage');

      setState(() {
        tankerEmailM = '$tankerEmail';
        customerEmailM = '$customerEmail';
        customerNameM = '$customerName';
        customerPhoneM = '$customerPhone';
        distanceM = '$distance';
        requestMessageM = '$requestMessage';
      });
    }
  }
}
