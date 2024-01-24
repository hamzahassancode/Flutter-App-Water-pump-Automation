import 'package:flutter/material.dart';

import '../../../constants.dart';

class UserOrTanker extends StatelessWidget {
  const UserOrTanker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('SignUP',style: TextStyleNew(20),),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('signupScreen');
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor, elevation: 10),
              child: Text(
                "as user".toUpperCase(),
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            Hero(
              tag: "signup_btn",
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('TankerSignUpPage');
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryLightColor, elevation: 10),
                child: Text(
                  "as tanker".toUpperCase(),
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElevatedButton({
    required String label,
    required VoidCallback onPressed,
    ButtonStyle? buttonStyle,
    TextStyle? textStyle,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Text(
        label.toUpperCase(),
        style: textStyle,
      ),
    );
  }
}
