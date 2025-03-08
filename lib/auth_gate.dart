import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:field_flow/homepage.dart';
import 'package:field_flow/role_selection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: CircularProgressIndicator(),
            );
          }

          final user = snapshot.data;
          if (user == null) {
            return LoginPage();
          }

          return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Scaffold(
                    body: CircularProgressIndicator(),
                  );
                }

                final userDoc = snapshot.data!;
                if (!userDoc.exists || userDoc['role'] == null) {
                  return UserRoleSelectionPage(user: user);
                }

                return Homepage();
              });
        });
  }
}
