import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketConnection {
 static io.Socket? socket;
 static String messageTankerResponseToYou='';

 static Future<void> initializeAppSocket() async {
    print('Connecting to the server...');
    socket = io.io('https://handlerequests.onrender.com/',
        <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();
    print(socket!.connected);
    print('Connected to the server.');
    print('Emitting a chat message...');

 }


 static requestDisplayTankers() {
   socket!.emit('requestDisplayTankers', {
     'requestMessage': 'Hello, Tanker!',
   });}

 static saveSocketEmail(String Usertype){
  socket!.emit('saveSocketEmail', {
    'userType': '${Usertype}',
    'userEmail': '${FirebaseAuth.instance.currentUser!.email}', // Use userModel.email here
    'Message': 'Hello, saving my email! Customer',
  });
 }

    static void customerRequest(tankerEmail,String customerName,String customerPhone,double distance,)  {
      socket!.emit('customerRequest', {
        'tankerEmail': '${tankerEmail}',
        'customerEmail': '${FirebaseAuth.instance.currentUser!.email}', // Use userModel.email here
      'customerName':'${customerName}',
      'customerPhone':'${customerPhone}',
      'distance':'${distance}',
        'requestMessage':'hi tanker!',
      });
 }
 static void tankerResponseToYou() {
   socket!.on('tankerResponseToYou', (data) {
     print('tankerResponseToYou:$data');
     handleReceivedData(data);
    // messageTankerResponseToYou = '${data}';
     // Add this line to push the message to the stream

   });
 }



 static void tankerAnswer(customerEmail,message)  {
   socket!.emit('tankerResponse', {
     'tankerEmail': '${FirebaseAuth.instance.currentUser!.email}',
     'customerEmail': '${customerEmail}', // Use userModel.email here
     'Response': '${message}',
   });
 }
 static void customerRequestedYou() {
   socket!.on('customerRequestedYou', (data) {
     print('Customer received response:$data');

   });
 }

  static  List<String> displayTankers() {
      List<String> emails = [];

     socket!.on('displayTankers', (data) {
        emails = data.keys.toList();
        print('Emails 1233: $emails');

      });
      print(' outside Emails: $emails');
      return emails;
    }
 static void handleReceivedData(dynamic data) {
   if (data != null && data is Map<String, dynamic>) {
     String response = data['Response'];
       messageTankerResponseToYou = '$response';

   }
 }

}
