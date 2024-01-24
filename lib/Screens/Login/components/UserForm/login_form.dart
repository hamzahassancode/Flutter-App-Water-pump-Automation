import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Signup/components/UserORTanker.dart';
import 'package:flutter_auth/network/local/cache_helper.dart';
import '../../../../components/already_have_an_account_acheck.dart';
import '../../../../constants.dart';
import '../../../../model/UserType.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserType _selectedUserType = UserType.SimpleUser;
  Future loginLogic() async {
    try {
      FocusScope.of(context).unfocus();
////////verified
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       ).then((value) async {
//         final QuerySnapshot userQuery = await FirebaseFirestore.instance.
//         collection('Users').where('email', isEqualTo:  _emailController.text.trim()).get();
//         //just tell me if the user is exsit or not
//
//         if ( userQuery.docs.isEmpty && _selectedUserType==UserType.TankerUser&& FirebaseAuth.instance.currentUser!.emailVerified) {
//           Navigator.of(context).pushNamed('TankerSystemPage');
//           CacheHelper.saveData(key: 'Credential', value: 'TankerSystemPage');
//         } else if(userQuery.docs.isNotEmpty && _selectedUserType==UserType.SimpleUser && FirebaseAuth.instance.currentUser!.emailVerified) {
//           Navigator.of(context).pushNamed('Onboarding');
//           CacheHelper.saveData(key: 'Credential', value: 'SimpleUser');
//
//         }else if (!FirebaseAuth.instance.currentUser!.emailVerified){
//           AwesomeDialog(
//             context: context,
//             dialogType: DialogType.info,
//             animType: AnimType.rightSlide,
//             title: 'Verification',
//             desc: 'check your email to Verification',
//           ).show();
//
//         }else{
//           AwesomeDialog(
//             context: context,
//             dialogType: DialogType.error,
//             animType: AnimType.rightSlide,
//             title: 'Error',
//             desc: 'Login failed. Please check your user type.',
//           ).show();}});
/////////////////////////////////////
    //////////////////not verified
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ).then((value) async {
        final QuerySnapshot userQuery = await FirebaseFirestore.instance.
        collection('Users').where('email', isEqualTo:  _emailController.text.trim()).get();
        //just tell me if the user is exsit or not

        if ( userQuery.docs.isEmpty && _selectedUserType==UserType.TankerUser) {
          Navigator.of(context).pushNamed('TankerPage2');
          CacheHelper.saveData(key: 'Credential', value: 'TankerPage2');
        } else if(userQuery.docs.isNotEmpty && _selectedUserType==UserType.SimpleUser ) {
          Navigator.of(context).pushNamed('Onboarding');
          CacheHelper.saveData(key: 'Credential', value: 'SimpleUser');

        }else{
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'Login failed. Please check your user type.',
          ).show();
        }
      });
      /////////////////////////////////////
    } catch (e) {
      print("Error during login: $e");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Login failed. Please check your email and password."),
      //     duration: Duration(seconds: 4),
      //   ),
      // );
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Login failed. Please check your email and password.',
      ).show();
      print('3');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Your email",
              prefixIcon: Icon(Icons.person),
            ),
          ),
          SizedBox(height: defaultPadding),
          TextFormField(
            controller: _passwordController,
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: kPrimaryColor,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Your password",
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          SizedBox(height: defaultPadding),

          ListTile(
            title: Text("User Type"),
            subtitle: Row(
              children: [
                Row(
                  children: [
                    Radio(
                      value: UserType.SimpleUser,
                      groupValue: _selectedUserType,
                      onChanged: (value) {
                        setState(() {
                          _selectedUserType = value as UserType;
                        });
                      },
                    ),
                    Text("Simple User"),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: UserType.TankerUser,
                      groupValue: _selectedUserType,
                      onChanged: (value) {
                        setState(() {
                          _selectedUserType = value as UserType;
                        });
                      },
                    ),
                    Text("Tanker User"),
                  ],
                ),
              ],
            ),
          ),

          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  loginLogic();
                }
              },
              child: Text("Login".toUpperCase()),
            ),
          ),
          SizedBox(height: 7),

          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return UserOrTanker();
                  },
                ),
              );
            },
          ),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamed('PasswordResetPage');
          }, child: Text('forget password ?',style: TextStyle(fontSize: 10),)),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
