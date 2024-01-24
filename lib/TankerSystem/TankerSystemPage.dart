import 'package:flutter/material.dart';
import 'package:flutter_auth/TankerSystem/components/NavBarTanker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/designUI.dart';
import '../Screens/System/components/NavBar.dart';


class TankerSystemPage extends StatefulWidget {

  @override
  _TankerSystemPageState createState() => _TankerSystemPageState();
}

class _TankerSystemPageState extends State<TankerSystemPage> {
  late List<bool> readStatus;
  late SharedPreferences prefs;
  final List<String> notifications=['tanker1'];
  @override
  void initState() {
    super.initState();
    _initializeReadStatus();
  }



  _initializeReadStatus() async {
    prefs = await SharedPreferences.getInstance();

    // Initialize the read status list from SharedPreferences
    readStatus = List.generate(notifications.length, (index) {
      return prefs.getBool('readStatus_$index') ?? false;
    });

    setState(() {

    });
  }

  _saveReadStatus() {
    // Save the read status list to SharedPreferences
    for (int i = 0; i < notifications.length; i++) {
      prefs.setBool('readStatus_$i', readStatus[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (readStatus == null) {
      // Handle the case where readStatus is not initialized yet
      return CircularProgressIndicator();
    }

    return Scaffold(
      backgroundColor: TankerPageColor,
      appBar: customAppBarTanker(context,'TANKER'),
      drawer: NavBarTanker(),
      body: Container(
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
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(notifications[index]),
                    onDismissed: (direction) {
                      setState(() {
                        notifications.removeAt(index);
                        readStatus.removeAt(index);
                        _saveReadStatus();
                      });
                    },
                    background: Container(
                      color: Colors.redAccent,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _showNotificationDialogTanker(context,'hamza','4564654645654');
                        setState(() {
                          // Mark the notification as read when tapped
                          readStatus[index] = true;
                          _saveReadStatus();
                        });
                      },
                      child: Card(
                        elevation: 2.0,
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        color:Colors.white,
                        child: ListTile(
                          title: Text(
                           notifications[index],
                            style: TextStyle(fontSize: 18.0),
                          ),
                          leading: Icon(
                            Icons.notifications_active,
                            color: readStatus[index]
                                ? Colors.grey
                                : TankerPageColorDark,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  String tankerMessage(String username, String phoneNumber) {
    String message = 'From : $username,\n\n';
    message += 'A tanker request has been made for phone number $phoneNumber. ';
    message += 'Please review and respond accordingly.';

    return message;
  }


  void _showNotificationDialogTanker(BuildContext context, String username, String phoneNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('tanker request'),
          content: Text(tankerMessage(username, phoneNumber)),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('accept'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('regect'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
