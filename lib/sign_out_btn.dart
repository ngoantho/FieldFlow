import 'package:field_flow/auth_gate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignOutBtn extends StatelessWidget {
  const SignOutBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
          GoogleSignIn().signOut();

          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => AuthGate()));
        },
        child: Text('Sign Out'));
  }
}
