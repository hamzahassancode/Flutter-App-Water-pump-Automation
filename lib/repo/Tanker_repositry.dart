import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/TankerModel.dart';

// TankerRepository class handles interactions with Firebase for Tanker users
class TankerRepository {

  // Method for signing up a new Tanker user
  Future signUpTanker(BuildContext context, _nameController, _emailController, _passwordController, _phoneController, longitude, latitude) async {
    try {
      // Create a new user with email and password using Firebase Authentication
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ).then((value) {
        // Create a TankerModel object with user details
        final user = TankerModel(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          userType: 'TankerUser',
          phoneNumber: _phoneController.text.trim(),
          longitude: longitude ?? 0.1,
          latitude: latitude ?? 0.1,
          isAvailable: false,
          arrivalTime: '1 hour',
          pricePerL: 11.5,
        );
        // If createUserWithEmailAndPassword is successful, proceed to create the user in Firestore
        createUser(context, user);
        // Additional logic or navigation if needed after both operations
        Navigator.of(context).pushNamed('loginScreen');
      });

    } catch (error) {
      // Handle errors during user creation
      print('Error creating user: $error');
      // Show error message using a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The email address is already used. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Method to create a user in Firestore
  Future<void> createUser(BuildContext context, TankerModel user) async {
    try {
      // Add the user details to the 'Tankers' collection in Firestore
      await FirebaseFirestore.instance.collection('Tankers').doc(user.email).set(user.toJson());
      // Show success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your account has been created.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error, stackTrace) {
      // Handle errors during Firestore user creation
      print('Error: $error');
      print('StackTrace: $stackTrace');
      // Show error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something wrong. Try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Method to retrieve Tanker user data from Firestore
  Future<Map<String, dynamic>> getDataTanker() async {
    // Get the current authenticated Tanker user
    User? tankerUser = FirebaseAuth.instance.currentUser;
    // Retrieve data from Firestore for the current user
    final DocumentSnapshot TankerDoc =
    await FirebaseFirestore.instance.collection('Tankers').doc(tankerUser!.email).get();

    // Extract relevant data from the Firestore document
    Map<String, dynamic> tankerData = {
      'name': TankerDoc.get('name'),
      'email': TankerDoc.get('email'),
      'userType': TankerDoc.get('userType'),
      'phoneNumber': TankerDoc.get('phoneNumber'),
      'longitude': TankerDoc.get('longitude'),
      'latitude': TankerDoc.get('latitude'),
      'pricePerL': TankerDoc.get('pricePerL'),
      'arrivalTime': TankerDoc.get('arrivalTime'),
    };
    print('form tankerData : ${tankerData}');

    return tankerData;
  }

  // Method to retrieve Tanker user data from Firestore using email
  Future<Map<String, dynamic>> getDataTankerWithEmail(email) async {
    // Retrieve data from Firestore for the specified user email
    final DocumentSnapshot TankerDoc =
    await FirebaseFirestore.instance.collection('Tankers').doc(email).get();

    // Extract relevant data from the Firestore document
    Map<String, dynamic> tankerData = {
      'name': TankerDoc.get('name'),
      'email': TankerDoc.get('email'),
      'userType': TankerDoc.get('userType'),
      'phoneNumber': TankerDoc.get('phoneNumber'),
      'longitude': TankerDoc.get('longitude'),
      'latitude': TankerDoc.get('latitude'),
      'pricePerL': TankerDoc.get('pricePerL'),
      'arrivalTime': TankerDoc.get('arrivalTime'),
    };
    print('form tankerData : ${tankerData}');

    return tankerData;
  }

  // Method to update a field in Firestore for a Tanker user
  void updateFirestoreData(String fieldName, dynamic value, String collectionName, String documentEmail) async {
    try {
      // Reference to the Firestore document to be updated
      DocumentReference documentReference = FirebaseFirestore.instance.collection(collectionName).doc(documentEmail);
      // Update the specified field in the document
      await documentReference.update({
        fieldName: value,
      });

      print('Document updated successfully');
    } catch (e) {
      // Handle errors during document update
      print('Error updating document: $e');
    }
  }

}
