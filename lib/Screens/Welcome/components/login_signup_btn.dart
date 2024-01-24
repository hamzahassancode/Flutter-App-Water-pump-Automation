import 'package:flutter/material.dart';

import '../../../constants.dart';

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: "login_btn",
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('loginScreen');
            },
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Hero(
          tag: "signup_btn",
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('UserOrTanker');
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryLightColor, elevation: 0),
            child: Text(
              "Sign Up".toUpperCase(),
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
