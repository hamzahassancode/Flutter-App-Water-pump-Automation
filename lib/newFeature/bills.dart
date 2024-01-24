import 'package:flutter/material.dart';
import 'package:flutter_auth/repo/user_repositry.dart';
import '../../components/designUI.dart';
import '../../model/UserModel.dart';

class Billing extends StatefulWidget {
  @override
  _BillingState createState() => _BillingState();
}

class _BillingState extends State<Billing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: perfictBlue,
      appBar: customAppBar(context, 'Billing '),
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
            Map<String, dynamic> UserData = snapshot.data!;
            print('tanker data ${UserData}');
            UserModel userModel = UserModel.fromJson(UserData);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 10,
                        shadowColor: Colors.black,
                        child: ListTile(
                          title: Text(
                            'Daily Bills',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          subtitle: Text(
                            '${userModel.dailyBills.toString()} L',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      SizedBox(height: 12.0),
                      Card(
                        elevation: 10,
                        shadowColor: Colors.black,
                        child: ListTile(
                          title: Text(
                            'Monthly Bills',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          subtitle: Text(
                            '${userModel.monthlyBills.toString()} L',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'For accurate billing, please visit the Ministry of Water website provided. Enter the volume in cubic meters, considering each liter as a thousand cubic centimeters. The website will then provide you with the exact bill. Thank you for your cooperation.',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),

                      Text('https://watercalc.gov.jo/'),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
