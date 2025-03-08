import 'package:field_flow/auth_gate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignOutBtn extends StatelessWidget {
  const SignOutBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => AuthGate()));
        },
        child: Text('Sign Out'));
  }
}
