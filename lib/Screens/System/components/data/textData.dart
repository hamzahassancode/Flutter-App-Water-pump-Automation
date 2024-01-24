import 'package:flutter/material.dart';
import 'package:flutter_auth/model/UserModel.dart';
import 'package:flutter_auth/network/local/cache_helper.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../components/designUI.dart';
import '../../../../repo/user_repositry.dart';

class ImportantDataWidget extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ImportantDataWidget({required this.userData});

  @override
  State<ImportantDataWidget> createState() => _ImportantDataWidgetState();
}

class _ImportantDataWidgetState extends State<ImportantDataWidget> {
  bool isAutomaticMode = false;
  UserRepository userRepository = UserRepository();
  @override
  void initState() {
    super.initState();

    // Retrieve the saved value of isAutomaticMode when the widget is created
    isAutomaticMode = CacheHelper.getBoolean(key: 'isAutomaticMode') ?? false;
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(20.0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          SizedBox(height: 10),
          Text(
            "Tank :",
            style: TextStyle(fontSize: 24, color: Colors.blueAccent, fontWeight: FontWeight.bold),
          ),
          Text(
            'Roof tank contain : ${widget.userData['cmRoof']} % \n Ground tank contain :  ${widget.userData['cmGround']} %',
            style: TextStyle(fontSize: 18, color: Colors.blueAccent),
            textAlign: TextAlign.center,
          ),
          // UserRepository().getImportantDataText(widget.userData),
          //
          Text(
            widget.userData['isAutomaticMode'] ? 'Tank Automatic mode is active' : '',
            style: TextStyle(
              fontSize: 16,
              color: widget.userData['isAutomaticMode'] ? Colors.green : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          Text(
            "Solar geyser :",
            style: TextStyle(fontSize: 24, color: Colors.blueAccent, fontWeight: FontWeight.bold),
          ),
          Text(
            'Water temperature  : ${widget.userData['waterTemp']} ',
            style: TextStyle(fontSize: 18, color: Colors.blueAccent),
            textAlign: TextAlign.center,
          ),
          Text(
            widget.userData['isAutomaticModeSolar'] ? 'Solar geyser Automatic mode is active' : '',
            style: TextStyle(
              fontSize: 16,
              color:  widget.userData['isAutomaticModeSolar'] ? Colors.green : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),


        ],
      ),
    );
  }
}
