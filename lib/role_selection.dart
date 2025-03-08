import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

class UserRoleSelectionPage extends StatelessWidget {
  final User user;

  const UserRoleSelectionPage({super.key, required this.user});

  _setRole(BuildContext context, String role) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({'role': role}, SetOptions(merge: true));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => Homepage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Select Your Role')),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Please select your role:', style: TextStyle(fontSize: 20)),
          ElevatedButton(
              onPressed: () => _setRole(context, 'Field Worker'),
              child: Text('Field Worker')),
          ElevatedButton(
              onPressed: () => _setRole(context, 'Manager'),
              child: Text('Manager')),
        ])));
  }
}
